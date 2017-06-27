//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSong.h"

#import <libextobjc/libextobjc.h>

@interface SRGSong ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSDate *date;
@property (nonatomic, getter=isPlaying) BOOL playing;
@property (nonatomic) SRGArtist *artist;
@property (nonatomic) SRGAlbum *album;

@end

@implementation SRGSong

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSong.new, title) : @"title",
                       @keypath(SRGSong.new, date) : @"date",
                       @keypath(SRGSong.new, playing) : @"isPlayingNow",
                       @keypath(SRGSong.new, artist) : @"artist",
                       @keypath(SRGSong.new, album) : @"cd" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)artistJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGArtist class]];
}

+ (NSValueTransformer *)albumJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGAlbum class]];
}

@end
