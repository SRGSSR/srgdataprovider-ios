//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChapter.h"

#import "SRGJSONTransformers.h"
#import "SRGSegment+Private.h"

@import libextobjc;

@interface SRGChapter ()

@property (nonatomic) NSArray<SRGResource *> *resources;
@property (nonatomic) NSArray<SRGSegment *> *segments;

@property (nonatomic) NSDate *preTrailerStartDate;
@property (nonatomic) NSDate *postTrailerEndDate;

@property (nonatomic) CGFloat aspectRatio;
@property (nonatomic) NSDate *resourceReferenceDate;

@end

@implementation SRGChapter

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [super JSONKeyPathsByPropertyKey].mutableCopy;
        [mapping addEntriesFromDictionary:@{ @keypath(SRGChapter.new, fullLengthMarkIn) : @"fullLengthMarkIn",
                                             @keypath(SRGChapter.new, fullLengthMarkOut) : @"fullLengthMarkOut",
                                             @keypath(SRGChapter.new, resources) : @"resourceList",
                                             @keypath(SRGChapter.new, segments) : @"segmentList",
                                             
                                             @keypath(SRGChapter.new, preTrailerStartDate) : @"preTrailerStart",
                                             @keypath(SRGChapter.new, postTrailerEndDate) : @"postTrailerStop",
                                             
                                             @keypath(SRGChapter.new, aspectRatio) : @"aspectRatio",
                                             @keypath(SRGChapter.new, resourceReferenceDate) : @"dvrReferenceDate" }];
        s_mapping = mapping.copy;
    });
    return s_mapping;
}

#pragma mark Object lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    NSDictionary *defaultDictionary = @{ @keypath(SRGChapter.new, aspectRatio) : @(SRGAspectRatioUndefined) };
    NSDictionary *dictionary = [defaultDictionary mtl_dictionaryByAddingEntriesFromDictionary:dictionaryValue];
    if (self = [super initWithDictionary:dictionary error:error]) {
        [self.segments enumerateObjectsUsingBlock:^(SRGSegment * _Nonnull segment, NSUInteger idx, BOOL * _Nonnull stop) {
            segment.resourceReferenceDate = self.resourceReferenceDate;
        }];
    }
    return self;
}

#pragma mark Transformers

+ (NSValueTransformer *)aspectRatioJSONTransformer
{
    return SRGAspectRatioJSONTransformer();
}

+ (NSValueTransformer *)resourcesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGResource.class];
}

+ (NSValueTransformer *)segmentsJSONTransformer
{
    static NSValueTransformer *s_transformer;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_transformer = [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *JSONArray, BOOL *success, NSError *__autoreleasing *error) {
            NSArray<SRGSegment *> *segments = [MTLJSONAdapter modelsOfClass:SRGSegment.class fromJSONArray:JSONArray error:error];
            if (! segments) {
                return nil;
            }
            
            return SRGSanitizedSegments(segments);
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

+ (NSValueTransformer *)resourceReferenceDateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

@end

@implementation SRGChapter (Presentation)

- (SRGPresentation)presentation
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGResource.new, presentation), @(SRGPresentation360)];
    SRGResource *resource360 = [self.resources filteredArrayUsingPredicate:predicate].firstObject;
    return resource360 ? SRGPresentation360 : SRGPresentationDefault;
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
