//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Additional settings for media search queries.
 */
@interface SRGMediaSearchSettings : MTLModel

/**
 *  Whether aggregations should be returned in search results.
 *
 *  @discussion The default value is `YES`. Enabling aggregations results in longer response times.
 */
@property (nonatomic) BOOL aggregationsEnabled;

/**
 *  Whether suggestions should be returned in search results.
 *
 *  @discussion The default value is `NO`.
 */
@property (nonatomic) BOOL suggestionsEnabled;

/**
 *  Options setting how the search query is matched.
 */
@property (nonatomic) SRGSearchMatchingOptions matchingOptions;

/**
 *  Restrict results to a list of show URNs.
 */
@property (nonatomic, null_resettable) NSSet<NSString *> *showURNs;

/**
 *  Restrict results to a list of topic URNs.
 */
@property (nonatomic, null_resettable) NSSet<NSString *> *topicURNs;

/**
 *  Restrict results to a given media type. Default is `SRGMediaTypeNone`, i.e. no such filter is applied.
 */
@property (nonatomic) SRGMediaType mediaType;

/**
 *  If `@YES`, restrict results to medias with subtitles, if `@NO` to medias without. The default is `nil`, i.e.
 *  no such filter is applied.
 */
@property (nonatomic, nullable) NSNumber *subtitlesAvailable;

/**
 *  If `@YES`, restrict results to medias which can be downloaded, if `@NO` to medias which cannot be. The default is
 *  `nil`, i.e. no such filter is applied.
 */
@property (nonatomic, nullable) NSNumber *downloadAvailable;

/**
 *  If `@YES`, restrict results to medias playable abroad, if `@NO` to medias playable within Switzerland only. The
 *  default is `nil`, i.e. no such filter is applied.
 */
@property (nonatomic, nullable) NSNumber *playableAbroad;

/**
 *  Restrict results to a given quality. Default is `SRGQualityNone`, i.e. no such filter is applied.
 *
 *  @discussion `SRGQualityHD` and `SRGQualityHQ` equivalently filter out high-quality content.
 */
@property (nonatomic) SRGQuality quality;

/**
 *  The minimum / maximum media duration, in minutes.
 */
@property (nonatomic, nullable) NSNumber *minimumDurationInMinutes;
@property (nonatomic, nullable) NSNumber *maximumDurationInMinutes;

/**
 *  The dates after / before which medias must be considered.
 */
@property (nonatomic, nullable) NSDate *afterDate;
@property (nonatomic, nullable) NSDate *beforeDate;

/**
 *  The sort criterium to be applied. Default is `SRGSortCriteriumDefault`, i.e. the order is the default one
 *  returned by the service.
 */
@property (nonatomic) SRGSortCriterium sortCriterium;

/**
 *  The sort direction to be applied. Default is `SRGSortDirectionDescending`.
 */
@property (nonatomic) SRGSortDirection sortDirection;

@end

NS_ASSUME_NONNULL_END
