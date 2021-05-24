//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

@_implementationOnly import SRGDataProviderRequests

/**
 *  List of URN-based services supported by the data provider. Such services do not need explicit knowledge of what
 *  is requested (audio / video, for example) or of the business unit. They provide a way to retrieve content
 *  from any business unit. Some restrictions may apply, though, please refer to the documentation of each request
 *  for more information.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Retrieve the media having the specified URN.
     *
     *  @discussion If you need to retrieve several medias, use `medias(withUrns:)` instead.
     */
    func media(withUrn urn: String) -> AnyPublisher<SRGMedia, Error> {
        let request = requestMedia(withURN: urn)
        return objectPublisher(for: request, type: SRGMedia.self)
    }
    
    /**
     *  Retrieve medias matching a URN list.
     *
     *  Partial results can be returned if some URNs are invalid. Note that you can mix audio and video URNs, or URNs
     *  from different business units.
     */
    func medias(withUrns urns: [String], pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestMedias(withURNs: urns)
        return paginatedObjectsTriggeredPublisher(at: URNPage(originalRequest: request, queryParameter: "urns", size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: triggerable)
    }
    
    /**
     *  Latest medias for a specific topic.
     *
     *  - Parameter topicURN: The unique topic URN.
     */
    func latestMediasForTopic(withUrn topicUrn: String, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestLatestMediasForTopic(withURN: topicUrn)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: triggerable)
    }
    
    /**
     *  Most popular videos for a specific topic.
     *
     *  - Parameter topicURN: The unique topic URN.
     */
    func mostPopularMediasForTopic(withUrn topicUrn: String, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestMostPopularMediasForTopic(withURN: topicUrn)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: triggerable)
    }
    
    /**
     *  Full media information needed to play a media.
     *
     *  - Parameter standalone: If set to `NO`, the returned media composition provides media playback information in
     *    context. If set to `YES`, media playback is provided without context.
     */
    func mediaComposition(forUrn urn: String, standalone: Bool = false) -> AnyPublisher<SRGMediaComposition, Error> {
        let request = requestMediaComposition(forURN: urn, standalone: standalone)
        return objectPublisher(for: request, type: SRGMediaComposition.self)
    }
    
    /**
     *  Retrieve the show having the specified URN.
     */
    func show(withUrn urn: String) -> AnyPublisher<SRGShow, Error> {
        let request = requestShow(withURN: urn)
        return objectPublisher(for: request, type: SRGShow.self)
    }
    
    /**
     *  Retrieve shows matching a URN list.
     *
     *  Partial results can be returned if some URNs are invalid. Note that you can mix TV or radio show URNs, or URNs
     *  from different business units.
     */
    func shows(withUrns urns: [String], pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<[SRGShow], Error> {
        let request = requestShows(withURNs: urns)
        return paginatedObjectsTriggeredPublisher(at: URNPage(originalRequest: request, queryParameter: "urns", size: pageSize), rootKey: "showList", type: SRGShow.self, paginatedBy: triggerable)
    }
    
    enum LatestEpisodesForShow {
        public typealias Output = (channel: SRGChannel?, show: SRGShow, episodes: [SRGEpisode])
    }
    
    /**
     *  Latest episodes for a specific show.
     *
     *  - Parameter maximumPublicationDay: If not `nil`, medias up to the specified day are returned.
     *
     *  - Remark: Though the completion block does not return an array directly, this request supports pagination (for episodes
     *            returned in the episode composition object).
     */
    func latestEpisodesForShow(withUrn showUrn: String, maximumPublicationDay: SRGDay? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<LatestEpisodesForShow.Output, Error> {
        let request = requestLatestEpisodesForShow(withURN: showUrn, maximumPublicationDay: maximumPublicationDay)
        return paginatedObjectTriggeredPublisher(at: Page(request: request, size: pageSize), type: SRGEpisodeComposition.self, paginatedBy: triggerable)
            .map { ($0.channel, $0.show, $0.episodes ?? []) }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Latest medias for a specific show.
     */
    func latestMediasForShow(withUrn showUrn: String, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestLatestMediasForShow(withURN: showUrn)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: triggerable)
    }
    
    /**
     *  Latest medias for a show list.
     *
     *  - Parameter filter: The filter which must be applied to results.
     *  - Parameter maximumPublicationDay: If not `nil`, medias up to the specified day are returned.
     */
    func latestMediasForShows(withUrns urns: [String], filter: SRGMediaFilter = .none, maximumPublicationDay: SRGDay? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestLatestMediasForShows(withURNs: urns, filter: filter, maximumPublicationDay: maximumPublicationDay)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: triggerable)
    }
    
    /**
     *  List medias for a specific module.
     */
    func latestMediasForModule(withUrn moduleUrn: String, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestLatestMediasForModule(withURN: moduleUrn)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: triggerable)
    }
}

#endif
