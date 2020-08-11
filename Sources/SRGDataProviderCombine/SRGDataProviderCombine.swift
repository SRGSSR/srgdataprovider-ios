//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@_exported import Combine
@_exported import SRGDataProvider
@_exported import SRGDataProviderModel

import Mantle
import SRGDataProviderRequests
import SRGNetwork

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum SRGDataProviderError: Error {
    case http(statusCode: Int)
    case invalidData
}

// MARK: - TV Services

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
                return (result.objects.map { $0.urn }, result.total, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Channels and livestreams

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioChannels {
        public typealias Output = (channels: [SRGChannel], response: URLResponse)
    }
    
    /**
     *  List of radio channels.
     */
    func radioChannels(for vendor: SRGVendor) -> AnyPublisher<RadioChannels.Output, Error> {
        let request = requestRadioChannels(for: vendor)
        return objectsTaskPublisher(for: request, rootKey: "channelList", type: SRGChannel.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioChannel {
        public typealias Output = (channel: SRGChannel, response: URLResponse)
    }
    
    /**
     *  Specific radio channel. Use this request to obtain complete channel information, including current and next
     *  programs.
     *
     *  - Parameter livestreamUid: An optional media unique identifier (usually regional, but might be the main one). If
     *    provided, the program of the specified live stream is used, otherwise the one of the main channel.
     */
    func radioChannel(for vendor: SRGVendor, withUid channelUid: String, livestreamUid: String? = nil) -> AnyPublisher<RadioChannel.Output, Error> {
        let request = requestRadioChannel(for: vendor, withUid: channelUid, livestreamUid: livestreamUid)
        return objectTaskPublisher(for: request, type: SRGChannel.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioLatestPrograms {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (programComposition: SRGProgramComposition, page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Latest programs for a specific radio channel, including current and next programs. An optional date range (possibly
     *  half-open) can be specified to only return programs entirely contained in a given interval. If no end date is
     *  provided, only programs up to the current date are returned.
     *
     *  - Parameter livestreamUid: An optional media unique identifier (usually the main one). If provided, the program
     *    of the specified livestream is used, otherwise the one of the main channel.
     *
     *  Though the completion block does not return an array directly, this request supports pagination (for programs
     *  returned in the program composition object).
     */
    func radioLatestPrograms(for vendor: SRGVendor, channelUid: String, livestreamUid: String? = nil, from: Date? = nil, to: Date? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<RadioLatestPrograms.Output, Error> {
        let request = requestRadioLatestPrograms(for: vendor, channelUid: channelUid, livestreamUid: livestreamUid, from:from, to: to)
        return radioLatestPrograms(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func radioLatestPrograms(at page: RadioLatestPrograms.Page) -> AnyPublisher<RadioLatestPrograms.Output, Error> {
        return paginatedObjectTaskPublisher(for: page.request, type: SRGProgramComposition.self)
            .map { result in
                (result.object, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioLivestreams {
        public typealias Output = (medias: [SRGMedia], response: URLResponse)
    }
    
    /**
     *  List of radio livestreams for a channel.
     *
     *  - Parameter channelUid: The channel uid for which audio livestreams (main and regional) must be retrieved.
     */
    func radioLivestreams(for vendor: SRGVendor, channelUid: String) -> AnyPublisher<RadioLivestreams.Output, Error> {
        let request = requestRadioLivestreams(for: vendor, channelUid: channelUid)
        return objectsTaskPublisher(for: request, rootKey: "mediaList", type: SRGMedia.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioLivestreamsForContentProviders {
        public typealias Output = (medias: [SRGMedia], response: URLResponse)
    }
    
    /**
     *  List of radio livestreams.
     *
     *  - Parameter contentProviders: The content providers to return radio livestreams for.
     */
    func radioLivestreams(for vendor: SRGVendor, contentProviders: SRGContentProviders) -> AnyPublisher<RadioLivestreamsForContentProviders.Output, Error> {
        let request = requestRadioLivestreams(for: vendor, contentProviders: contentProviders)
        return objectsTaskPublisher(for: request, rootKey: "mediaList", type: SRGMedia.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

// MARK: - Media and episode retrieval

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioLatestMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Latest medias for a specific channel.
     */
    func radioLatestMedias(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<RadioLatestMedias.Output, Error> {
        let request = requestRadioLatestMedias(for: vendor, channelUid: channelUid)
        return radioLatestMedias(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func radioLatestMedias(at page: RadioLatestMedias.Page) -> AnyPublisher<RadioLatestMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioMostPopularMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Most popular medias for a specific channel.
     */
    func radioMostPopularMedias(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<RadioMostPopularMedias.Output, Error> {
        let request = requestRadioMostPopularMedias(for: vendor, channelUid: channelUid)
        return radioMostPopularMedias(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func radioMostPopularMedias(at page: RadioMostPopularMedias.Page) -> AnyPublisher<RadioMostPopularMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioLatestEpisodes {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Latest episodes for a specific channel.
     */
    func radioLatestEpisodes(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<RadioLatestEpisodes.Output, Error> {
        let request = requestRadioLatestEpisodes(for: vendor, channelUid: channelUid)
        return radioLatestEpisodes(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func radioLatestEpisodes(at page: RadioLatestEpisodes.Page) -> AnyPublisher<RadioLatestEpisodes.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioEpisodes {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Episodes available for a given day, for the specific channel.
     *
     *  - Parameter day: The day. If `nil`, today is used.
     */
    func radioEpisodes(for vendor: SRGVendor, channelUid: String, day: SRGDay? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<RadioEpisodes.Output, Error> {
        let request = requestRadioEpisodes(for: vendor, channelUid: channelUid, day: day)
        return radioEpisodes(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func radioEpisodes(at page: RadioEpisodes.Page) -> AnyPublisher<RadioEpisodes.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioLatestVideos {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Latest video medias for a specific channel.
     */
    func radioLatestVideos(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<RadioLatestVideos.Output, Error> {
        let request = requestRadioLatestVideos(for: vendor, channelUid: channelUid)
        return radioLatestVideos(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func radioLatestVideos(at page: RadioLatestVideos.Page) -> AnyPublisher<RadioLatestVideos.Output, Error> {
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
    enum RadioTopics {
        public typealias Output = (topics: [SRGTopic], response: URLResponse)
    }
    
    /**
     *  Topics.
     */
    func radioTopics(for vendor: SRGVendor) -> AnyPublisher<RadioTopics.Output, Error> {
        let request = requestRadioTopics(for: vendor)
        return objectsTaskPublisher(for: request, rootKey: "topicList", type: SRGTopic.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioShows {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (shows: [SRGShow], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Shows by channel.
     */
    func radioShows(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<RadioShows.Output, Error> {
        let request = requestRadioShows(for: vendor, channelUid: channelUid)
        return radioShows(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func radioShows(at page: RadioShows.Page) -> AnyPublisher<RadioShows.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "showList", type: SRGShow.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioShowsMatchingQuery {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (showUrns: [String], total: UInt, page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Search shows matching a specific query.
     *
     *  Some business units only support full-text search, not partial matching. To get complete show objects, call the
     *  `shows(withUrns:)` request with the returned URN list.
     */
    func radioShows(for vendor: SRGVendor, matchingQuery query: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<RadioShowsMatchingQuery.Output, Error> {
        let request = requestRadioShows(for: vendor, matchingQuery: query)
        return radioShows(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func radioShows(at page: RadioShowsMatchingQuery.Page) -> AnyPublisher<RadioShowsMatchingQuery.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "searchResultShowList", type: SRGSearchResult.self)
            .map { result in
                (result.objects.map { $0.urn }, result.total, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Song list

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioSongs {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (songs: [SRGSong], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Song list by channel.
     */
    func radioSongs(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<RadioSongs.Output, Error> {
        let request = requestRadioSongs(for: vendor, channelUid: channelUid)
        return radioSongs(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func radioSongs(at page: RadioSongs.Page) -> AnyPublisher<RadioSongs.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "songList", type: SRGSong.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RadioCurrentSong {
        public typealias Output = (song: SRGSong, response: URLResponse)
    }
    
    /**
     *  Current song by channel.
     *
     *  If no song is currently being played, the completion block is called with both song and error set to `nil`.
     */
    func radioCurrentSong(for vendor: SRGVendor, channelUid: String) -> AnyPublisher<RadioCurrentSong.Output, Error> {
        let request = requestRadioCurrentSong(for: vendor, channelUid: channelUid)
        return objectTaskPublisher(for: request, type: SRGSong.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum LiveCenterVideos {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  List of videos available from the Live Center.
     */
    func liveCenterVideos(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<LiveCenterVideos.Output, Error> {
        let request = requestLiveCenterVideos(for: vendor)
        return liveCenterVideos(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func liveCenterVideos(at page: LiveCenterVideos.Page) -> AnyPublisher<LiveCenterVideos.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum MediasMatchingQuery {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (mediaUrns: [String], total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?, page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Search medias matching a specific query.
     *
     *  To get complete media objects, call the `medias(withUrns:)` request with the returned URN list. Refer to the
     *  Service availability matrix for information about which vendors support settings. By default aggregations are
     *  returned, which can lead to longer response times. If you do not need aggregations, provide a settings object
     *  to disable them.
     */
    func medias(for vendor: SRGVendor, matchingQuery query: String?, with settings: SRGMediaSearchSettings?, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<MediasMatchingQuery.Output, Error> {
        let request = requestMedias(for: vendor, matchingQuery: query, with: settings)
        return medias(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func medias(at page: MediasMatchingQuery.Page) -> AnyPublisher<MediasMatchingQuery.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "searchResultMediaList", type: SRGSearchResult.self)
            .map { result in
                (result.objects.map { $0.urn }, result.total, result.aggregations, result.suggestions, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum ShowsMatchingQuery {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (showUrns: [String], total: UInt, page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Search shows matching a specific query.
     *
     *  If set to a value different from `SRGMediaTypeNone`, filter shows for which content of the specified type is
     *  available. To get complete show objects, call the `shows(withUrns:)` request with the returned URN list.
     */
    func shows(for vendor: SRGVendor, matchingQuery query: String, mediaType: SRGMediaType, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<ShowsMatchingQuery.Output, Error> {
        let request = requestShows(for: vendor, matchingQuery: query, mediaType: mediaType)
        return shows(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func shows(at page: ShowsMatchingQuery.Page) -> AnyPublisher<ShowsMatchingQuery.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "searchResultShowList", type: SRGSearchResult.self)
            .map { result in
                (result.objects.map { $0.urn }, result.total, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum MostSearchedShows {
        public typealias Output = (shows: [SRGShow], response: URLResponse)
    }
    
    /**
     *  Retrieve the list of shows which are searched the most.
     */
    func mostSearchedShows(for vendor: SRGVendor) -> AnyPublisher<MostSearchedShows.Output, Error> {
        let request = requestMostSearchedShows(for: vendor)
        return objectsTaskPublisher(for: request, rootKey: "showList", type: SRGShow.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum VideosWithTags {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  List medias with specific tags.
     *
     *  - Parameter tags: List of tags (at least one is required).
     *  - Parameter excludedTags: An optional list of excluded tags.
     *  - Parameter fullLengthExcluded: Set to `YES` to exclude full length videos.
     */
    func videos(for vendor: SRGVendor, withTags tags: [String], excludedTags: [String]? = nil, fullLengthExcluded: Bool = false, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<VideosWithTags.Output, Error> {
        let request = requestVideos(for: vendor, withTags: tags, excludedTags: excludedTags, fullLengthExcluded: fullLengthExcluded)
        return videos(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func videos(at page: VideosWithTags.Page) -> AnyPublisher<VideosWithTags.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum RecommendedMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  List recommended medias for a specific media URN and, optionally, a user id.
     *
     *  - Parameter URN: A specific media URN.
     *  - Parameter userId: An optional user identifier.
     */
    func recommendedMedias(forUrn urn: String, userId: String?, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<RecommendedMedias.Output, Error> {
        let request = requestRecommendedMedias(forURN: urn, userId: userId)
        return recommendedMedias(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func recommendedMedias(at page: RecommendedMedias.Page) -> AnyPublisher<RecommendedMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum Modules {
        public typealias Output = (modules: [SRGModule], response: URLResponse)
    }
    
    /**
     *  List modules for a specific type (e.g. events).
     *
     *  - Parameter moduleType: A specific module type.
     */
    func modules(for vendor: SRGVendor, type: SRGModuleType) -> AnyPublisher<Modules.Output, Error> {
        let request = requestModules(for: vendor, type: type)
        return objectsTaskPublisher(for: request, rootKey: "moduleConfigList", type: SRGModule.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum ServiceMessage {
        public typealias Output = (message: SRGServiceMessage, response: URLResponse)
    }
    
    /**
     *  Retrieve a message from the service about its status, if there is currently one. If none is available, the
     *  call ends with an HTTP error.
     */
    func serviceMessage(for vendor: SRGVendor) -> AnyPublisher<ServiceMessage.Output, Error> {
        let request = requestServiceMessage(for: vendor)
        return objectTaskPublisher(for: request, type: SRGServiceMessage.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum IncreaseSocialCount {
        public typealias Output = (overview: SRGSocialCountOverview, response: URLResponse)
    }
    
    /**
     *  Increase the specified social count from 1 unit for the specified URN, with the corresponding event data
     *  (see `SRGSubdivision` class).
     */
    func increaseSocialCount(for type: SRGSocialCountType, urn: String, event: String) -> AnyPublisher<IncreaseSocialCount.Output, Error> {
        let request = requestIncreaseSocialCount(for: type, urn: urn, event: event)
        return objectTaskPublisher(for: request, type: SRGSocialCountOverview.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum IncreaseShowSearchResultsViewCount {
        public typealias Output = (overview: SRGShowStatisticsOverview, response: URLResponse)
    }
    
    /**
     *  Increase the number of times a show has been viewed from search results.
     */
    func increaseSearchResultsViewCount(for show: SRGShow) -> AnyPublisher<IncreaseShowSearchResultsViewCount.Output, Error> {
        let request = requestIncreaseSearchResultsViewCount(for: show)
        return objectTaskPublisher(for: request, type: SRGShowStatisticsOverview.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum Media {
        public typealias Output = (media: SRGMedia, response: URLResponse)
    }
    
    /**
     *  Retrieve the media having the specified URN.
     *
     *  @discussion If you need to retrieve several medias, use `medias(withUrns:)` instead.
     */
    func media(withUrn urn: String) -> AnyPublisher<Media.Output, Error> {
        let request = requestMedia(withURN: urn)
        return objectTaskPublisher(for: request, type: SRGMedia.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum Medias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Retrieve medias matching a URN list.
     *
     *  Partial results can be returned if some URNs are invalid. Note that you can mix audio and video URNs, or URNs
     *  from different business units.
     */
    func medias(withUrns urns: [String], pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<Medias.Output, Error> {
        let request = requestMedias(withURNs: urns)
        return medias(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func medias(at page: Medias.Page) -> AnyPublisher<Medias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum LatestMediasForTopic {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Latest medias for a specific topic.
     *
     *  - Parameter topicURN: The unique topic URN.
     */
    func latestMediasForTopic(withUrn topicUrn: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<LatestMediasForTopic.Output, Error> {
        let request = requestLatestMediasForTopic(withURN: topicUrn)
        return latestMediasForTopic(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func latestMediasForTopic(at page: LatestMediasForTopic.Page) -> AnyPublisher<LatestMediasForTopic.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum MostPopularMediasForTopic {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Most popular videos for a specific topic.
     *
     *  - Parameter topicURN: The unique topic URN.
     */
    func mostPopularMediasForTopic(withUrn topicUrn: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<MostPopularMediasForTopic.Output, Error> {
        let request = requestMostPopularMediasForTopic(withURN: topicUrn)
        return mostPopularMediasForTopic(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func mostPopularMediasForTopic(at page: MostPopularMediasForTopic.Page) -> AnyPublisher<MostPopularMediasForTopic.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum MediaComposition {
        public typealias Output = (mediaComposition: SRGMediaComposition, response: URLResponse)
    }
    
    /**
     *  Full media information needed to play a media.
     *
     *  - Parameter standalone: If set to `NO`, the returned media composition provides media playback information in
     *    context. If set to `YES`, media playback is provided without context.
     */
    func mediaComposition(forUrn urn: String, standalone: Bool = false) -> AnyPublisher<MediaComposition.Output, Error> {
        let request = requestMediaComposition(forURN: urn, standalone: standalone)
        return objectTaskPublisher(for: request, type: SRGMediaComposition.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum Show {
        public typealias Output = (show: SRGShow, response: URLResponse)
    }
    
    /**
     *  Retrieve the show having the specified URN.
     */
    func show(withUrn urn: String) -> AnyPublisher<Show.Output, Error> {
        let request = requestShow(withURN: urn)
        return objectTaskPublisher(for: request, type: SRGShow.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum Shows {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (shows: [SRGShow], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Retrieve shows matching a URN list.
     *
     *  Partial results can be returned if some URNs are invalid. Note that you can mix TV or radio show URNs, or URNs
     *  from different business units.
     */
    func shows(withUrns urns: [String], pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<Shows.Output, Error> {
        let request = requestShows(withURNs: urns)
        return shows(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func shows(at page: Shows.Page) -> AnyPublisher<Shows.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "showList", type: SRGShow.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum LatestEpisodesForShow {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (episodeComposition: SRGEpisodeComposition, page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Latest episodes for a specific show.
     *
     *  - Parameter maximumPublicationDay: If not `nil`, medias up to the specified day are returned.
     *
     *  Though the completion block does not return an array directly, this request supports pagination (for episodes
     *  returned in the episode composition object).
     */
    func latestEpisodesForShow(withUrn showUrn: String, maximumPublicationDay: SRGDay? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<LatestEpisodesForShow.Output, Error> {
        let request = requestLatestEpisodesForShow(withURN: showUrn, maximumPublicationDay: maximumPublicationDay)
        return latestEpisodesForShow(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func latestEpisodesForShow(at page: LatestEpisodesForShow.Page) -> AnyPublisher<LatestEpisodesForShow.Output, Error> {
        return paginatedObjectTaskPublisher(for: page.request, type: SRGEpisodeComposition.self)
            .map { result in
                (result.object, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum LatestMediasForModule {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  List medias for a specific module.
     */
    func latestMediasForModule(withUrn moduleUrn: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<LatestMediasForModule.Output, Error> {
        let request = requestLatestMediasForModule(withURN: moduleUrn)
        return latestMediasForModule(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func latestMediasForModule(at page: LatestMediasForModule.Page) -> AnyPublisher<LatestMediasForModule.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaLst", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: Generic implementation

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    // Use generics to generate a different type for each request (otherwise pages could be generated by a request
    // and used by another one with unreliable results if the type of object does not match).
    public struct Page<T> {
        let request: URLRequest
        public let size: UInt
        public let number: UInt
        
        fileprivate init(request: URLRequest, size: UInt) {
            self.init(request: request, size: size, number: 0)
        }
        
        private init(request: URLRequest, size: UInt, number: UInt) {
            self.request = request
            self.size = size
            self.number = number
        }
        
        fileprivate func next(with request: URLRequest?) -> Page<T>? {
            if let request = request {
                return Page(request: request, size: size, number: number + 1)
            }
            else {
                return nil
            }
        }
    }
    
    typealias ObjectOutput<T> = (object: T, response: URLResponse)
    typealias ObjectsOutput<T> = (objects: [T], response: URLResponse)
    
    typealias PaginatedObjectOutput<T> = (object: T, total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?, nextRequest: URLRequest?, response: URLResponse)
    typealias PaginatedObjectsOutput<T> = (objects: [T], total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?, nextRequest: URLRequest?, response: URLResponse)
    
    func paginatedDictionaryTaskPublisher(for request: URLRequest) -> AnyPublisher<PaginatedObjectOutput<[String: Any]>, Error> {
        func extractNextUrl(from dictionary: [String: Any]) -> URL? {
            if let nextUrlString = dictionary["next"] as? String {
                return URL(string: nextUrlString)
            }
            else {
                return nil
            }
        }
        
        func extractTotal(from dictionary: [String: Any]) -> UInt {
            return dictionary["total"] as? UInt ?? 0
        }
        
        func extractAggregations(from dictionary: [String: Any]) -> SRGMediaAggregations? {
            guard let aggregationsJsonDictionary = dictionary["aggregations"] as? [String: Any] else { return nil }
            return try? MTLJSONAdapter.model(of: SRGMediaAggregations.self, fromJSONDictionary: aggregationsJsonDictionary) as? SRGMediaAggregations
        }
        
        func extractSuggestions(from dictionary: [String: Any]) -> [SRGSearchSuggestion]? {
            guard let suggestionsJsonArray = dictionary["suggestionList"] as? [Any] else { return nil }
            return try? MTLJSONAdapter.models(of: SRGSearchSuggestion.self, fromJSONArray: suggestionsJsonArray) as? [SRGSearchSuggestion]
        }
        
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .map { result in
                let nextRequest = self.urlRequest(from: request, withUrl: extractNextUrl(from: result.data))
                return (result.data, extractTotal(from: result.data), extractAggregations(from: result.data), extractSuggestions(from: result.data), nextRequest, result.response)
            }
            .eraseToAnyPublisher()
    }
    
    func paginatedObjectsTaskPublisher<T>(for request: URLRequest, rootKey: String, type: T.Type) -> AnyPublisher<PaginatedObjectsOutput<T>, Error> where T: MTLModel {
        return paginatedDictionaryTaskPublisher(for: request)
            .tryMap { result in
                // Remark: When the result count is equal to a multiple of the page size, the last link returns an empty list array
                //         (or no such entry at all for the episode composition request)
                // See https://confluence.srg.beecollaboration.com/display/SRGPLAY/Developer+Meeting+2016-10-05
                guard let array = result.object[rootKey] as? [Any] else {
                    return ([], result.total, result.aggregations, result.suggestions, nil, result.response)
                }
                
                if let objects = try? MTLJSONAdapter.models(of: T.self, fromJSONArray: array) as? [T] {
                    return (objects, result.total, result.aggregations, result.suggestions, result.nextRequest, result.response)
                }
                else {
                    throw SRGDataProviderError.invalidData
                }
            }
            .eraseToAnyPublisher()
    }
    
    func paginatedObjectTaskPublisher<T>(for request: URLRequest, type: T.Type) -> AnyPublisher<PaginatedObjectOutput<T>, Error> where T: MTLModel {
        return paginatedDictionaryTaskPublisher(for: request)
            .tryMap { result in
                if let object = try? MTLJSONAdapter.model(of: T.self, fromJSONDictionary: result.object) as? T {
                    return (object, result.total, result.aggregations, result.suggestions, result.nextRequest, result.response)
                }
                else {
                    throw SRGDataProviderError.invalidData
                }
            }
            .eraseToAnyPublisher()
    }
    
    func objectsTaskPublisher<T>(for request: URLRequest, rootKey: String, type: T.Type) -> AnyPublisher<ObjectsOutput<T>, Error> where T: MTLModel {
        return paginatedObjectsTaskPublisher(for: request, rootKey: rootKey, type: T.self)
            .map { result in
                return (result.objects, result.response)
            }
            .eraseToAnyPublisher()
    }
    
    func objectTaskPublisher<T>(for request: URLRequest, type: T.Type) -> AnyPublisher<ObjectOutput<T>, Error> where T: MTLModel {
        return paginatedObjectTaskPublisher(for: request, type: T.self)
            .map { result in
                return (result.object, result.response)
            }
            .eraseToAnyPublisher()
    }
    
    func urlRequest(from request: URLRequest, withUrl url: URL?) -> URLRequest {
        guard let url = url else { return request }
        var updatedRequest = request
        updatedRequest.url = url;
        return updatedRequest
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    typealias Ouput<T> = (data: T, response: URLResponse)
    
    func manageNetworkActivity() -> Publishers.HandleEvents<Self> where Self == URLSession.DataTaskPublisher {
        return handleEvents { _ in
            SRGNetworkActivityManagement.increaseNumberOfRunningRequests()
        } receiveCompletion: { _ in
            SRGNetworkActivityManagement.decreaseNumberOfRunningRequests()
        } receiveCancel: {
            SRGNetworkActivityManagement.decreaseNumberOfRunningRequests()
        }
    }
    
    func reportHttpErrors() -> Publishers.TryMap<Self, Output> where Output == URLSession.DataTaskPublisher.Output {
        return tryMap { result in
            if let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                throw SRGDataProviderError.http(statusCode: httpResponse.statusCode)
            }
            return result
        }
    }
    
    func tryMapJson<T>(_ type: T.Type) -> Publishers.TryMap<Self, Ouput<T>> where Output == URLSession.DataTaskPublisher.Output {
        return tryMap { result in
            if let object = try JSONSerialization.jsonObject(with: result.data, options: []) as? T {
                return (object, result.response)
            }
            else {
                throw SRGDataProviderError.invalidData
            }
        }
    }
}
