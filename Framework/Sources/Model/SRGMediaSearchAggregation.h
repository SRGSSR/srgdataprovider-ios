//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRGBucket : SRGModel

@property (nonatomic, readonly) NSUInteger count;

@end

@interface SRGDateBucket : SRGBucket

@property (nonatomic, readonly) NSDate *date;

@end

@interface SRGDownloadAvailableBucket : SRGBucket

@property (nonatomic, readonly) BOOL downloadAvailable;

@end

@interface SRGDurationBucket : SRGBucket

@property (nonatomic, readonly) NSTimeInterval duration;

@end

@interface SRGMediaTypeBucket : SRGBucket

@property (nonatomic, readonly) SRGMediaType mediaType;

@end

@interface SRGPlayableAbroadBucket : SRGBucket

@property (nonatomic, readonly) BOOL playableAbroad;

@end

@interface SRGQualityBucket : SRGBucket

@property (nonatomic, readonly) SRGQuality quality;

@end

@interface SRGShowBucket : SRGBucket

@property (nonatomic, readonly, copy) NSString *URN;
@property (nonatomic, readonly, copy) NSString *title;

@end

@interface SRGSubtitlesAvailableBucket : SRGBucket

@property (nonatomic, readonly) BOOL subtitlesAvailable;

@end

@interface SRGTopicBucket : SRGBucket

@property (nonatomic, readonly, copy) NSString *URN;
@property (nonatomic, readonly, copy) NSString *title;

@end

@interface SRGMediaSearchAggregation : SRGModel

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
