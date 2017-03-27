//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSearchResult.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Media information returned by a search request.
 *
 *  @discussion This object does not contain all media information. If you need complete media information or a
 *              full-fledged `SRGMedia` object, you must perform an additional request using the result uid.
 */
@interface SRGSearchResultMedia : SRGSearchResult

/**
 *  The media type.
 */
@property (nonatomic, readonly) SRGMediaType mediaType;

/**
 *  The media date.
 */
@property (nonatomic, readonly) NSDate *date;

/**
 *  The media duration.
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 *  The uid of the episode which the media belongs to.
 */
@property (nonatomic, readonly, copy, nullable) NSString *episodeUid;

/**
 *  The title of the episode which the media belongs to.
 */
@property (nonatomic, readonly, copy, nullable) NSString *episodeTitle;

/**
 *  The uid of the show which the media belongs to.
 */
@property (nonatomic, readonly, copy, nullable) NSString *showUid;

/**
 *  The title of the show which the media belongs to.
 */
@property (nonatomic, readonly, copy, nullable) NSString *showTitle;

/**
 *  The uid of the channel which the media comes from.
 */
@property (nonatomic, readonly, copy, nullable) NSString *channelUid;

@end

NS_ASSUME_NONNULL_END
