//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGPage : NSObject <NSCopying>

+ (SRGPage *)pageWithNumber:(NSInteger)number size:(NSInteger)size;

@property (nonatomic, readonly) NSInteger number;
@property (nonatomic, readonly) NSInteger size;

- (nullable SRGPage *)previousPage;
- (SRGPage *)nextPage;

@end

@interface SRGPage (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
