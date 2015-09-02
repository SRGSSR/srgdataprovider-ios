//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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
