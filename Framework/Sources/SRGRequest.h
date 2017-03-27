//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  `SRGRequest` objects provide a way to manage the data retrieval process associated with a data provider 
 *  service request. You never instantiate `SRGRequest` objects directly, you merely use the ones returned 
 *  when calling `SRGDataProvider` service methods.
 *
 *  Requests are not started by default. Once you have an `SRGRequest` instance, call the `-resume` method
 *  to start the request. A started request keeps itself alive while it is running. You can therefore send
 *  a request locally without keeping a reference to it (but this makes it impossible to cancel the request
 *  manually afterwards). If you want to be able to cancel a request, keep a reference to it. To manage
 *  several related requests, use an `SRGRequestQueue`.
 */
@interface SRGRequest : NSObject

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
