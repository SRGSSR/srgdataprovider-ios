//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPage.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Request objects provide a way to manage the data retrieval process
 */
@interface SRGRequest : NSObject

- (SRGRequest *)withPageSize:(NSInteger)pageSize;
- (SRGRequest *)atPage:(nullable SRGPage *)page;

@property (nonatomic, readonly) SRGPage *page;

- (void)resume;
- (void)cancel;

@property (nonatomic, readonly, getter=isRunning) BOOL running;

// Defaults to YES. Changing this value when a connection is running is a no-op
@property (nonatomic, getter=isManagingNetworkActivityIndicator) BOOL managingNetworkActivityIndicator;

@end

NS_ASSUME_NONNULL_END
