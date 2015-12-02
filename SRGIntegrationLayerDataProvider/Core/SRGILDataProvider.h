//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILModelConstants.h"
#import "SRGILDataProviderConstants.h"

@class SRGILList;
@class SRGILMedia;
@class SRGILShow;
@class SRGILURLComponents;

/**
 *  Block associated with a fetch request, informing about the progresses of ALL on-going requests. This is mostly
 *  used for detailed information in the 'pull-to-refresh' feature in the Play SRG apps. One screen being composed
 *  of multiple fetch requests, it might be interesting to indicate how many are completed over the total.
 *
 *  @param fraction The fraction of all requests being completed.
 */
typedef void (^SRGILFetchListDownloadProgressBlock)(float fraction);

/**
 *  The completion block once a fetch request is done.
 *
 *  @param items     The list of items returned by the IL, if any (nil, in case of error). A SRGList is a subclass of NSArray with associated properties.
 *  @param itemClass The IL model class of the items in the list.
 *  @param error     The error associated with the request (nil, in case of a successful request).
 */
typedef void (^SRGILFetchListCompletionBlock)(SRGILList * __nullable items, Class __nullable itemClass, NSError * __nullable error);

/**
 *  The completion block associated with the request of a single media.
 *
 *  @param media The media requested (SRGILAudio or SRGILVideo) or SRGILShow.
 *  @param error The error, if any.
 */
typedef void (^SRGILRequestMediaCompletionBlock)(id __nullable media, NSError * __nullable error);


/**
 *  The completion block associated with the request of a show (audio or video).
 *
 *  @param media The show requested.
 *  @param error The error, if any.
 */
typedef void (^SRGILRequestShowCompletionBlock)(SRGILShow * __nullable show, NSError * __nullable error);


/**
 * The IL Data Provider is the main class to interact with the Integration Layer.
 *
 */
@interface SRGILDataProvider : NSObject 

/**
 *  Designated initializer of the data provider.
 *
 *  @param businessUnit A three-letters string indicating the BU, can either be 'srf', 'rts', 'rsi', 'rtr' or 'swi'.
 *
 *  @return A new instance of the IL data provider.
 */
- (nullable instancetype)initWithBusinessUnit:(nonnull NSString *)businessUnit NS_DESIGNATED_INITIALIZER;

/**
 *  The business unit the data provider is hooked into.
 *
 *  @return The 3-letter string passed as parameter during the init.
 */
- (nonnull NSString *)businessUnit;

// ********* Fetch lists of IL model objects **********

/**
 *  Fetch items of a specific 'index' from the IL, or from a local storage (Favorites). If no request path can be 
 *  constructed from the index and its potential argument, returns NO and no request is made, and the completion block
 *  is NOT called either.
 * 
 *  @param components      The URL components build with the SRGILURLComponents factory.
 *  @param orgType         The organisation type: flat of alphabetical.
 *  @param progressBlock   The block to be used to be informed of the progress of the fetch. See documentation of SRGILFetchListDownloadProgressBlock abive.
 *  @param completionBlock The block to be used upon fetch completion.
 */
- (void)fetchObjectsListWithURLComponents:(nonnull SRGILURLComponents *)components
                                organised:(SRGILModelDataOrganisationType)orgType
                               onProgress:(nullable SRGILFetchListDownloadProgressBlock)progressBlock
                             onCompletion:(nonnull SRGILFetchListCompletionBlock)completionBlock;

/**
 *  Indicates the number of current fetches ongoing.
 *
 *  @return An integer of the count of current fetch requests.
 */
- (NSUInteger)ongoingFetchCount;

/**
 *  Return the fetch date for a given list index.
 *
 *  @param index The index of the list
 *
 *  @return The date associated with the last successful retrieval of the list.
 */
- (nullable NSDate *)fetchDateForIndex:(enum SRGILFetchListIndex)index;

/**
 *  Return the last date of fetch for a given set of indexes. Useful for indicating the last refresh date of a 
 *  screen containing multiple lists of items. If no fetch date is available, return the reference date.
 *
 *  @param indexes The indexes of lists.
 *
 *  @return The last of the fetch dates associated with the indexes.
 */
- (nullable NSDate *)lastFetchDateForIndexes:(nonnull NSArray *)indexes;


// ********* Fetch individual media of IL model objects **********

/**
 *  Fetch an individual media (Video or Audio) from the IL.
 *
 *  @param mediaType       The media type
 *  @param assetIdentifier The identifier of the media.
 *  @param completionBlock The block called on completion (with success or not).
 *
 *  @return A boolean indicating if the fetch is started or not.
 */
- (BOOL)fetchMediaWithURNString:(nonnull NSString *)urnString
                completionBlock:(nonnull SRGILRequestMediaCompletionBlock)completionBlock;

/**
 *  Fetch the meta infos for the live streams.
 *
 *  @param mediaType       The media type
 *  @param identifier      The identifier of the media.
 *  @param completionBlock The block called on completion (with success or not).
 *
 *  @return A boolean indicating if the fetch is started or not.
 */
- (BOOL)fetchLiveMetaInfosWithURNString:(nonnull NSString *)urnString
                        completionBlock:(nonnull SRGILRequestMediaCompletionBlock)completionBlock;

/**
 * Fetch show with given identifier.
 *
 * @param urnString URN of the show
 * @param completionBlock The block called on completion (with success or not).
 *
 * @return A boolean indicating if the fetch is started or not.
 */
- (BOOL)fetchShowWithIdentifier:(nonnull NSString *)identifier
                completionBlock:(nonnull SRGILRequestMediaCompletionBlock)completionBlock;


// ********* Data Accessors **********

/**
 *  Returns the list associated with a given index. Does NOT work for lists with organisation type = Alphabetical (yet).
 *
 *  @param index The index of the list
 *
 *  @return An instance of the list of items associated with that index.
 */
- (nullable SRGILList *)itemsListForIndex:(enum SRGILFetchListIndex)index;

/**
 *  Access an already-fetch media, if any. If it is not yet fetched, returns nil.
 *
 *  @param urnString The URN string of the media (not its identifier).
 *
 *  @return An instance of the media with that URN.
 */
- (nullable  SRGILMedia *)mediaForURNString:(nonnull NSString *)urnString;

/**
 *  Access an already-fetch show, if any. If it is not yet fetched, returns nil.
 *
 *  @param identifier The identifier of the show
 *
 *  @return An instance of the media with that identifier.
 */
- (nullable  SRGILShow *)showForIdentifier:(nonnull NSString *)identifier;


// ********* Network checks **********

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Whether the network connection at the time of calling is using the WIFI or not.
 */
+ (BOOL)isUsingWIFI;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Returns the SSID string of the current WIFI, if 'isUsingWIFI' returns 'YES'.
 *  Returns nil otherwise.
 */
+ (nullable NSString *)WIFISSID;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Whether the network connection at the time of calling is using a Swisscom WIFI.
 *  Returns 'NO' if the method 'isUsingWIFI' returns 'NO', obviously.
 */
+ (BOOL)isUsingSwisscomWIFI;



@end
