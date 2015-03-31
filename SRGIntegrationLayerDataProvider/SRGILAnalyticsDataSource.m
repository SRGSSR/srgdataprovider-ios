//
//  SRGIntegrationLayerDataProvider.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 27/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <RTSAnalytics/NSString+RTSAnalyticsUtils.h>

#import "SRGILAnalyticsDataSource.h"

#import "SRGILComScoreAnalyticsIndividualDataSource.h"
#import "SRGILStreamSenseAnalyticsIndividualDataSource.h"
#import "SRGAnalyticsIndividualDataSource.h"

static NSString * const comScoreKeypathPrefix = @"SRGILComScoreAnalyticsIndividualDataSource.";
static NSString * const streamSenseKeypathPrefix = @"SRGILStreamSenseAnalyticsIndividualDataSource.";

@interface SRGILAnalyticsDataSource () {
    NSMutableDictionary *_individualDataSources;
}
@end

@implementation SRGILAnalyticsDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _individualDataSources = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id<SRGAnalyticsIndividualDataSource>)individualDataSourceForKeyPath:(NSString *)keyPath
{
    id ds = [_individualDataSources valueForKeyPath:keyPath];
    if (!ds) {
        NSString *classname = [[keyPath componentsSeparatedByString:@"."] firstObject];
        NSString *identifier = [[keyPath componentsSeparatedByString:@"."] lastObject];
        ds = [[NSClassFromString(classname) alloc] initWithIdentifier:identifier];
        [_individualDataSources setValue:ds forKeyPath:keyPath];
    }
    return ds;
}

- (SRGILComScoreAnalyticsIndividualDataSource *)comScoreIndividualDataSourceForIdenfifier:(NSString *)identifier
{
    return [self individualDataSourceForKeyPath:[comScoreKeypathPrefix stringByAppendingString:identifier]];
}

- (SRGILStreamSenseAnalyticsIndividualDataSource *)streamSenseIndividualDataSourceForIdenfifier:(NSString *)identifier
{
    return [self individualDataSourceForKeyPath:[streamSenseKeypathPrefix stringByAppendingString:identifier]];
}


#pragma mark - RTSAnalyticsDataSource

- (RTSAnalyticsMediaMode)mediaModeForIdentifier:(NSString *)identifier
{
    SRGILComScoreAnalyticsIndividualDataSource *ds = [self comScoreIndividualDataSourceForIdenfifier:identifier];
    return ds.mediaMode;
}

- (NSDictionary *)comScoreLabelsForAppEnteringForeground
{
    NSMutableDictionary *labels = [NSMutableDictionary dictionary];
    
    NSString *category = @"APP";
    NSString *srg_n1   = @"event";
    NSString *title    = @"comingToForeground";
    
    [labels setObject:category forKey:@"category"];
    [labels setObject:srg_n1 forKey:@"srg_n1"];
    [labels setObject:title forKey:@"srg_title"];
    [labels setObject:[NSString stringWithFormat:@"Player.%@.%@", category, title] forKey:@"name"];
    
    return [labels copy];
}

- (NSDictionary *)comScoreReadyToPlayLabelsForIdentifier:(NSString *)identifier
{
    SRGILComScoreAnalyticsIndividualDataSource *ds = [self comScoreIndividualDataSourceForIdenfifier:identifier];
    return [ds statusLabels];
}

- (NSDictionary *)streamSensePlaylistMetadataForIdentifier:(NSString *)identifier
{
    SRGILStreamSenseAnalyticsIndividualDataSource *ds = [self streamSenseIndividualDataSourceForIdenfifier:identifier];
    return [ds playlistMetadata];
}

- (NSDictionary *)streamSenseFullLengthClipMetadataForIdentifier:(NSString *)identifier
{
    SRGILStreamSenseAnalyticsIndividualDataSource *ds = [self streamSenseIndividualDataSourceForIdenfifier:identifier];
    return [ds fullLengthClipMetadata];
}

@end
