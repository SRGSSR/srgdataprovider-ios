//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChapter.h"

#import "SRGJSONTransformers.h"
#import "SRGSubdivision+Private.h"

#import <libextobjc/libextobjc.h>

@interface SRGChapter ()

@property (nonatomic) NSArray<SRGResource *> *resources;
@property (nonatomic) NSArray<SRGSegment *> *rawSegments;

@property (nonatomic) NSDate *preTrailerStartDate;
@property (nonatomic) NSDate *postTrailerEndDate;

@property (nonatomic) NSArray<SRGSegment *> *segments;

@end

@implementation SRGChapter

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [[super JSONKeyPathsByPropertyKey] mutableCopy];
        [mapping addEntriesFromDictionary:@{ @keypath(SRGChapter.new, resources) : @"resourceList",
                                             @keypath(SRGChapter.new, rawSegments) : @"segmentList",
                                              
                                             @keypath(SRGChapter.new, preTrailerStartDate) : @"preTrailerStart",
                                             @keypath(SRGChapter.new, postTrailerEndDate) : @"postTrailerStop" }];
        s_mapping = [mapping copy];
    });
    return s_mapping;
}

#pragma mark Getters and setters

- (NSArray<SRGSegment *> *)segments
{
    // TODO: Avoid raw segments. Implement transformer directly (better for pretty printing)
    if (! _segments) {
        _segments = SRGSubdivisionSanitize(self.rawSegments);
    }
    return _segments;
}

#pragma mark Transformers

+ (NSValueTransformer *)resourcesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGResource class]];
}

+ (NSValueTransformer *)rawSegmentsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGSegment class]];
}

+ (NSValueTransformer *)preTrailerStartDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)postTrailerEndDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

@end

@implementation SRGChapter (Resources)

+ (NSArray<NSNumber *> *)supportedStreamingMethods
{
    return @[ @(SRGStreamingMethodHLS), @(SRGStreamingMethodHTTPS), @(SRGStreamingMethodHTTP), @(SRGStreamingMethodM3UPlaylist), @(SRGStreamingMethodProgressive) ];
}

- (NSArray<SRGResource *> *)playableResources
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K IN %@", @keypath(SRGResource.new, streamingMethod), [SRGChapter supportedStreamingMethods]];
    return [self.resources filteredArrayUsingPredicate:predicate];
}

- (SRGStreamingMethod)recommendedStreamingMethod
{
    for (NSNumber *streamingMethodNumber in [SRGChapter supportedStreamingMethods]) {
        SRGStreamingMethod streamingMethod = streamingMethodNumber.integerValue;
        if ([self resourcesForStreamingMethod:streamingMethod].count != 0) {
            return streamingMethod;
        }
    }
    
    return SRGStreamingMethodNone;
}

- (NSArray<SRGResource *> *)resourcesForStreamingMethod:(SRGStreamingMethod)streamingMethod
{
    // Qualities are ordered in increasing order in the associated enum, from the lowest to the highest one, and can therefore
    // be used as is for sorting.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGResource.new, streamingMethod), @(streamingMethod)];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@keypath(SRGResource.new, quality) ascending:NO];
    return [[self.resources filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end
