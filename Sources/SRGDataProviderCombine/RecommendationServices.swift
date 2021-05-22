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
    /**
     *  List recommended medias for a specific media URN and, optionally, a user id.
     *
     *  - Parameter URN: A specific media URN.
     *  - Parameter userId: An optional user identifier.
     */
    func recommendedMedias(forUrn urn: String, userId: String?, pageSize: UInt = SRGDataProviderDefaultPageSize, triggeredBy triggerable: Triggerable? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestRecommendedMedias(forURN: urn, userId: userId)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, triggeredBy: triggerable)
    }
}

#endif
