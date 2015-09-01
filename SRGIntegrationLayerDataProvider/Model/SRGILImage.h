//
//  SRGILImage.h.h
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"
#import "SRGILImageRepresentation.h"

/**
 * Class describing an image. Each image can have several representations (with different sizes). Examine them to get
 * the image URLs you need
 */
@interface SRGILImage : SRGILModelObject

- (SRGILImageRepresentation *)imageRepresentationForUsage:(SRGILMediaImageUsage)usage;

@end
