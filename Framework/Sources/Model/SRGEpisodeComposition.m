//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGEpisodeComposition.h"

#import <libextobjc/libextobjc.h>

@interface SRGEpisodeComposition ()

@property (nonatomic) SRGChannel *channel;
@property (nonatomic) SRGShow *show;
@property (nonatomic) NSArray<SRGEpisode *> *episodes;

@end

@implementation SRGEpisodeComposition

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGEpisodeComposition.new, channel) : @"channel",
                       @keypath(SRGEpisodeComposition.new, show) : @"show",
                       @keypath(SRGEpisodeComposition.new, episodes) : @"episodeList" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)channelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGChannel.class];
}

+ (NSValueTransformer *)showJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGShow.class];
}

+ (NSValueTransformer *)episodesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGEpisode.class];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGEpisodeComposition *otherEpisodeComposition = object;
    return [self.show.URN isEqual:otherEpisodeComposition.show.URN];
}

- (NSUInteger)hash
{
    return self.show.URN.hash;
}

@end
