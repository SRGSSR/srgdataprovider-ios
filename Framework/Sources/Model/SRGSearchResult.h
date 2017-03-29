//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMediaURN.h"
#import "SRGMetadata.h"
#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common base class for results of a search request.
 */
@interface SRGSearchResult : SRGModel <SRGImageMetadata, SRGMetadata>

/**
 *  The unique identifier of the object.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The Uniform Resource Name identifying the object.
 */
@property (nonatomic, readonly) SRGMediaURN *URN;

@end

NS_ASSUME_NONNULL_END
