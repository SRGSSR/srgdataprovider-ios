//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSearchResultMedia.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGSearchResultMedia ()

@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic, copy) NSString *episodeUid;
@property (nonatomic, copy) NSString *episodeTitle;
@property (nonatomic, copy) NSString *showUid;
@property (nonatomic, copy) NSString *showTitle;
@property (nonatomic, copy) NSString *channelUid;

@end

@implementation SRGSearchResultMedia

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [[super JSONKeyPathsByPropertyKey] mutableCopy];
        [mapping addEntriesFromDictionary:@{ @keypath(SRGSearchResultMedia.new, mediaType) : @"mediaType",
                                             @keypath(SRGSearchResultMedia.new, date) : @"date",
                                             @keypath(SRGSearchResultMedia.new, duration) : @"duration",
                                             @keypath(SRGSearchResultMedia.new, episodeUid) : @"episode.id",
                                             @keypath(SRGSearchResultMedia.new, episodeTitle) : @"episode.title",
                                             @keypath(SRGSearchResultMedia.new, showUid) : @"show.id",
                                             @keypath(SRGSearchResultMedia.new, showTitle) : @"show.title",
                                             @keypath(SRGSearchResultMedia.new, channelUid) : @"channelId" }];
        s_mapping = [mapping copy];
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)mediaTypeJSONTransformer
{
    return SRGMediaTypeJSONTransformer();
}

+ (NSValueTransformer *)dateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

@end
