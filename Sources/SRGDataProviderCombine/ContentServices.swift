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
    func contentPage(for vendor: SRGVendor, uid: String, published: Bool = true, at date: Date? = nil) -> AnyPublisher<ContentPage.Output, Error> {
        let request = requestContentPage(for: vendor, uid: uid, published: published, at: date)
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

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum ContentSection {
        public typealias Output = (contentSection: SRGContentSection, response: URLResponse)
    }
    
    /**
     *  Retrieve a section of content given by its unique identifier.
     *
     *  @param published Set this parameter to `YES` to look only for published sections.
     */
    func contentSection(for vendor: SRGVendor, uid: String, published: Bool = true) -> AnyPublisher<ContentSection.Output, Error> {
        let request = requestContentSection(for: vendor, uid: uid, published: published)
        return objectTaskPublisher(for: request, type: SRGContentSection.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum MediasForContentSection {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Retrieve medias associated with a content section.
     *
     *  @param userId    An optional user identifier.
     *  @param published Set this parameter to `YES` to look only for published pages.
     *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or a
     *                   specific date.
     *
     *  @discussion The section itself must be of type `SRGContentSectionTypeMedias`.
     */
    func medias(for vendor: SRGVendor, contentSectionUid: String, userId: String? = nil, published: Bool = true, at date: Date? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<MediasForContentSection.Output, Error> {
        let request = requestMedias(for: vendor, contentSectionUid: contentSectionUid, userId: userId, published: published, at: date)
        return medias(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func medias(at page: MediasForContentSection.Page) -> AnyPublisher<MediasForContentSection.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList", type: SRGMedia.self)
            .map { result in
                return (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum ShowsForContentSection {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (shows: [SRGShow], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Retrieve shows associated with a content section.
     *
     *  @param userId    An optional user identifier.
     *  @param published Set this parameter to `YES` to look only for published pages.
     *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or a
     *                   specific date.
     *
     *  @discussion The section itself must be of type `SRGContentSectionTypeShows`.
     */
    func shows(for vendor: SRGVendor, contentSectionUid: String, userId: String? = nil, published: Bool = true, at date: Date? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<ShowsForContentSection.Output, Error> {
        let request = requestShows(for: vendor, contentSectionUid: contentSectionUid, userId: userId, published: published, at: date)
        return shows(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func shows(at page: ShowsForContentSection.Page) -> AnyPublisher<ShowsForContentSection.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "showList", type: SRGShow.self)
            .map { result in
                return (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum ShowHighlightForContentSection {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (showHighlight: SRGShowHighlight, page: Page, nextPage: Page?, response: URLResponse)
    }
    
    /**
     *  Retrieve the show highlight associated with a content section (show and paginated media list).
     *
     *  @param userId    An optional user identifier.
     *  @param published Set this parameter to `YES` to look only for published pages.
     *  @param date      The page content might change over time. Use `nil` to retrieve the page as it looks now, or a
     *                   specific date.
     *
     *  @discussion The section itself must be of type `SRGContentSectionTypeShowHighlight`.
     */
    func showHighlight(for vendor: SRGVendor, contentSectionUid: String, userId: String? = nil, published: Bool = true, at date: Date? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<ShowHighlightForContentSection.Output, Error> {
        let request = requestShowHighlight(for: vendor, contentSectionUid: contentSectionUid, userId: userId, published: published, at: date)
        return showHighlight(at: Page(request: request, size: pageSize))
    }
    
    /**
     *  Next page of results.
     */
    func showHighlight(at page: ShowHighlightForContentSection.Page) -> AnyPublisher<ShowHighlightForContentSection.Output, Error> {
        return paginatedObjectTaskPublisher(for: page.request, type: SRGShowHighlight.self)
            .map { result in
                (result.object, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

#endif
