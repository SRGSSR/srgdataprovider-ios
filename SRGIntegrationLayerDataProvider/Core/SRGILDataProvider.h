//
//  SRGILDataProvider.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 31/03/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILModelConstants.h"

@class SRGILList;
@class SRGILMedia;
@class SRGILShow;

typedef NS_ENUM(NSInteger, SRGILModelDataOrganisationType) {
    SRGILModelDataOrganisationTypeFlat,
    SRGILModelDataOrganisationTypeAlphabetical,
};

typedef NS_ENUM(NSInteger, SRGILFetchListIndex) {
    SRGILFetchListEnumBegin,
    SRGILFetchListVideoLiveStreams = SRGILFetchListEnumBegin,
    SRGILFetchListVideoEditorialPicks,
    SRGILFetchListVideoMostRecent,
    SRGILFetchListVideoMostSeen,
    SRGILFetchListVideoShowsAZ,
    SRGILFetchListVideoShowsAZDetail,
    SRGILFetchListVideoShowsByDate,
    SRGILFetchListVideoSearchResult,
    SRGILFetchListAudioLiveStreams,
    SRGILFetchListAudioMostRecent,
    SRGILFetchListAudioMostListened,
    SRGILFetchListAudioShowsAZ,
    SRGILFetchListAudioShowsAZDetail,
    SRGILFetchListMediaFavorite,  // local storage fetch
    SRGILFetchListShowFavorite, // local storage fetch
    SRGILFetchListEnumEnd,
    SRGILFetchListEnumSize = SRGILFetchListEnumEnd - SRGILFetchListEnumBegin
};

static const float DOWNLOAD_PROGRESS_DONE = 1.0;

typedef void (^SRGILFetchListDownloadProgressBlock)(float fraction);
typedef void (^SRGILFetchListCompletionBlock)(SRGILList *items, Class itemClass, NSError *error);
typedef void (^SRGILRequestMediaCompletionBlock)(SRGILMedia *media, NSError *error);

@interface SRGILDataProvider : NSObject 

/**
 *  Designated initialize of the data provider.
 *
 *  @param businessUnit A three-letters string indicating the BU, can either be 'srf', 'rts', 'rsi', 'rtr' or 'swi'.
 *
 *  @return A new instance of the IL data provider.
 */
- (instancetype)initWithBusinessUnit:(NSString *)businessUnit NS_DESIGNATED_INITIALIZER;

/**
 *  The business unit the data provider is hooked into.
 *
 *  @return The 3-letter string passed as parameter during the init.
 */
- (NSString *)businessUnit;

// ********* Fetch lists of IL model objects **********

/**
 *  Fetch items of a specific 'index' from the IL, or from a local storage (Favorites). If no request path can be 
 *  constructed from the index and its potential argument, returns NO and no request is made, and the completion block
 *  is NOT called either.
 * 
 *  @param index           The list "index". See enum SRGILFetchListIndex.
 *  @param arg             The argument to be used to build the URL path for fetching data. Highly
 *  @param orgType         The organisation type: flat of alphabetical.
 *  @param progressBlock   The block to be used to be informed of the progress of the fetch.
 *  @param completionBlock The block to be used upon fetch completion.
 *
 *  @return A boolean value indicating whether the fetch is valid or not (it may not, depending on the argument).
 */
- (BOOL)fetchListOfIndex:(enum SRGILFetchListIndex)index
        withPathArgument:(id)arg
               organised:(SRGILModelDataOrganisationType)orgType
              onProgress:(SRGILFetchListDownloadProgressBlock)progressBlock
            onCompletion:(SRGILFetchListCompletionBlock)completionBlock;

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
- (NSDate *)fetchDateForIndex:(enum SRGILFetchListIndex)index;

/**
 *  Return the last date of fetch for a given set of indexes. Useful for indicating the last refresh date of a 
 *  screen containing multiple lists of items.
 *
 *  @param indexes The indexes of lists.
 *
 *  @return The last of the fetch dates associated with the indexes.
 */
- (NSDate *)lastFetchDateForIndexes:(NSArray *)indexes;

/**
 *  Indicates whether the current fetch path is valid for the given index or not. Corresponds to the last 
 *  value returned by 'fetchListOfIndex:...' for that index.
 *
 *  @param index The fetch list index.
 *
 *  @return A boolean value indicating if the last fetch path for that index was valid or not.
 */
- (BOOL)isFetchPathValidForIndex:(enum SRGILFetchListIndex)index;

/**
 *  Reset the fetch path for the given index.
 *
 *  @param index The index for which the path must be reset.
 */
- (void)resetFetchPathForIndex:(enum SRGILFetchListIndex)index;


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
- (BOOL)fetchMediaWithURNString:(NSString *)urnString
                completionBlock:(SRGILRequestMediaCompletionBlock)completionBlock;

/**
 *  Fetch the meta infos for the live streams.
 *
 *  @param mediaType       The media type
 *  @param identifier      The identifier of the media.
 *  @param completionBlock The block called on completion (with success or not).
 *
 *  @return A boolean indicating if the fetch is started or not.
 */
- (BOOL)fetchLiveMetaInfosWithURNString:(NSString *)urnString
                        completionBlock:(SRGILRequestMediaCompletionBlock)completionBlock;


// ********* Data Accessors **********

/**
 *  Returns the list associated with a given index. Does NOT work for lists with organisation type = Alphabetical (yet).
 *
 *  @param index The index of the list
 *
 *  @return An instance of the list of items associated with that index.
 */
- (SRGILList *)itemsListForIndex:(enum SRGILFetchListIndex)index;

/**
 *  Access an already-fetch media, if any. If it is not yet fetched, returns nil.
 *
 *  @param urnString The URN string of the media (not its identifier).
 *
 *  @return An instance of the media with that URN.
 */
- (SRGILMedia *)mediaForURNString:(NSString *)urnString;

/**
 *  Access an already-fetch show, if any. If it is not yet fetched, returns nil.
 *
 *  @param identifier The identifier of the show
 *
 *  @return An instance of the media with that identifier.
 */
- (SRGILShow *)showForIdentifier:(NSString *)identifier;


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
+ (NSString *)WIFISSID;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Whether the network connection at the time of calling is using a Swisscom WIFI.
 *  Returns 'NO' if the method 'isUsingWIFI' returns 'NO', obviously.
 */
+ (BOOL)isUsingSwisscomWIFI;



@end
