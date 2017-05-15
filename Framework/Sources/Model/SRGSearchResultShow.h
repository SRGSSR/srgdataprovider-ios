//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSearchResult.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Show information returned by a search request.
 *
 *  @discussion This object does not contain all show information. If you need complete show information or a 
 *              full-fledged `SRGShow` object, you must perform an additional request using the result uid.
 */
@interface SRGSearchResultShow : SRGSearchResult

/**
 *  Describes whether the show is part of TV, radio or online channel.
 */
@property (nonatomic, readonly) SRGTransmission transmission;

@end

NS_ASSUME_NONNULL_END
