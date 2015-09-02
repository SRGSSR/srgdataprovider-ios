//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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
