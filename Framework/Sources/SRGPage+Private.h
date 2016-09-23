//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRGPage (Private)

+ (NSURLRequest *)request:(NSURLRequest *)request withPage:(nullable SRGPage *)page;

+ (SRGPage *)firstPageWithDefaultSize;
+ (SRGPage *)firstPageWithSize:(NSInteger)size;

- (SRGPage *)nextPageWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
