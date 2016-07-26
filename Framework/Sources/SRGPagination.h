//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGPagination : NSObject

+ (SRGPagination *)paginationForPage:(NSInteger)page ofSize:(NSInteger)size;

@property (nonatomic, readonly) NSInteger page;
@property (nonatomic, readonly) NSInteger size;

- (nullable SRGPagination *)previousPage;
- (SRGPagination *)nextPage;

@end

@interface SRGPagination (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
