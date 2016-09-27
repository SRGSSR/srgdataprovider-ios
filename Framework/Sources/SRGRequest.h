//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPage.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  `SRGRequest` objects provide a way to manage the data retrieval process associated with a data provider 
 *  service request. You never instantiate `SRGRequest` objects directly, you merely use the ones returned 
 *  when calling `SRGDataProvider` service methods.
 */
@interface SRGRequest : NSObject

/**
 *  Return an equivalent request, but with the specified page size
 *
 *  @param pageSize The page size to use (values below 1 will be set to 1)
 */
- (SRGRequest *)withPageSize:(NSInteger)pageSize;

/**
 *  Return an equivalent request, but for the specified page. You never instantiate pages yourself, you receive them
 *  from the service requests supporting pagination
 *
 *  @param page The page to request. If nil, the first page with default size will be requested
 */
- (SRGRequest *)atPage:(nullable SRGPage *)page;

/**
 *  The page associated with the request
 */
@property (nonatomic, readonly) SRGPage *page;

/**
 *  Start performing the request
 *
 *  @discussion `running` is immediately set to `YES`. Attempting to resume an already running request does nothing.
 *              You can restart a finished request by calling `-resume` again
 */
- (void)resume;

/**
 *  Cancel the request
 *
 *  @discussion `running` is immediately set to `NO`. Request completion blocks (@see `SRGDataProvider`) won't be called.
 *              You can restart a cancelled request by `-calling` resume again
 */
- (void)cancel;

/**
 *  Return `YES` iff the connection is running. 
 *
 *  @discussion The request is considered running from the time it has been started to right after the associated
 *              completion block (@see `SRGDataProvider`) has been executed. It is immediately reset to `NO`
 *              when the request is cancelled
 */
@property (nonatomic, readonly, getter=isRunning) BOOL running;

/**
 *  If set to `YES`, the request automatically manages the status bar network indicator visibility when it is running.
 *  The default value is `YES`.
 *
 *  @discussion If you never manage the activity indicator yourself, you can leave this value to `YES`. The activity
 *              indicator is shown when at least one request with `managingNetworkActivityIndicator` set to `YES` is 
 *              running. Conversely, it is hidden when no such request is running
 */
@property (nonatomic, getter=isManagingNetworkActivityIndicator) BOOL managingNetworkActivityIndicator;

@end

NS_ASSUME_NONNULL_END
