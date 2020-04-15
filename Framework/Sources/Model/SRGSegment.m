//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSegment.h"

#import "SRGSubdivision+Private.h"

#import <libextobjc/libextobjc.h>

@interface SRGSegment ()

@property (nonatomic) NSTimeInterval markIn;
@property (nonatomic) NSTimeInterval markOut;
@property (nonatomic) NSDate *resourceReferenceDate;

@end

@implementation SRGSegment

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{ @keypath(SRGSegment.new, markIn) : @"markIn",
                                             @keypath(SRGSegment.new, markOut) : @"markOut" }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

@end

NSArray<SRGSegment *> *SRGSanitizedSegments(NSArray<SRGSegment *> *segments)
{
    NSPredicate *validSegmentsPredicate = [NSPredicate predicateWithBlock:^BOOL(SRGSegment * _Nullable segment, NSDictionary<NSString *,id> * _Nullable bindings) {
        return segment.duration > 0 && segment.markIn < segment.markOut;
    }];
    segments = [segments filteredArrayUsingPredicate:validSegmentsPredicate];
    
    if (segments.count == 0) {
        return @[];
    }
    
    // Make the inventory of all mark in and mark out increasing order
    NSMutableSet<NSNumber *> *marks = [NSMutableSet set];
    [segments enumerateObjectsUsingBlock:^(SRGSegment * _Nonnull segment, NSUInteger idx, BOOL * _Nonnull stop) {
        [marks addObject:@(segment.markIn)];
        [marks addObject:@(segment.markOut)];
    }];
    
    NSCAssert(marks.count >= 2, @"At least 2 marks are expected by construction");
    NSSortDescriptor *markSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray<NSNumber *> *orderedMarks = [marks sortedArrayUsingDescriptors:@[markSortDescriptor]];
    
    NSDate *currentDate = NSDate.date;
    
    // For each interval defined by consecutive marks, define the segment resulting from the superposition of all
    // segments, according to a set of fixed rules.
    NSMutableArray<SRGSegment *> *sanitizedSegments = [NSMutableArray array];
    for (NSUInteger i = 0; i < orderedMarks.count - 1; ++i) {
        NSTimeInterval markIn = orderedMarks[i].doubleValue;
        NSTimeInterval markOut = orderedMarks[i+1].doubleValue;
        
        // Find all segments which touch the mark-in and mark-out.
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(SRGSegment * _Nullable segment, NSDictionary<NSString *,id> * _Nullable bindings) {
            return segment.markIn <= markIn && markOut <= segment.markOut;
        }];
        NSArray<SRGSegment *> *matchingSegments = [segments filteredArrayUsingPredicate:predicate];
        if (matchingSegments.count == 0) {
            continue;
        }
        
        // Find the winning segment amongst matches (from the least important to the most important one)
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES comparator:^NSComparisonResult(SRGSegment * _Nonnull segment1, SRGSegment * _Nonnull segment2) {
            // Blocked segment must always win.
            SRGBlockingReason blockingReason1 = [segment1 blockingReasonAtDate:currentDate];
            SRGBlockingReason blockingReason2 = [segment2 blockingReasonAtDate:currentDate];
            if (blockingReason1 != blockingReason2) {
                if (blockingReason1 == SRGBlockingReasonNone) {
                    return NSOrderedAscending;
                }
                else if (blockingReason2 == SRGBlockingReasonNone) {
                    return NSOrderedDescending;
                }
            }
            
            // Prefer visible segments.
            if (segment1.hidden != segment2.hidden) {
                return segment1.hidden ? NSOrderedAscending : NSOrderedDescending;
            }
            
            // Prefer segment starting at mark-in.
            if (segment1.markIn != segment2.markIn) {
                if (segment1.markIn == markIn) {
                    return NSOrderedDescending;
                }
                else if (segment2.markIn == markIn) {
                    return NSOrderedAscending;
                }
            }
            
            // Prefer shorter segments (fine-grained structure).
            if (segment1.duration != segment2.duration) {
                if (segment1.duration < segment2.duration) {
                    return NSOrderedDescending;
                }
                else {
                    return NSOrderedAscending;
                }
            }
            
            return NSOrderedSame;
        }];
        
        SRGSegment *matchingSegment = [matchingSegments sortedArrayUsingDescriptors:@[sortDescriptor]].lastObject.copy;
        SRGSegment *lastSegment = sanitizedSegments.lastObject;
        
        // Add new segment if different from the last one we already have.
        if (! [lastSegment isEqual:matchingSegment]) {
            matchingSegment.markIn = markIn;
            matchingSegment.markOut = markOut;
            matchingSegment.duration = markOut - markIn;
            [sanitizedSegments addObject:matchingSegment];
        }
        // If the same segment is added again, merge with the existing one to have a single segment.
        else {
            lastSegment.markOut = markOut;
            lastSegment.duration = markOut - lastSegment.markIn;
        }
    }
    
    // Remove small non-blocked segments which might result because of the flattening.
    NSPredicate *meaningfulSegmentsPredicate = [NSPredicate predicateWithBlock:^BOOL(SRGSegment * _Nullable segment, NSDictionary<NSString *,id> * _Nullable bindings) {
        SRGBlockingReason blockingReason = [segment blockingReasonAtDate:currentDate];
        return blockingReason != SRGBlockingReasonNone || segment.duration >= 1000;     // At least one second
    }];
    return [sanitizedSegments filteredArrayUsingPredicate:meaningfulSegmentsPredicate];
}

@implementation SRGSegment (Dates)

- (NSDate *)markInDate
{
    if (self.resourceReferenceDate) {
        return [self.resourceReferenceDate dateByAddingTimeInterval:self.markIn / 1000.];
    }
    else {
        return nil;
    }
}

- (NSDate *)markOutDate
{
    if (self.resourceReferenceDate) {
        return [self.resourceReferenceDate dateByAddingTimeInterval:self.markOut / 1000.];
    }
    else {
        return nil;
    }
}

@end
