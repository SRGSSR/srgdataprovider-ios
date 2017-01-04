//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common base class for results of a search request
 */
@interface SRGSearchResult : MTLModel <MTLJSONSerializing, SRGImageMetadata, SRGMetadata>

/**
 *  The unique identifier of the object
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The Uniform Resource Name identifying the object
 */
@property (nonatomic, readonly, copy) NSString *URN;

@end

NS_ASSUME_NONNULL_END
