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
 *
 *  Requests are not started by default. Once you have an `SRGRequest` instance, call the `-resume` method
 *  to start the request. If you need to manage several related requests, use an `SRGRequestQueue`.
 *
 *  If a request is not retained, it will get deallocated and automatically cancelled. When getting a request
 *  from the data provider, you should therefore use one of the following strategies:
 *    - Assign the request to a property with strong semantics. This also provides an easy reference for
 *      later cancelling the request.
 *    - Associate the request with a queue. The queue itself must also be retained elsewhere.
 *    - Create a one-shot request by using a _block reference `nil`led within the request completion block, as
 *      follows:
 *
 *      __block SRGRequest *request = [dataProvider someRequestWithCompletionBlock:^( ... ) {
 *          request = nil;
 *      }];
 *      [request resume];
 */
@interface SRGRequest : NSObject

/**
 *  Return an equivalent request, but with the specified page size
 *
 *  @param pageSize The page size to use (values below 1 will be set to 1)
 * 
 *  @discussion If `withPageSize:`called twice or more, only the latest called value will be considered.
 */
- (SRGRequest *)withPageSize:(NSInteger)pageSize;

/**
 *  Return an equivalent request, but for the specified page. You never instantiate pages yourself, you receive them
 *  from service requests supporting pagination
 *
 *  @param page The page to request. If nil, the first page is requested (for the same page size as the receiver)
 *
 *  @discussion The `-atPage:` method must be called on a related request, otherwise the behavior is undefined
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
 *  Return `YES` iff the request is running. 
 *
 *  @discussion The request is considered running from the time it has been started to right after the associated
 *              completion block (@see `SRGDataProvider`) has been executed. It is immediately reset to `NO`
 *              when the request is cancelled.
 *
 *              This property is KVO-observable
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
