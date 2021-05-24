//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

@_implementationOnly import SRGDataProviderRequests

/**
 *  Search-oriented services.
 */

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum MediasMatchingQuery {
        public typealias Output = (mediaUrns: [String], total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?)
    }
    
    /**
     *  Search medias matching a specific query, returning the matching URN list.
     *
     *  To get complete media objects, call the `medias(withUrns:)` request with the returned URN list. Refer to the
     *  Service availability matrix for information about which vendors support settings. By default aggregations are
     *  returned, which can lead to longer response times. If you do not need aggregations, provide a settings object
     *  to disable them.
     */
    func medias(for vendor: SRGVendor, matchingQuery query: String?, with settings: SRGMediaSearchSettings? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<MediasMatchingQuery.Output, Error> {
        let request = requestMedias(for: vendor, matchingQuery: query, with: settings)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "searchResultMediaList", type: SRGSearchResult.self, paginatedBy: triggerable)
            .map { result in
                (result.objects.map(\.urn), result.total, result.aggregations, result.suggestions)
            }
            .eraseToAnyPublisher()
    }
    
    enum ShowsMatchingQuery {
        public typealias Output = (showUrns: [String], total: UInt)
    }
    
    /**
     *  Search shows matching a specific query, returning the matching URN list.
     *
     *  If the media type is set to a value different from `.none`, filter shows for which content of the specified type is
     *  available. To get complete show objects, call the `shows(withUrns:)` request with the returned URN list.
     */
    func shows(for vendor: SRGVendor, matchingQuery query: String, mediaType: SRGMediaType = .none, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<ShowsMatchingQuery.Output, Error> {
        let request = requestShows(for: vendor, matchingQuery: query, mediaType: mediaType)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "searchResultShowList", type: SRGSearchResult.self, paginatedBy: triggerable)
            .map { result in
                (result.objects.map(\.urn), result.total)
            }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Search shows matching a specific query, returning the matching URN list.
     *
     *  If the transmission is set to a value different from `.none`, filter shows for the specified transmission. To get
     *  complete show objects, call the `shows(withUrns:)` request with the returned URN list.
     */
    func shows(for vendor: SRGVendor, matchingQuery query: String, transmission: SRGTransmission = .none, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<ShowsMatchingQuery.Output, Error> {
        let request = requestShows(for: vendor, matchingQuery: query, transmission: transmission)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "searchResultShowList", type: SRGSearchResult.self, paginatedBy: triggerable)
            .map { result in
                (result.objects.map(\.urn), result.total)
            }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Retrieve the list of shows which are searched the most.
     *
     *  If set to a value different from `SRGTransmissionNone`, filter most searched shows for the specified transmission.
     */
    func mostSearchedShows(for vendor: SRGVendor, matching transmission: SRGTransmission = .none) -> AnyPublisher<[SRGShow], Error> {
        let request = requestMostSearchedShows(for: vendor, matching: transmission)
        return objectsPublisher(for: request, rootKey: "showList", type: SRGShow.self)
    }
    
    /**
     *  List medias with specific tags.
     *
     *  - Parameter tags: List of tags (at least one is required).
     *  - Parameter excludedTags: An optional list of excluded tags.
     *  - Parameter fullLengthExcluded: Set to `YES` to exclude full length videos.
     */
    func videos(for vendor: SRGVendor, withTags tags: [String], excludedTags: [String]? = nil, fullLengthExcluded: Bool = false, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestVideos(for: vendor, withTags: tags, excludedTags: excludedTags, fullLengthExcluded: fullLengthExcluded)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: triggerable)
    }
}

#endif
