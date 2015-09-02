//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILComScoreAnalyticsInfos.h"
#import <SRGAnalytics/NSString+RTSAnalytics.h>
#import "SRGILModel.h"

@interface SRGILComScoreAnalyticsInfos ()
@property(nonatomic, strong) SRGILMedia *media;
@property(nonatomic, strong) NSURL *playedURL;
@end

@implementation SRGILComScoreAnalyticsInfos

+ (NSDictionary *)globalLabelsForAppEnteringForeground
{
    NSMutableDictionary *labels = [NSMutableDictionary dictionary];
    
    NSString *category = @"APP";
    NSString *srg_n1   = @"event";
    NSString *title    = @"comingToForeground";
    
    [labels setObject:category forKey:@"category"];
    [labels setObject:srg_n1   forKey:@"srg_n1"];
    [labels setObject:title    forKey:@"srg_title"];
    
    [labels setObject:[NSString stringWithFormat:@"Player.%@.%@", category, title] forKey:@"name"];
    
    return [labels copy];
}

- (instancetype)initWithMedia:(SRGILMedia *)media usingURL:(NSURL *)playedURL
{
    NSAssert(media, @"Missing media");
    NSAssert(playedURL, @"Missing played URL");

    self = [super init];
    if (self) {
        self.media = media;
        self.playedURL = playedURL;
    }
    return self;
}

- (NSDictionary *)statusLabels
{
    NSMutableDictionary *labels = [NSMutableDictionary dictionary];

    NSString *srg_n1 = @"UndefinedMediaType";
    switch ([self.media type]) {
        case SRGILMediaTypeVideo:
            srg_n1 = @"TV";
            break;
        case SRGILMediaTypeAudio:
            srg_n1 = @"Radio";
            break;
        default:
            break;
    }
    
    [labels setObject:srg_n1.lowercaseString forKey:@"srg_n1"];

    NSString *srg_n2 = nil;
    NSString *title = nil;

    if ([self.media isLiveStream]) {
        srg_n2 = @"Live";
        title = [self.media.parentTitle comScoreFormattedString];
    }
    else {
        srg_n2 = [self.media.parentTitle comScoreFormattedString];
        title = [self.media.title comScoreFormattedString];
    }

    if (srg_n2) {
        [labels setObject:srg_n2.lowercaseString forKey:@"srg_n2"];
    }
    if (title) {
        [labels setObject:title forKey:@"srg_title"];
    }

    NSString *category = srg_n2 ? [NSString stringWithFormat:@"%@.%@", srg_n1, srg_n2] : srg_n1;
    NSString *name = [NSString stringWithFormat:@"Player.%@.%@", category, title];
    
    [labels setObject:category forKey:@"category"];
    [labels setObject:name forKey:@"name"];
    
    return [labels copy];
}

@end
