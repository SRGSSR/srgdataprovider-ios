//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

// Public framework imports
#import "SRGChannel.h"
#import "SRGChapter.h"
#import "SRGDataProvider.h"
#import "SRGDataProviderError.h"
#import "SRGEntry.h"
#import "SRGEpisode.h"
#import "SRGEvent.h"
#import "SRGImageMetadata.h"
#import "SRGLike.h"
#import "SRGMedia.h"
#import "SRGMediaComposition.h"
#import "SRGMediaIdentifierMetadata.h"
#import "SRGMediaMetadata.h"
#import "SRGMetadata.h"
#import "SRGPage.h"
#import "SRGPresenter.h"
#import "SRGProgram.h"
#import "SRGRelatedContent.h"
#import "SRGRequest.h"
#import "SRGRequestQueue.h"
#import "SRGResource.h"
#import "SRGSection.h"
#import "SRGSegment.h"
#import "SRGShow.h"
#import "SRGSocialCount.h"
#import "SRGSubtitle.h"
#import "SRGTopic.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

// Project version information
OBJC_EXPORT double SRGDataProviderVersionNumber;
OBJC_EXPORT const unsigned char SRGDataProviderVersionString[];

// Official business identifiers
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

@interface SRGDataProvider : NSObject <NSURLSessionTaskDelegate>

+ (nullable SRGDataProvider *)currentDataProvider;
+ (nullable SRGDataProvider *)setCurrentDataProvider:(nullable SRGDataProvider *)currentDataProvider;

- (instancetype)initWithServiceURL:(NSURL *)serviceURL businessUnitIdentifier:(NSString *)businessUnitIdentifier NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSURL *serviceURL;
@property (nonatomic, readonly, copy) NSString *businessUnitIdentifier;

// TODO: Maybe have an audio / video enum parameter for each method available for audio & videos
// TODO: Document: completion block never called for cancelled requests

- (SRGRequest *)editorialVideosWithPage:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)trendingVideosWithPage:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;
- (SRGRequest *)trendingVideosWithEditorialLimit:(nullable NSNumber *)editorialLimit page:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)latestVideosWithPage:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;
- (SRGRequest *)mostPopularVideosWithPage:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)videoTopicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock;
- (SRGRequest *)latestVideosForTopicWithUid:(NSString *)topicUid page:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)videoShowsWithCompletionBlock:(SRGShowListCompletionBlock)completionBlock;

- (SRGRequest *)mediaCompositionForVideoWithUid:(NSString *)mediaUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock;

- (SRGRequest *)searchVideosMatchingQuery:(NSString *)query withPage:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock;

- (SRGRequest *)likeMediaComposition:(SRGMediaComposition *)mediaComposition withCompletionBlock:(SRGLikeCompletionBlock)completionBlock;

- (SRGRequest *)tokenizeURL:(NSURL *)URL withCompletionBlock:(SRGURLCompletionBlock)completionBlock;

@end

@interface SRGDataProvider (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
