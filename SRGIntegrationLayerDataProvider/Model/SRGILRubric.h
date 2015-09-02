//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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
