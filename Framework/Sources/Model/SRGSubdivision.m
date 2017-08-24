//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSubdivision.h"

#import "SRGJSONTransformers.h"
#import "NSURL+SRGDataProvider.h"

#import <libextobjc/libextobjc.h>

@interface SRGSubdivision ()

@property (nonatomic) SRGMediaURN *fullLengthURN;
@property (nonatomic) NSInteger position;
@property (nonatomic) NSTimeInterval markIn;
@property (nonatomic) NSTimeInterval markOut;
@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic, copy) NSString *event;
@property (nonatomic) NSDictionary<NSString *, NSString *> *analyticsLabels;
@property (nonatomic) NSDictionary<NSString *, NSString *> *comScoreAnalyticsLabels;
@property (nonatomic) NSArray<SRGSubtitle *> *subtitles;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) SRGMediaURN *URN;
@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic) SRGVendor vendor;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@property (nonatomic) SRGContentType contentType;
@property (nonatomic) SRGSource source;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) SRGBlockingReason blockingReason;
@property (nonatomic) NSURL *podcastStandardDefinitionURL;
@property (nonatomic) NSURL *podcastHighDefinitionURL;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSArray<SRGRelatedContent *> *relatedContents;
@property (nonatomic) NSArray<SRGSocialCount *> *socialCounts;

@end

@implementation SRGSubdivision

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSubdivision.new, fullLengthURN) : @"fullLengthUrn",
                       @keypath(SRGSubdivision.new, position) : @"position",
                       @keypath(SRGSubdivision.new, markIn) : @"markIn",
                       @keypath(SRGSubdivision.new, markOut) : @"markOut",
                       @keypath(SRGSubdivision.new, hidden) : @"displayable",
                       @keypath(SRGSubdivision.new, event) : @"eventData",
                       @keypath(SRGSubdivision.new, analyticsLabels) : @"analyticsMetadata",
                       @keypath(SRGSubdivision.new, comScoreAnalyticsLabels) : @"analyticsData",
                       @keypath(SRGSubdivision.new, subtitles) : @"subtitleList",
                       
                       @keypath(SRGSubdivision.new, title) : @"title",
                       @keypath(SRGSubdivision.new, lead) : @"lead",
                       @keypath(SRGSubdivision.new, summary) : @"description",
                       
                       @keypath(SRGSubdivision.new, uid) : @"id",
                       @keypath(SRGSubdivision.new, URN) : @"urn",
                       @keypath(SRGSubdivision.new, mediaType) : @"mediaType",
                       @keypath(SRGSubdivision.new, vendor) : @"vendor",
                       
                       @keypath(SRGSubdivision.new, imageURL) : @"imageUrl",
                       @keypath(SRGSubdivision.new, imageTitle) : @"imageTitle",
                       @keypath(SRGSubdivision.new, imageCopyright) : @"imageCopyright",
                       
                       @keypath(SRGSubdivision.new, contentType) : @"type",
                       @keypath(SRGSubdivision.new, source) : @"assignedBy",
                       @keypath(SRGSubdivision.new, date) : @"date",
                       @keypath(SRGSubdivision.new, duration) : @"duration",
                       @keypath(SRGSubdivision.new, blockingReason) : @"blockReason",
                       @keypath(SRGSubdivision.new, podcastStandardDefinitionURL) : @"podcastSdUrl",
                       @keypath(SRGSubdivision.new, podcastHighDefinitionURL) : @"podcastHdUrl",
                       @keypath(SRGSubdivision.new, startDate) : @"validFrom",
                       @keypath(SRGSubdivision.new, endDate) : @"validTo",
                       @keypath(SRGSubdivision.new, relatedContents) : @"relatedContentList",
                       @keypath(SRGSubdivision.new, socialCounts) : @"socialCountList" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)fullLengthURNJSONTransformer
{
    return SRGMediaURNJSONTransformer();
}

+ (NSValueTransformer *)subtitlesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGSubtitle class]];
}

+ (NSValueTransformer *)URNJSONTransformer
{
    return SRGMediaURNJSONTransformer();
}

+ (NSValueTransformer *)mediaTypeJSONTransformer
{
    return SRGMediaTypeJSONTransformer();
}

+ (NSValueTransformer *)vendorJSONTransformer
{
    return SRGVendorJSONTransformer();
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)contentTypeJSONTransformer
{
    return SRGContentTypeJSONTransformer();
}

+ (NSValueTransformer *)sourceJSONTransformer
{
    return SRGSourceJSONTransformer();
}

+ (NSValueTransformer *)dateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)blockingReasonJSONTransformer
{
    return SRGBlockingReasonJSONTransformer();
}

+ (NSValueTransformer *)hiddenJSONTransformer
{
    return SRGBooleanInversionJSONTransformer();
}

+ (NSValueTransformer *)podcastStandardDefinitionURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)podcastHighDefinitionURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)startDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)endDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)relatedContentsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGRelatedContent class]];
}

+ (NSValueTransformer *)socialCountsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGRelatedContent class]];
}

#pragma mark SRGImage protocol

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(SRGImageType)type
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value uid:self.uid type:type];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGSubdivision *otherSubdivision = object;
    return [self.URN isEqual:otherSubdivision.URN];
}

- (NSUInteger)hash
{
    return self.uid.hash;
}

@end

NSArray<SRGSubdivision *> *SRGSanitizedSubdivisions(NSArray<SRGSubdivision *> *subdivisions)
{
    NSPredicate *validSubdivisionsPredicate = [NSPredicate predicateWithBlock:^BOOL(SRGSubdivision * _Nullable subdivision, NSDictionary<NSString *,id> * _Nullable bindings) {
        return subdivision.duration > 0 && subdivision.markIn < subdivision.markOut;
    }];
    subdivisions = [subdivisions filteredArrayUsingPredicate:validSubdivisionsPredicate];
    
    if (subdivisions.count == 0) {
        return @[];
    }
    
    // Make the inventory of all mark in and mark out increasing order
    NSMutableSet<NSNumber *> *marks = [NSMutableSet set];
    [subdivisions enumerateObjectsUsingBlock:^(SRGSubdivision * _Nonnull subdivision, NSUInteger idx, BOOL * _Nonnull stop) {
        [marks addObject:@(subdivision.markIn)];
        [marks addObject:@(subdivision.markOut)];
    }];
    
    NSCAssert(marks.count >= 2, @"At least 2 marks are expected by construction");
    NSSortDescriptor *markSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray<NSNumber *> *orderedMarks = [marks sortedArrayUsingDescriptors:@[markSortDescriptor]];
    
    // For each interval defined by consecutive marks, define the subdivision resulting from the superposition of all
    // subdivisions, according to a set of fixed rules.
    NSMutableArray<SRGSubdivision *> *sanitizedSubdivisions = [NSMutableArray array];
    for (NSUInteger i = 0; i < orderedMarks.count - 1; ++i) {
        NSTimeInterval markIn = orderedMarks[i].doubleValue;
        NSTimeInterval markOut = orderedMarks[i+1].doubleValue;
        
        // Find all subdivisions which touch the mark-in and mark-out.
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(SRGSubdivision * _Nullable subdivision, NSDictionary<NSString *,id> * _Nullable bindings) {
            return subdivision.markIn <= markIn && markOut <= subdivision.markOut;
        }];
        NSArray<SRGSubdivision *> *matchingSubdivisions = [subdivisions filteredArrayUsingPredicate:predicate];
        if (matchingSubdivisions.count == 0) {
            continue;
        }
        
        // Find the winning subdivision amongst matches (from the least important to the most important one)
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES comparator:^NSComparisonResult(SRGSubdivision * _Nonnull subdivision1, SRGSubdivision * _Nonnull subdivision2) {
            // Blocked subdivision must always win.
            if (subdivision1.blockingReason != subdivision2.blockingReason) {
                if (subdivision1.blockingReason == SRGBlockingReasonNone) {
                    return NSOrderedAscending;
                }
                else if (subdivision2.blockingReason == SRGBlockingReasonNone) {
                    return NSOrderedDescending;
                }
            }
            
            // Prefer visible subdivisions.
            if (subdivision1.hidden != subdivision2.hidden) {
                return subdivision1.hidden ? NSOrderedAscending : NSOrderedDescending;
            }
            
            // Prefer subdivision starting at mark-in.
            if (subdivision1.markIn != subdivision2.markIn) {
                if (subdivision1.markIn == markIn) {
                    return NSOrderedDescending;
                }
                else if (subdivision2.markIn == markIn) {
                    return NSOrderedAscending;
                }
            }
            
            // Prefer shorter subdivisions (fine-grained structure).
            if (subdivision1.duration != subdivision2.duration) {
                if (subdivision1.duration < subdivision2.duration) {
                    return NSOrderedDescending;
                }
                else {
                    return NSOrderedAscending;
                }
            }
            
            // Order according to declared position, otherwise consider equal
            if (subdivision1.position == subdivision2.position) {
                return NSOrderedSame;
            }
            else if (subdivision1.position < subdivision2.position) {
                return NSOrderedAscending;
            }
            else {
                return NSOrderedDescending;
            }
        }];
        
        SRGSubdivision *matchingSubdivision = [[matchingSubdivisions sortedArrayUsingDescriptors:@[sortDescriptor]].lastObject copy];
        SRGSubdivision *lastSubdivision = sanitizedSubdivisions.lastObject;
        
        // Add new subdivision if different from the last one we already have.
        if (! [lastSubdivision isEqual:matchingSubdivision]) {
            matchingSubdivision.markIn = markIn;
            matchingSubdivision.markOut = markOut;
            matchingSubdivision.duration = markOut - markIn;
            [sanitizedSubdivisions addObject:matchingSubdivision];
        }
        // If the same subdivision is added again, merge with the existing one to have a single subdivision.
        else {
            lastSubdivision.markOut = markOut;
            lastSubdivision.duration = markOut - lastSubdivision.markIn;
        }
    }
    
    // Remove small non-blocked segments which might result because of the flattening.
    NSPredicate *meaningfulSubdivisionsPredicate = [NSPredicate predicateWithBlock:^BOOL(SRGSubdivision * _Nullable subdivision, NSDictionary<NSString *,id> * _Nullable bindings) {
        return subdivision.blockingReason != SRGBlockingReasonNone || subdivision.duration >= 1000;     // At least one second
    }];
    NSArray<SRGSubdivision *> *meaningfulSubdivisions = [sanitizedSubdivisions filteredArrayUsingPredicate:meaningfulSubdivisionsPredicate];
    [meaningfulSubdivisions enumerateObjectsUsingBlock:^(SRGSubdivision * _Nonnull subdivision, NSUInteger idx, BOOL * _Nonnull stop) {
        subdivision.position = idx;
    }];
    return meaningfulSubdivisions;
}
