//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

@_implementationOnly import SRGDataProviderRequests

/**
 *  Services for TV channels and livestreams.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  List of TV channels.
     */
    func tvChannels(for vendor: SRGVendor) -> AnyPublisher<[SRGChannel], Error> {
        let request = requestTVChannels(for: vendor)
        return objectsPublisher(for: request, rootKey: "channelList", type: SRGChannel.self)
    }
    
    /**
     *  Specific TV channel. Use this request to obtain complete channel information, including current and next programs.
     */
    func tvChannel(for vendor: SRGVendor, withUid channelUid: String) -> AnyPublisher<SRGChannel, Error> {
        let request = requestTVChannel(for: vendor, withUid: channelUid)
        return objectPublisher(for: request, type: SRGChannel.self)
    }
    
    enum TVLatestPrograms {
        public typealias Output = (channel: SRGChannel, programs: [SRGProgram])
    }
    
    /**
     *  Latest programs for a specific TV channel, including current and next programs. An optional date range (possibly
     *  half-open) can be specified to only return programs entirely contained in a given interval. If no end date is
     *  provided, only programs up to the current date are returned.
     *
     *  - Parameter livestreamUid: An optional media unique identifier (usually regional, but might be the main one). If
     *    provided, the program of the specified livestream is used, otherwise the one of the main channel.
     *
     *  - Remark: Though the completion block does not return an array directly, this request supports pagination (for programs
     *            returned in the program composition object).
     */
    func tvLatestPrograms(for vendor: SRGVendor, channelUid: String, livestreamUid: String? = nil, from: Date? = nil, to: Date? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<TVLatestPrograms.Output, Error> {
        let request = requestTVLatestPrograms(for: vendor, channelUid: channelUid, livestreamUid: livestreamUid, from:from, to: to)
        return paginatedObjectTriggeredPublisher(at: Page(request: request, size: pageSize), type: SRGProgramComposition.self, paginatedBy: signal)
            .map { ($0.channel, $0.programs ?? []) }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Programs for all TV channels on a specific day.
     *
     *  - Parameter day: The day. If `nil` today is used.
     */
    func tvPrograms(for vendor: SRGVendor, day: SRGDay? = nil) -> AnyPublisher<[SRGProgramComposition], Error> {
        let request = requestTVPrograms(for: vendor, day: day)
        return objectsPublisher(for: request, rootKey: "programGuide", type: SRGProgramComposition.self)
    }
    
    /**
     *  List of TV livestreams.
     */
    func tvLivestreams(for vendor: SRGVendor) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestTVLivestreams(for: vendor)
        return objectsPublisher(for: request, rootKey: "mediaList", type: SRGMedia.self)
    }
    
    /**
     *  List of TV scheduled livestreams.
     */
    func tvScheduledLivestreams(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestTVScheduledLivestreams(for: vendor)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: signal)
    }
}

/**
 *  Services for TV medias and episodes.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Medias which have been picked by editors.
     */
    func tvEditorialMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestTVEditorialMedias(for: vendor)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: signal)
    }
    
    /**
     *  Medias which have been picked by editors.
     */
    func tvHeroStageMedias(for vendor: SRGVendor) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestTVHeroStageMedias(for: vendor)
        return objectsPublisher(for: request, rootKey: "mediaList", type: SRGMedia.self)
    }
    
    /**
     *  Latest medias.
     */
    func tvLatestMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestTVLatestMedias(for: vendor)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: signal)
    }
    
    /**
     *  Most popular medias.
     */
    func tvMostPopularMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestTVMostPopularMedias(for: vendor)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: signal)
    }
    
    /**
     *  Medias which will soon expire.
     */
    func tvSoonExpiringMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestTVSoonExpiringMedias(for: vendor)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: signal)
    }
    
    /**
     *  Trending medias (with all editorial recommendations).
     *
     *  - Parameter limit: The maximum number of results returned (if `nil`, 10 results at most will be returned). The
     *    maximum limit is 50.
     *  - Parameter editorialLimit: The maximum number of editorial recommendations returned (if `nil`, all are returned).
     *  - Parameter episodesOnly: Whether only episodes must be returned.
     */
    func tvTrendingMedias(for vendor: SRGVendor, limit: UInt? = nil, editorialLimit: UInt? = nil, episodesOnly: Bool = false) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestTVTrendingMedias(for: vendor, withLimit: limit as NSNumber?, editorialLimit: editorialLimit as NSNumber?, episodesOnly: episodesOnly)
        return objectsPublisher(for: request, rootKey: "mediaList", type: SRGMedia.self)
    }
    
    /**
     *  Latest episodes.
     */
    func tvLatestEpisodes(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestTVLatestEpisodes(for: vendor)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: signal)
    }
    
    /**
     *  Latest web first episodes.
     */
    func tvLatestWebFirstEpisodes(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestTVLatestWebFirstEpisodes(for: vendor)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: signal)
    }
    
    /**
     *  Episodes available for a given day.
     *
     *  - Parameter day: The day. If `nil` today is used.
     */
    func tvEpisodes(for vendor: SRGVendor, day: SRGDay? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestTVEpisodes(for: vendor, day: day)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: signal)
    }
}

/**
 *  Services for TV topics.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Topics.
     */
    func tvTopics(for vendor: SRGVendor) -> AnyPublisher<[SRGTopic], Error> {
        let request = requestTVTopics(for: vendor)
        return objectsPublisher(for: request, rootKey: "topicList", type: SRGTopic.self)
    }
}

/**
 *  Services for TV shows.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Shows.
     */
    func tvShows(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<[SRGShow], Error> {
        let request = requestTVShows(for: vendor)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "showList", type: SRGShow.self, paginatedBy: signal)
    }
    
    enum TVShowsMatchingQuery {
        public typealias Output = (showUrns: [String], total: UInt)
    }
    
    /**
     *  Search shows matching a specific query, returning the matching URN list.
     *
     *  Some business units only support full-text search, not partial matching. To get complete show objects, call
     *  the `shows(withUrns:)` request with the returned URN list.
     */
    func tvShows(for vendor: SRGVendor, matchingQuery query: String, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy signal: Trigger.Signal? = nil) -> AnyPublisher<TVShowsMatchingQuery.Output, Error> {
        let request = requestTVShows(for: vendor, matchingQuery: query)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "searchResultShowList", type: SRGSearchResult.self, paginatedBy: signal)
            .map { result in
                return (result.objects.map(\.urn), result.total)
            }
            .eraseToAnyPublisher()
    }
}

#endif
