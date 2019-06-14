//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Search suggestion.
 */
@interface SRGSearchSuggestion : SRGModel

/**
 *  The suggested query text.
 */
@property (nonatomic, readonly, copy) NSString *text;

/**
 *  The number of corresponding exact matches.
 */
@property (nonatomic, readonly) NSInteger numberOfExactMatches;

@end

NS_ASSUME_NONNULL_END
