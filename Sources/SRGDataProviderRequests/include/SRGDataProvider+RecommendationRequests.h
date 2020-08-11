//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common `NSURLRequest` builders. Refer to the service documentation for more information about the purpose and
 *  parameters of each request.
 */
@interface SRGDataProvider (RecommendationRequests)

- (NSURLRequest *)requestRecommendedMediasForURN:(NSString *)URN
                                          userId:(nullable NSString *)userId;

@end

NS_ASSUME_NONNULL_END
