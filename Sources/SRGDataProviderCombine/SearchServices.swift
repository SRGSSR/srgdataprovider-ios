//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine

/**
 *  List of search-oriented services supported by the data provider.
 */

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
                (result.objects.map(\.urn), result.total, result.aggregations, result.suggestions, page, page.next(with: result.nextRequest), result.response)
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
                (result.objects.map(\.urn), result.total, page, page.next(with: result.nextRequest), result.response)
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
     *
     *  - Parameter transmission: only `SRGTransmissionNone`,  `SRGTransmissionTV` and
     *                            `SRGTransmissionRadio` are known requests.
     */
    func mostSearchedShows(for vendor: SRGVendor, transmission: SRGTransmission) -> AnyPublisher<MostSearchedShows.Output, Error> {
        let request = requestMostSearchedShows(for: vendor, transmission: transmission)
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
