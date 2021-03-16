//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  Content services supported by the data provider. These services return content configured by editors through
 *  the Play Application Configurator tool (PAC).
 */

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum ContentPage {
        public typealias Output = (contentPage: SRGContentPage, response: URLResponse)
    }
    
    /**
     *  Retrieve a page of content given by its unique identifier.
     *
     *  @param published Set this parameter to `YES` to look only for published pages.
     *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or a
     *                   specific date.
     */
    func contentPage(for vendor: SRGVendor, pageUid: String, published: Bool = true, at date: Date? = nil) -> AnyPublisher<ContentPage.Output, Error> {
        let request = requestContentPage(for: vendor, pageUid: pageUid, published: published, at: date)
        return objectTaskPublisher(for: request, type: SRGContentPage.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Retrieve the default content page for medias of the specified type.
     *
     *  @param published Set this parameter to `YES` to look only for published pages.
     *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or a
     *                   specific date.
     */
    func contentPage(for vendor: SRGVendor, mediaType: SRGMediaType, published: Bool = true, at date: Date? = nil) -> AnyPublisher<ContentPage.Output, Error> {
        let request = requestContentPage(for: vendor, mediaType: mediaType, published: published, at: date)
        return objectTaskPublisher(for: request, type: SRGContentPage.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Retrieve a page of content for a specific topic.
     *
     *  @param published Set this parameter to `YES` to look only for published pages.
     *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or a
     *                   specific date.
     */
    func contentPage(for vendor: SRGVendor, topicWithUrn topicUrn: String, published: Bool = true, at date: Date? = nil) -> AnyPublisher<ContentPage.Output, Error> {
        let request = requestContentPage(for: vendor, topicWithURN: topicUrn, published: published, at: date)
        return objectTaskPublisher(for: request, type: SRGContentPage.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

#endif
