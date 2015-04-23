//
//  SRGAnalyticsData.h
//  SRGILMediaPlayer
//
//  Created by Frédéric VERGEZ on 20/03/15.
//  Copyright (c) 2015 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"

@interface SRGILAnalyticsExtendedData : SRGILModelObject

@property(nonatomic, readonly) NSString *srgC1;
@property(nonatomic, readonly) NSString *srgC2;
@property(nonatomic, readonly) NSString *srgC3;

@end