//
//  SRGILImageRepresentation.h
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "SRGILModelObject.h"
#import "SRGILModelConstants.h"

/**
 * A concrete image incarnation
 *
 * See https://github.com/mmz-srf/srf-integrationtest/blob/master/intlayer-integrationtests/src/test/resources/schema/image.xsd
 */
@interface SRGILImageRepresentation : SRGILModelObject

@property (nonatomic, strong, readonly) NSURL *URL;
@property (nonatomic, assign, readonly) CGSize size;
@property (nonatomic, assign, readonly) SRGILMediaImageUsage usage;

@end
