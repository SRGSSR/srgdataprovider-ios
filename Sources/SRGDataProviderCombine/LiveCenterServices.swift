//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  List of services offered by the SwissTXT Live Center.
 */

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

#endif
