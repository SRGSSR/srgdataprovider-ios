//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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
