//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  List of media recommendation services supported by the data provider.
 */

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

#endif
