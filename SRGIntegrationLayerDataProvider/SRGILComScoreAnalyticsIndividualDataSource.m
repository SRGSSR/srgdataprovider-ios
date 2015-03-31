//
//  SRGComscoreAnalyticsDataSource.m
//  SRFPlayer
//
//  Created by Cédric Foellmi on 15/07/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILComScoreAnalyticsIndividualDataSource.h"
#import <RTSAnalytics/NSString+RTSAnalyticsUtils.h>

@interface SRGILComScoreAnalyticsIndividualDataSource ()
@property(nonatomic, strong) NSString *identifier;
@end

@implementation SRGILComScoreAnalyticsIndividualDataSource

//+ (NSDictionary *)labelsForViewController:(UIViewController *)controller
//{
//    NSMutableDictionary *labels = [NSMutableDictionary dictionary];
//    
//    NSString *metatitle = nil;
//    NSString *srg_n1 = @"TV";
//
//    if ([controller isKindOfClass:[SRGCollectionViewController class]]) {
//        SRGCollectionViewControllerConfig *config = [(SRGCollectionViewController *)controller config];
//        if (config.audioChannelID) {
//            srg_n1 = @"Radio";
//        }
//        
//        if ([config.requestURLPaths count] == 1 &&
//            [[[config.requestURLPaths allKeys] lastObject] isKindOfClass:[NSNumber class]] &&
//            [[[config.requestURLPaths allKeys] lastObject] integerValue] == SRGMediaCategoryLiveStreamsVideo)
//        {
//            metatitle = @"Live";
//        }
//    }
//    
//    NSString *category = srg_n1;
//    NSString *title = [self stringWithComscoreFormat:(metatitle ? metatitle : (controller.title ? controller.title : @"Untitled"))];
//    
//    [labels setObject:srg_n1 forKey:@"srg_n1"];
//    [labels setObject:category forKey:@"category"];
//    [labels setObject:title forKey:@"srg_title"];
//    [labels setObject:[NSString stringWithFormat:@"Player.%@.%@", category, title] forKey:@"name"];
//    
//    return [labels copy];
//}


- (instancetype)initWithIdentifier:(NSString *)identifier
{
    NSAssert(identifier, @"Missing identifier");
    self = [super init];
    if (self) {
        self.identifier = identifier;
    }
    return self;
}

- (RTSAnalyticsMediaMode)mediaMode
{
    return RTSAnalyticsMediaModeLiveStream;
}

- (NSDictionary *)statusLabels
{
    NSMutableDictionary *labels = [NSMutableDictionary dictionary];

//    NSString *srg_n1 = @"(UndefinedMediaType)";
//    switch ([self mediaMode]) {
//        case SRGMediaTypeVideo:
//            srg_n1 = @"VideoPlayer";
//            break;
//        case SRGMediaTypeAudio:
//            srg_n1 = @"AudioPlayer";
//            break;
//        default:
//            break;
//    }
    
    NSString *srg_n1 = @"VideoPlayer";
    NSString *srg_n2 = nil;
    NSString *title = nil;

    if ([self mediaMode] == RTSAnalyticsMediaModeLiveStream) {
        srg_n2 = @"Live";
        title = [@"<PUT HERE MEDIA PARENT TITLE>" comScoreFormattedString];
    }
    else {
        srg_n2 = [@"<PUT HERE MEDIA PARENT TITLE>" comScoreFormattedString];
        title = [@"<PUT HERE MEDIA TITLE>" comScoreFormattedString];
    }

    NSString *category = srg_n2 ? [NSString stringWithFormat:@"%@.%@", srg_n1, srg_n2] : srg_n1;

    [labels setObject:category forKey:@"category"];
    [labels setObject:srg_n1 forKey:@"srg_n1"];
    if (srg_n2) {
        [labels setObject:srg_n2 forKey:@"srg_n2"];
    }
    if (title) {
        [labels setObject:title forKey:@"srg_title"];
    }
    [labels setObject:[NSString stringWithFormat:@"Player.%@.%@", category, title] forKey:@"name"];
    
    return [labels copy];
}

@end
