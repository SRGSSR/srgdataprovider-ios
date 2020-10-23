//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Abstract base class for a bucket (group of items sharing a common property).
 */
@interface SRGBucket : SRGModel

/**
 *  The number of items in the bucket.
 */
@property (nonatomic, readonly) NSUInteger count;

@end

/**
 *  Bucket for a date.
 */
@interface SRGDateBucket : SRGBucket

/**
 *  The data associated with the bucket.
 */
@property (nonatomic, readonly) NSDate *date;

@end

/**
 *  Bucket for download availability.
 */
@interface SRGDownloadAvailableBucket : SRGBucket

/**
 *  The boolean value for the download availability.
 */
@property (nonatomic, readonly) BOOL downloadAvailable;

@end

/**
 *  Bucket for a duration.
 */
@interface SRGDurationBucket : SRGBucket

/**
 *  The duration associated with the bucket.
 */
@property (nonatomic, readonly) NSTimeInterval duration;

@end

/**
 *  Bucket for a media type.
 */
@interface SRGMediaTypeBucket : SRGBucket

/**
 *  The media type associated with the bucket.
 */
@property (nonatomic, readonly) SRGMediaType mediaType;

@end

/**
 *  Bucket for playability abroad.
 */
@interface SRGPlayableAbroadBucket : SRGBucket

/**
 *  The boolean value for the playability abroad.
 */
@property (nonatomic, readonly) BOOL playableAbroad;

@end

/**
 *  Bucket for a stream quality.
 */
@interface SRGQualityBucket : SRGBucket

/**
 *  The quality associated with the bucket.
 */
@property (nonatomic, readonly) SRGQuality quality;

@end

/**
 *  Bucket for a show.
 */
@interface SRGShowBucket : SRGBucket

/**
 *  The show URN associated with the bucket.
 */
@property (nonatomic, readonly, copy) NSString *URN;

/**
 *  The show title.
 */
@property (nonatomic, readonly, copy) NSString *title;

@end

/**
 *  Bucket for subtitles availability.
 */
@interface SRGSubtitlesAvailableBucket : SRGBucket

/**
 *  The boolean value for the subtitles availability.
 */
@property (nonatomic, readonly) BOOL subtitlesAvailable;

@end

/**
 *  Bucket for a topic.
 */
@interface SRGTopicBucket : SRGBucket

/**
 *  The topic URN associated with the bucket.
 */
@property (nonatomic, readonly, copy) NSString *URN;

/**
 *  The topic title.
 */
@property (nonatomic, readonly, copy) NSString *title;

@end

/**
 *  Aggregation information for media request results, sorting medias into buckets for specific properties, with a
 *  corresponding media count per bucket. Can be used to have a histogram view of the results.
 */
@interface SRGMediaAggregations : SRGModel

/**
 *  Buckets.
 */
@property (nonatomic, readonly) NSArray<SRGMediaTypeBucket *> *mediaTypeBuckets;

@property (nonatomic, readonly) NSArray<SRGSubtitlesAvailableBucket *> *subtitlesAvailableBuckets;
@property (nonatomic, readonly) NSArray<SRGDownloadAvailableBucket *> *downloadAvailableBuckets;
@property (nonatomic, readonly) NSArray<SRGPlayableAbroadBucket *> *playableAbroadBuckets;

@property (nonatomic, readonly) NSArray<SRGQualityBucket *> *qualityBuckets;

@property (nonatomic, readonly) NSArray<SRGShowBucket *> *showBuckets;
@property (nonatomic, readonly) NSArray<SRGTopicBucket *> *topicBuckets;

@property (nonatomic, readonly) NSArray<SRGDurationBucket *> *durationInMinutesBuckets;
@property (nonatomic, readonly) NSArray<SRGDateBucket *> *dateBuckets;

@end

NS_ASSUME_NONNULL_END
