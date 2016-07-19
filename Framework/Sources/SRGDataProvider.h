//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

#import "SRGChapter.h"
#import "SRGEpisode.h"
#import "SRGMedia.h"
#import "SRGMediaComposition.h"
#import "SRGShow.h"
#import "SRGTopic.h"

NS_ASSUME_NONNULL_BEGIN

OBJC_EXPORT NSString * const SRGBusinessIdentifierRSI;
OBJC_EXPORT NSString * const SRGBusinessIdentifierRTR;
OBJC_EXPORT NSString * const SRGBusinessIdentifierRTS;
OBJC_EXPORT NSString * const SRGBusinessIdentifierSRF;
OBJC_EXPORT NSString * const SRGBusinessIdentifierSWI;


typedef void (^SRGMediaListCompletionBlock)(NSArray<SRGMedia *> * _Nullable medias, NSError * _Nullable error);
typedef void (^SRGShowListCompletionBlock)(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error);
typedef void (^SRGTopicListCompletionBlock)(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error);
typedef void (^SRGMediaCompositionCompletionBlock)(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error);

@interface SRGDataProvider : NSObject

+ (nullable SRGDataProvider *)currentDataProvider;
+ (nullable SRGDataProvider *)setCurrentDataProvider:(nullable SRGDataProvider *)currentDataProvider;

- (instancetype)initWithServiceURL:(NSURL *)serviceURL businessUnitIdentifier:(NSString *)businessUnitIdentifier NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSURL *serviceURL;
@property (nonatomic, readonly, copy) NSString *businessUnitIdentifier;

- (NSURLSessionTask *)trendingVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;
- (NSURLSessionTask *)trendingVideosWithEditorialLimit:(nullable NSNumber *)editorialLimit completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (NSURLSessionTask *)latestVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;
- (NSURLSessionTask *)mostPopularVideosWithCompletionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (NSURLSessionTask *)videoTopicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock;
- (NSURLSessionTask *)latestVideosForTopicWithUid:(NSString *)topicUid completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (NSURLSessionTask *)videoShowsWithCompletionBlock:(SRGShowListCompletionBlock)completionBlock;

- (NSURLSessionTask *)compositionForVideoWithUid:(NSString *)mediaUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock;

@end

@interface SRGDataProvider (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
