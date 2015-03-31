//
//  SRGImage.h
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SRGILModelObject.h"
#import "SRGILModelConstants.h"
#import "SRGILImageRepresentation.h"

/**
 * Class describing an image. Each image can have several representations (with different sizes). Examine them to get
 * the image URLs you need
 *
 * See https://github.com/mmz-srf/srf-integrationtest/blob/master/intlayer-integrationtests/src/test/resources/schema/image.xsd
 */
@interface SRGILImage : SRGILModelObject

- (SRGILImageRepresentation *)imageRepresentationForUsage:(SRGILMediaImageUsage)usage;
- (SRGILImageRepresentation *)imageRepresentationForVideoCell;

@end
