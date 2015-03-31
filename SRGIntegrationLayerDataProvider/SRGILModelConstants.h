//
//  SRGILModelConstants.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SRGIntegrationLayerDataProvider_SRGILModelConstants_h
#define SRGIntegrationLayerDataProvider_SRGILModelConstants_h

typedef NS_ENUM (NSInteger, SRGILMediaType) {
    SRGILMediaTypeUndefined,
    SRGILMediaTypeVideo,
    SRGILMediaTypeAudio,
};

typedef NS_ENUM(NSInteger, SRGILMediaImageUsage) {
    SRGILMediaImageUsageUnknown,
    SRGILMediaImageUsageHeader,
    SRGILMediaImageUsagePodcast,
    SRGILMediaImageUsageWeb,
    SRGILMediaImageUsageEditorialPick,
    SRGILMediaImageUsageShowEpisode
};

SRGILMediaImageUsage SRGILMediaImageUsageFromString(NSString *input);

typedef NS_ENUM(NSInteger, SRGILMediaBlockingReason) {
    SRGILMediaBlockingReasonNone,
    SRGILMediaBlockingReasonGeoblock,
    SRGILMediaBlockingReasonLegal,
    SRGILMediaBlockingReasonCommercial,
    SRGILMediaBlockingReasonAgeRating18,
    SRGILMediaBlockingReasonAgeRating12,
    SRGILMediaBlockingReasonStartDate,
    SRGILMediaBlockingReasonEndDate
};

SRGILMediaBlockingReason SRGILMediaBlockingReasonForKey(NSString *key);
NSString *SRGILMediaBlockingReasonMessageForReason(SRGILMediaBlockingReason reason);

#endif
