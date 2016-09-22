//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRGPage (Private)

- (nullable SRGPage *)previousPageWithUid:(NSString *)uid;
- (SRGPage *)nextPageWithUid:(NSString *)uid;

@property (nonatomic, readonly, nullable) NSURLQueryItem *queryItem;

@end

NS_ASSUME_NONNULL_END
