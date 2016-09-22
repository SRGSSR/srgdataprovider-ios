//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGPage : NSObject <NSCopying>

+ (SRGPage *)firstPageWithDefaultSize;
+ (SRGPage *)firstPageWithSize:(NSUInteger)size;

@property (nonatomic, readonly) NSInteger size;
@property (nonatomic, readonly) NSInteger number;
@property (nonatomic, readonly, copy, nullable) NSString *uid;

@end

@interface SRGPage (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
