//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine

/**
 *  List of TV-oriented services supported by the data provider. Radio channels have separate identities and programs,
 *  this is why retrieving media lists requires the unique identifier of a channel to be specified.
 */

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
                (result.objects.map(\.urn), result.total, page, page.next(with: result.nextRequest), result.response)
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
