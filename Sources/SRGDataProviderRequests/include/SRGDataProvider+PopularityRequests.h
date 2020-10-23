//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@import SRGDataProvider;
@import SRGDataProviderModel;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Common `NSURLRequest` builders. Refer to the service documentation for more information about the purpose and
 *  parameters of each request.
 */
@interface SRGDataProvider (PopularityRequests)

- (NSURLRequest *)requestIncreaseSocialCountForType:(SRGSocialCountType)type
                                                URN:(NSString *)URN
                                              event:(NSString *)event;
- (NSURLRequest *)requestIncreaseSearchResultsViewCountForShow:(SRGShow *)show;

@end

NS_ASSUME_NONNULL_END
