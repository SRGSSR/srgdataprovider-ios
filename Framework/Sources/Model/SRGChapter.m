//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChapter.h"

#import "SRGJSONTransformers.h"

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

- (SRGProtocol)recommendedProtocol
{
    NSArray *recommendedProtocols = @[ @(SRGProtocolHLS_DVR), @(SRGProtocolHLS), @(SRGProtocolHTTPS), @(SRGProtocolHTTP) ];
    
    for (NSNumber *protocolNumber in recommendedProtocols) {
        SRGProtocol protocol = protocolNumber.integerValue;
        if ([self resourcesForProtocol:protocol].count != 0) {
            return protocol;
        }
    }
    
    return SRGProtocolNone;
}

- (NSArray<SRGResource *> *)resourcesForProtocol:(SRGProtocol)protocol
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGResource.new, protocol), @(protocol)];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@keypath(SRGResource.new, quality) ascending:NO];
    return [[self.resources filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end
