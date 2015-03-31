//
//  SRGRubric.h
//  SRFPlayer
//
//  Created by Samuel Défago on 12/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SRGILModelObject.h"
#import "SRGILImage.h"
#import "SRGILPrimaryChannel.h"

/**
 * Class describing a rubric
 *
 * See https://github.com/mmz-srf/srf-integrationtest/blob/master/intlayer-integrationtests/src/test/resources/schema/rubric.xsd
 */
@interface SRGILRubric : SRGILModelObject

/**
 * The rubric name
 */
@property (nonatomic, readonly, strong) NSString *title;

/**
 * The image associated with the rubric
 */
@property (nonatomic, readonly, strong) SRGILImage *image;

/**
 * The primary channel
 */
@property (nonatomic, readonly, strong) SRGILPrimaryChannel *primaryChannel;

@end
