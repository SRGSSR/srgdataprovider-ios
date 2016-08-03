//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGRequest : NSObject

- (void)resume;
- (void)cancel;

@property (nonatomic, readonly, getter=isRunning) BOOL running;

// Defaults to YES. Changing this value when a connection is running is a no-op
@property (nonatomic, getter=isManagingNetworkActivityIndicator) BOOL managingNetworkActivityIndicator;

@end

NS_ASSUME_NONNULL_END
