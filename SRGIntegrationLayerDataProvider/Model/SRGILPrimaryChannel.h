//
//  SRGPrimaryChannel.h
//  SRFPlayer
//
//  Created by Cédric Foellmi on 12/03/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"
#import "SRGILImage.h"

/**
 * Class describing a primary channel (for live streams)
 */
@interface SRGILPrimaryChannel : SRGILModelObject

@property (nonatomic, strong) NSString *title;

/**
 * The rubric name
 */
@property (nonatomic, strong) NSString *distributor;

/**
 * The image associated with the rubric
 */
@property (nonatomic, strong) SRGILImage *image;

@end
