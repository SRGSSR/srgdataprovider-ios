//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

#import "SRGILModelObject.h"
#import "SRGILModelConstants.h"
#import "SRGILRubric.h"
#import "SRGILShow.h"
#import "SRGILVideo.h"

/**
 * See https://github.com/mmz-srf/srf-integrationtest/blob/master/intlayer-integrationtests/src/test/resources/schema/assetSet.xsd
 */
@interface SRGILAssetSet : SRGILModelObject

/**
 * Whether the video is a full length sequence
 */
@property (nonatomic, strong) NSDate *publishedDate;

/**
 * Broadcast information
 */
@property (nonatomic, strong, readonly) SRGILShow *show;

/**
 * Rubric information
 */
@property (nonatomic, strong, readonly) SRGILRubric *rubric;

/**
 * AssetSet sub-type.
 */
@property (nonatomic, assign, readonly) SRGILAssetSubSetType subtype;

@property (nonatomic, strong) NSArray *assets;

/**
 * Asset group ID
 * Needed for analytics
 */
@property (nonatomic, readonly) NSString *assetGroupId;

/**
 * Asset Set Title
 * Needed for analytics
 */
@property (nonatomic, readonly) NSString *title;

@end
