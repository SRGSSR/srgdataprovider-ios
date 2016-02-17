//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

/**
 * Error codes
 */
typedef NS_ENUM (NSInteger, SRGILDataProviderErrorCode) {
    SRGILDataProviderErrorCodeInvalidRequest,
    SRGILDataProviderErrorCodeInvalidData,
    SRGILDataProviderErrorCodeUnavailable
};

// Domain for IL errors
extern NSString * const SRGILDataProviderErrorDomain;

/**
 *  Fetched data from the IL can be returned, organised in different ways.
 */
typedef NS_ENUM(NSInteger, SRGILModelDataOrganisationType){
    /**
     *  The fetched data is returned as a flat list of items.
     */
    SRGILModelDataOrganisationTypeFlat,
    /**
     *  The fetched data is returned as an array of arrays of items, organised alphabetically.
     */
    SRGILModelDataOrganisationTypeAlphabetical,
};

/**
 *  The various entry points of the IL are listed here as 'indices'. A request to one of these indices return a list
 *  of items.
 */
typedef NS_ENUM(NSInteger, SRGILFetchListIndex) {
    SRGILFetchListEnumBegin,
    
    SRGILFetchListVideoLiveStreams = SRGILFetchListEnumBegin,
    SRGILFetchListVideoTrendingPicks,
    SRGILFetchListVideoEditorialPicks,
    SRGILFetchListVideoMostClicked,
    SRGILFetchListVideoMostRecent,
    SRGILFetchListVideoEpisodesByDate,
    SRGILFetchListVideoTopics,
    SRGILFetchListVideoMostRecentByTopic,
    SRGILFetchListVideoSearch,
    SRGILFetchListVideoShowsAlphabetical,
    SRGILFetchListVideoShowsSearch,
    SRGILFetchListVideoShowDetail,
    SRGILFetchListVideoByEvent,

    SRGILFetchListAudioLiveStreams,
    SRGILFetchListAudioEditorialLatest,
    SRGILFetchListAudioMostClicked,
    SRGILFetchListAudioMostRecent,
    SRGILFetchListAudioSearch,
    SRGILFetchListAudioShowsAlphabetical,
    SRGILFetchListAudioShowsSearch,
    SRGILFetchListAudioShowDetail,

    SRGILFetchListSonglogPlaying,
    SRGILFetchListSonglogLatest,
    
    SRGILFetchListMediaFavorite,
    SRGILFetchListShowFavorite,
    
    SRGILFetchListEvents,
    
    SRGILFetchListEnumEnd,
    SRGILFetchListEnumSize = SRGILFetchListEnumEnd - SRGILFetchListEnumBegin
};

/**
 * Miscellaneous
 */
extern NSString *const SRGILFetchListURLComponentsEmptySearchQueryString;
