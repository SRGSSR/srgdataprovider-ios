//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

#import "SRGChapter.h"
#import "SRGEpisode.h"
#import "SRGLike.h"
#import "SRGMedia.h"
#import "SRGMediaComposition.h"
#import "SRGPage.h"
#import "SRGRequest.h"
#import "SRGShow.h"
#import "SRGTopic.h"

NS_ASSUME_NONNULL_BEGIN

OBJC_EXPORT NSString * const SRGBusinessIdentifierRSI;
OBJC_EXPORT NSString * const SRGBusinessIdentifierRTR;
OBJC_EXPORT NSString * const SRGBusinessIdentifierRTS;
OBJC_EXPORT NSString * const SRGBusinessIdentifierSRF;
OBJC_EXPORT NSString * const SRGBusinessIdentifierSWI;

typedef void (^SRGMediaListCompletionBlock)(NSArray<SRGMedia *> * _Nullable medias, SRGPage * _Nullable nextPage, NSError * _Nullable error);
typedef void (^SRGShowListCompletionBlock)(NSArray<SRGShow *> * _Nullable shows, NSError * _Nullable error);
typedef void (^SRGTopicListCompletionBlock)(NSArray<SRGTopic *> * _Nullable topics, NSError * _Nullable error);
typedef void (^SRGURLCompletionBlock)(NSURL * _Nullable URL, NSError * _Nullable error);

typedef void (^SRGLikeCompletionBlock)(SRGLike * _Nullable like, NSError * _Nullable error);
typedef void (^SRGMediaCompositionCompletionBlock)(SRGMediaComposition * _Nullable mediaComposition, NSError * _Nullable error);

@interface SRGDataProvider : NSObject

+ (nullable SRGDataProvider *)currentDataProvider;
+ (nullable SRGDataProvider *)setCurrentDataProvider:(nullable SRGDataProvider *)currentDataProvider;

- (instancetype)initWithServiceURL:(NSURL *)serviceURL businessUnitIdentifier:(NSString *)businessUnitIdentifier NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSURL *serviceURL;
@property (nonatomic, readonly, copy) NSString *businessUnitIdentifier;

- (SRGRequest *)trendingVideosWithPage:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;
- (SRGRequest *)trendingVideosWithEditorialLimit:(nullable NSNumber *)editorialLimit page:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)latestVideosWithPage:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;
- (SRGRequest *)mostPopularVideosWithPage:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)videoTopicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock;
- (SRGRequest *)latestVideosForTopicWithUid:(NSString *)topicUid page:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)videoShowsWithCompletionBlock:(SRGShowListCompletionBlock)completionBlock;

- (SRGRequest *)mediaCompositionForVideoWithUid:(NSString *)mediaUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock;

- (SRGRequest *)likeMediaComposition:(SRGMediaComposition *)mediaComposition withCompletionBlock:(SRGLikeCompletionBlock)completionBlock;

- (SRGRequest *)tokenizeURL:(NSURL *)URL withCompletionBlock:(SRGURLCompletionBlock)completionBlock;

@end

@interface SRGDataProvider (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
