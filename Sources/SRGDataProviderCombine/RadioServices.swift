//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  Services for radio channels and livestreams.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  List of radio channels.
     */
    func radioChannels(for vendor: SRGVendor) -> AnyPublisher<[SRGChannel], Error> {
        let request = requestRadioChannels(for: vendor)
        return objectsPublisher(for: request, rootKey: "channelList", type: SRGChannel.self)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Specific radio channel. Use this request to obtain complete channel information, including current and next
     *  programs.
     *
     *  - Parameter livestreamUid: An optional media unique identifier (usually regional, but might be the main one).
     *                             If provided, the program of the specified live stream is used, otherwise the one of
     *                             the main channel.
     */
    func radioChannel(for vendor: SRGVendor, withUid channelUid: String, livestreamUid: String? = nil) -> AnyPublisher<SRGChannel, Error> {
        let request = requestRadioChannel(for: vendor, withUid: channelUid, livestreamUid: livestreamUid)
        return objectPublisher(for: request, type: SRGChannel.self)
            .map { $0.object }
            .eraseToAnyPublisher()
    }
    
    enum RadioLatestPrograms {
        public typealias Output = (channel: SRGChannel, programs: [SRGProgram])
    }
    
    /**
     *  Latest programs for a specific radio channel, including current and next programs. An optional date range
     *  (possibly half-open) can be specified to only return programs entirely contained in a given interval. If no
     *  end date is provided, only programs up to the current date are returned.
     *
     *  - Parameter livestreamUid: An optional media unique identifier (usually the main one). If provided, the program
     *                             of the specified livestream is used, otherwise the one of the main channel.
     *
     *  - Remark: Though the completion block does not return an array directly, this request supports pagination (for
     *            programs returned in the program composition object).
     */
    func radioLatestPrograms(for vendor: SRGVendor, channelUid: String, livestreamUid: String? = nil, from: Date? = nil, to: Date? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize, trigger: Trigger = .inactive) -> AnyPublisher<RadioLatestPrograms.Output, Error> {
        let request = requestRadioLatestPrograms(for: vendor, channelUid: channelUid, livestreamUid: livestreamUid, from:from, to: to)
        return paginatedObjectTriggeredPublisher(at: Page(request: request, size: pageSize), type: SRGProgramComposition.self, trigger: trigger) { object, programComposition in
            let channel = object?.channel ?? programComposition.channel
            let programs = (object?.programs ?? []) + (programComposition.programs ?? [])
            return (channel, programs)
        }
        .map { $0.object }
        .eraseToAnyPublisher()
    }
    
    /**
     *  List of radio livestreams for a channel.
     *
     *  - Parameter channelUid: The channel uid for which audio livestreams (main and regional) must be retrieved.
     */
    func radioLivestreams(for vendor: SRGVendor, channelUid: String) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestRadioLivestreams(for: vendor, channelUid: channelUid)
        return objectsPublisher(for: request, rootKey: "mediaList", type: SRGMedia.self)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
    
    /**
     *  List of radio livestreams.
     *
     *  - Parameter contentProviders: The content providers to return radio livestreams for.
     */
    func radioLivestreams(for vendor: SRGVendor, contentProviders: SRGContentProviders) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestRadioLivestreams(for: vendor, contentProviders: contentProviders)
        return objectsPublisher(for: request, rootKey: "mediaList", type: SRGMedia.self)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
}

/**
 *  Services for radio medias and episodes.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Latest medias for a specific channel.
     */
    func radioLatestMedias(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize, trigger: Trigger = .inactive) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestRadioLatestMedias(for: vendor, channelUid: channelUid)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, trigger: trigger)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Most popular medias for a specific channel.
     */
    func radioMostPopularMedias(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize, trigger: Trigger = .inactive) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestRadioMostPopularMedias(for: vendor, channelUid: channelUid)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, trigger: trigger)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Latest episodes for a specific channel.
     */
    func radioLatestEpisodes(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize, trigger: Trigger = .inactive) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestRadioLatestEpisodes(for: vendor, channelUid: channelUid)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, trigger: trigger)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Episodes available for a given day, for the specific channel.
     *
     *  - Parameter day: The day. If `nil`, today is used.
     */
    func radioEpisodes(for vendor: SRGVendor, channelUid: String, day: SRGDay? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize, trigger: Trigger = .inactive) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestRadioEpisodes(for: vendor, channelUid: channelUid, day: day)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, trigger: trigger)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Latest video medias for a specific channel.
     */
    func radioLatestVideos(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize, trigger: Trigger = .inactive) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestRadioLatestVideos(for: vendor, channelUid: channelUid)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, trigger: trigger)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
}

/**
 *  Services for radio topics.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Topics.
     */
    func radioTopics(for vendor: SRGVendor) -> AnyPublisher<[SRGTopic], Error> {
        let request = requestRadioTopics(for: vendor)
        return objectsPublisher(for: request, rootKey: "topicList", type: SRGTopic.self)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
}

/**
 *  Services for radio shows.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Shows by channel.
     */
    func radioShows(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize, trigger: Trigger = .inactive) -> AnyPublisher<[SRGShow], Error> {
        let request = requestRadioShows(for: vendor, channelUid: channelUid)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "showList", type: SRGShow.self, trigger: trigger)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
    
    enum RadioShowsMatchingQuery {
        public typealias Output = (showUrns: [String], total: UInt)
    }
    
    /**
     *  Search shows matching a specific query, returning the matching URN list.
     *
     *  Some business units only support full-text search, not partial matching. To get complete show objects, call the
     *  `shows(withUrns:)` request with the returned URN list.
     */
    func radioShows(for vendor: SRGVendor, matchingQuery query: String, pageSize: UInt = SRGDataProviderDefaultPageSize, trigger: Trigger = .inactive) -> AnyPublisher<RadioShowsMatchingQuery.Output, Error> {
        let request = requestRadioShows(for: vendor, matchingQuery: query)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "searchResultShowList", type: SRGSearchResult.self, trigger: trigger)
            .map { result in
                return (result.objects.map(\.urn), result.total)
            }
            .eraseToAnyPublisher()
    }
}

/**
 *  Services for radio songs.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Song list by channel.
     */
    func radioSongs(for vendor: SRGVendor, channelUid: String, pageSize: UInt = SRGDataProviderDefaultPageSize, trigger: Trigger = .inactive) -> AnyPublisher<[SRGSong], Error> {
        let request = requestRadioSongs(for: vendor, channelUid: channelUid)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "songList", type: SRGSong.self, trigger: trigger)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Current song by channel.
     */
    func radioCurrentSong(for vendor: SRGVendor, channelUid: String) -> AnyPublisher<SRGSong, Error> {
        let request = requestRadioCurrentSong(for: vendor, channelUid: channelUid)
        return objectPublisher(for: request, type: SRGSong.self)
            .map { $0.object }
            .eraseToAnyPublisher()
    }
}

#endif
