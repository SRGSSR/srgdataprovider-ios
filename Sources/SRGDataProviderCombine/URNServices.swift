//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine

/**
 *  List of URN-based services supported by the data provider. Such services do not need explicit knowledge of what
 *  is requested (audio / video, for example) or of the business unit. They provide a way to retrieve content
 *  from any business unit. Some restrictions may apply, though, please refer to the documentation of each request
 *  for more information.
 */

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
        public typealias Page = SRGDataProvider.URNPage<Self>
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
        return medias(at: URNPage(originalRequest: request, queryParameter: "urns", size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func medias(at page: Medias.Page) -> AnyPublisher<Medias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(), result.response)
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
        public typealias Page = SRGDataProvider.URNPage<Self>
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
        return shows(at: URNPage(originalRequest: request, queryParameter: "urns", size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func shows(at page: Shows.Page) -> AnyPublisher<Shows.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "showList", type: SRGShow.self)
            .map { result in
                (result.objects, page, page.next(), result.response)
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
    enum LatestMediasForShows {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func latestMediasForShows(withUrns urns: [String], filter: SRGEpisodeFilter = .none, maximumPublicationDay: SRGDay? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<LatestMediasForShows.Output, Error> {
        let request = requestLatestMediasForShows(withURNs: urns, filter: filter, maximumPublicationDay: maximumPublicationDay)
        return latestMediasForShows(at: Page(request: request, size: pageSize))
    }
    
    func latestMediasForShows(at page: LatestMediasForShows.Page) -> AnyPublisher<LatestMediasForShows.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
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
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}
