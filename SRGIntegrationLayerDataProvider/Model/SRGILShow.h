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
 * Class describing a broadcast
 *
 * See https://github.com/mmz-srf/srf-integrationtest/blob/master/intlayer-integrationtests/src/test/resources/schema/show.xsd
 */
@interface SRGILShow : SRGILModelObject

/**
 * The broadcast name
 */
@property (nonatomic, strong) NSString *title;

/**
 * The image associated with the asset
 */
@property (nonatomic, strong) SRGILImage *image;

@property (nonatomic, strong) SRGILPrimaryChannel *primaryChannel;

/**
 * Description of the show (not 'description'...)
 */
@property (nonatomic, strong) NSString *showDescription;


/**
 * Primary channel ID.
 * Returned when fetching a single *audio* show
 */
@property (nonatomic) NSString *primaryChannelId;

@end
