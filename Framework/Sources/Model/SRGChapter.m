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
@property (nonatomic) NSArray<SRGSegment *> *segments;

@property (nonatomic) NSDate *preTrailerStartDate;
@property (nonatomic) NSDate *postTrailerEndDate;

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
                                             @keypath(SRGChapter.new, segments) : @"segmentList",
                                              
                                             @keypath(SRGChapter.new, preTrailerStartDate) : @"preTrailerStart",
                                             @keypath(SRGChapter.new, postTrailerEndDate) : @"postTrailerStop" }];
        s_mapping = [mapping copy];
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)resourcesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGResource class]];
}

+ (NSValueTransformer *)segmentsJSONTransformer
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *JSONArray, BOOL *success, NSError *__autoreleasing *error) {
            NSArray *objects = [MTLJSONAdapter modelsOfClass:[SRGSegment class] fromJSONArray:JSONArray error:error];
            if (! objects) {
                return nil;
            }
            
            return SRGSanitizedSubdivisions(objects);
        } reverseBlock:^id(NSArray *objects, BOOL *success, NSError *__autoreleasing *error) {
            return [MTLJSONAdapter JSONArrayFromModels:objects error:error];
        }];
    });
    return s_transformer;
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
