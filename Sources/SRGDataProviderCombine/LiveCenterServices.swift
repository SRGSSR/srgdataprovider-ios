//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

@_implementationOnly import SRGDataProviderRequests

/**
 *  Services offered by the SwissTXT Live Center.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  List of videos available from the Live Center.
     */
    func liveCenterVideos(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize, paginatedBy triggerable: Triggerable? = nil) -> AnyPublisher<[SRGMedia], Error> {
        let request = requestLiveCenterVideos(for: vendor)
        return paginatedObjectsTriggeredPublisher(at: Page(request: request, size: pageSize), rootKey: "mediaList", type: SRGMedia.self, paginatedBy: triggerable)
    }
}

#endif
