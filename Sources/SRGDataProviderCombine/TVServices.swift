//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine

/**
 *  List of TV-oriented services supported by the data provider. Media list requests collect content for all channels
 *  and do not make any distinction between them.
 */

// MARK: - Channels and livestreams

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVChannels {
        public typealias Output = (channels: [SRGChannel], response: URLResponse)
    }
    
    /**
     *  List of TV channels.
     */
    func tvChannels(for vendor: SRGVendor) -> AnyPublisher<TVChannels.Output, Error> {
        let request = requestTVChannels(for: vendor)
        return objectsTaskPublisher(for: request, rootKey: "channelList", type: SRGChannel.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVChannel {
        public typealias Output = (channel: SRGChannel, response: URLResponse)
    }
    
    /**
     *  Specific TV channel. Use this request to obtain complete channel information, including current and next programs.
     */
    func tvChannel(for vendor: SRGVendor, withUid channelUid: String) -> AnyPublisher<TVChannel.Output, Error> {
        let request = requestTVChannel(for: vendor, withUid: channelUid)
        return objectTaskPublisher(for: request, type: SRGChannel.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVLatestPrograms {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (programComposition: SRGProgramComposition, page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Latest programs for a specific TV channel, including current and next programs. An optional date range (possibly
     *  half-open) can be specified to only return programs entirely contained in a given interval. If no end date is
     *  provided, only programs up to the current date are returned.
     *
     *  - Parameter livestreamUid: An optional media unique identifier (usually regional, but might be the main one). If
     *    provided, the program of the specified livestream is used, otherwise the one of the main channel.
     *
     *  Though the completion block does not return an array directly, this request supports pagination (for programs
     *  returned in the program composition object).
     */
    func tvLatestPrograms(for vendor: SRGVendor, channelUid: String, livestreamUid: String? = nil, from: Date? = nil, to: Date? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVLatestPrograms.Output, Error> {
        let request = requestTVLatestPrograms(for: vendor, channelUid: channelUid, livestreamUid: livestreamUid, from:from, to: to)
        return tvLatestPrograms(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func tvLatestPrograms(at page: TVLatestPrograms.Page) -> AnyPublisher<TVLatestPrograms.Output, Error> {
        return paginatedObjectTaskPublisher(for: page.request, type: SRGProgramComposition.self)
            .map { result in
                (result.object, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVLivestreams {
        public typealias Output = (medias: [SRGMedia], response: URLResponse)
    }
    
    /**
     *  List of TV livestreams.
     */
    func tvLivestreams(for vendor: SRGVendor) -> AnyPublisher<TVLivestreams.Output, Error> {
        let request = requestTVLivestreams(for: vendor)
        return objectsTaskPublisher(for: request, rootKey: "mediaList", type: SRGMedia.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVScheduledLivestreams {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  List of TV scheduled livestreams.
     */
    func tvLatestPrograms(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVScheduledLivestreams.Output, Error> {
        let request = requestTVScheduledLivestreams(for: vendor)
        return tvScheduledLivestreams(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func tvScheduledLivestreams(at page: TVScheduledLivestreams.Page) -> AnyPublisher<TVScheduledLivestreams.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Media and episode retrieval

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVEditorialMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Medias which have been picked by editors.
     */
    func tvEditorialMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVEditorialMedias.Output, Error> {
        let request = requestTVEditorialMedias(for: vendor)
        return tvEditorialMedias(at: Page(request: request, size: pageSize))
    }

    /**
     *  Next page of results.
     */
    func tvEditorialMedias(at page: TVEditorialMedias.Page) -> AnyPublisher<TVEditorialMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVLatestMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Latest medias.
     */
    func tvLatestMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVLatestMedias.Output, Error> {
        let request = requestTVLatestMedias(for: vendor)
        return tvLatestMedias(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func tvLatestMedias(at page: TVLatestMedias.Page) -> AnyPublisher<TVLatestMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVMostPopularMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Most popular medias.
     */
    func tvMostPopularMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVMostPopularMedias.Output, Error> {
        let request = requestTVMostPopularMedias(for: vendor)
        return tvMostPopularMedias(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func tvMostPopularMedias(at page: TVMostPopularMedias.Page) -> AnyPublisher<TVMostPopularMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVSoonExpiringMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Medias which will soon expire.
     */
    func tvSoonExpiringMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVSoonExpiringMedias.Output, Error> {
        let request = requestTVSoonExpiringMedias(for: vendor)
        return tvSoonExpiringMedias(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func tvSoonExpiringMedias(at page: TVSoonExpiringMedias.Page) -> AnyPublisher<TVSoonExpiringMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVTrendingMedias {
        public typealias Output = (medias: [SRGMedia], response: URLResponse)
    }
    
    /**
     *  Trending medias (with all editorial recommendations).
     *
     *  - Parameter limit: The maximum number of results returned (if `nil`, 10 results at most will be returned). The
     *    maximum limit is 50.
     *  - Parameter editorialLimit: The maximum number of editorial recommendations returned (if `nil`, all are returned).
     *  - Parameter episodesOnly: Whether only episodes must be returned.
     */
    func tvTrendingMedias(for vendor: SRGVendor, limit: Int? = nil, editorialLimit: Int? = nil, episodesOnly: Bool = false, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVTrendingMedias.Output, Error> {
        let request = requestTVTrendingMedias(for: vendor, withLimit: limit as NSNumber?, editorialLimit: editorialLimit as NSNumber?, episodesOnly: episodesOnly)
        return objectsTaskPublisher(for: request, rootKey: "mediaList", type: SRGMedia.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVLatestEpisodes {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Latest episodes.
     */
    func tvLatestEpisodes(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVLatestEpisodes.Output, Error> {
        let request = requestTVLatestEpisodes(for: vendor)
        return tvLatestEpisodes(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func tvLatestEpisodes(at page: TVLatestEpisodes.Page) -> AnyPublisher<TVLatestEpisodes.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVEpisodes {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Episodes available for a given day.
     *
     *  - Parameter day: The day. If `nil`, today is used.
     */
    func tvEpisodes(for vendor: SRGVendor, day: SRGDay? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVEpisodes.Output, Error> {
        let request = requestTVEpisodes(for: vendor, day: day)
        return tvEpisodes(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func tvEpisodes(at page: TVEpisodes.Page) -> AnyPublisher<TVEpisodes.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Topics

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVTopics {
        public typealias Output = (topics: [SRGTopic], response: URLResponse)
    }
    
    /**
     *  Topics.
     */
    func tvTopics(for vendor: SRGVendor) -> AnyPublisher<TVTopics.Output, Error> {
        let request = requestTVTopics(for: vendor)
        return objectsTaskPublisher(for: request, rootKey: "topicList", type: SRGTopic.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

// MARK: - Shows

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVShows {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (shows: [SRGShow], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Shows.
     */
    func tvShows(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVShows.Output, Error> {
        let request = requestTVShows(for: vendor)
        return tvShows(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func tvShows(at page: TVShows.Page) -> AnyPublisher<TVShows.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "showList", type: SRGShow.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVShowsMatchingQuery {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (showUrns: [String], total: UInt, page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Search shows matching a specific query.
     *
     *  Some business units only support full-text search, not partial matching. To get complete show objects, call
     *  the `shows(withUrns:)` request with the returned URN list.
     */
    func tvShows(for vendor: SRGVendor, matchingQuery query: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVShowsMatchingQuery.Output, Error> {
        let request = requestTVShows(for: vendor, matchingQuery: query)
        return tvShows(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func tvShows(at page: TVShowsMatchingQuery.Page) -> AnyPublisher<TVShowsMatchingQuery.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "searchResultShowList", type: SRGSearchResult.self)
            .map { result in
                return (result.objects.map(\.urn), result.total, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}
