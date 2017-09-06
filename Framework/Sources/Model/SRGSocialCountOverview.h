//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaIdentifierMetadata.h"
#import "SRGSocialCount.h"
#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Information returned as the result of a request increasing social media counters.
 */
@interface SRGSocialCountOverview : SRGModel <SRGMediaIdentifierMetadata>

/**
 *  The updated social media and popularity information.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSocialCount *> *socialCounts;

@end

NS_ASSUME_NONNULL_END
