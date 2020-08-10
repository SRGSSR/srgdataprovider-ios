//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine
import Mantle
import SRGDataProvider
import SRGNetwork

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum SRGDataProviderError: Error {
    case http(statusCode: Int)
    case invalidData
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVChannels {
        public typealias Output = (channels: [SRGChannel], response: URLResponse)
    }
    
    func tvChannels(for vendor: SRGVendor) -> AnyPublisher<TVChannels.Output, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/channelList/tv")
        return objectsTaskPublisher(for: request, rootKey: "channelList").map { $0 }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVChannel {
        public typealias Output = (channel: SRGChannel, response: URLResponse)
    }
    
    func tvChannel(for vendor: SRGVendor, withUid channelUid: String) -> AnyPublisher<TVChannel.Output, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/channel/\(channelUid)/tv/nowAndNext")
        return objectTaskPublisher(for: request).map { $0 }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVLatestMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func tvLatestMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVLatestMedias.Output, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/mediaList/video/latestEpisodes")
        return tvLatestMedias(at: Page(request: request, size: pageSize))
    }
    
    func tvLatestMedias(at page: TVLatestMedias.Page) -> AnyPublisher<TVLatestMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList").map { result in
            (result.objects, page, page.next(with: result.nextRequest), result.response)
        }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVTrendingMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func tvTrendingMedias(for vendor: SRGVendor, limit: Int? = nil, editorialLimit: Int? = nil, episodesOnly: Bool = false, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVTrendingMedias.Output, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/mediaList/video/trending")
        return tvTrendingMedias(at: Page(request: request, size: pageSize))
    }
    
    func tvTrendingMedias(at page: TVTrendingMedias.Page) -> AnyPublisher<TVTrendingMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList").map { result in
            (result.objects, page, page.next(with: result.nextRequest), result.response)
        }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVTopics {
        public typealias Output = (topics: [SRGTopic], response: URLResponse)
    }
    
    func tvTopics(for vendor: SRGVendor) -> AnyPublisher<TVTopics.Output, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/topicList/tv")
        return objectsTaskPublisher(for: request, rootKey: "topicList").map { $0 }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum LatestMediasForTopic {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func latestMediasForTopic(withUrn topicUrn: String, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<LatestMediasForTopic.Output, Error> {
        let request = urlRequest(for: "2.0/mediaList/latest/byTopicUrn/\(topicUrn)")
        return latestMediasForTopic(at: Page(request: request, size: pageSize))
    }
    
    func latestMediasForTopic(at page: LatestMediasForTopic.Page) -> AnyPublisher<LatestMediasForTopic.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList").map { result in
            (result.objects, page, page.next(with: result.nextRequest), result.response)
        }.eraseToAnyPublisher()
    }
}

// TODO: Take into account page size
// TODO: Unlimited page size supprt
// TODO: Media search request

// MARK: Generic implementation

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    // Use generics to generate a different type for each request (otherwise pages could be generated by a request
    // and used by another one with unreliable results if the type of object does not match).
    public struct Page<T> {
        let request: URLRequest
        public let size: UInt
        public let number: UInt
        
        fileprivate init(request: URLRequest, size: UInt) {
            self.init(request: request, size: size, number: 0)
        }
        
        private init(request: URLRequest, size: UInt, number: UInt) {
            self.request = request
            self.size = size
            self.number = number
        }
        
        fileprivate func next(with request: URLRequest?) -> Page<T>? {
            if let request = request {
                return Page(request: request, size: size, number: number + 1)
            }
            else {
                return nil
            }
        }
    }
    
    typealias ObjectOutput<T> = (object: T, response: URLResponse)
    typealias ObjectsOutput<T> = (objects: [T], response: URLResponse)
    typealias PaginatedObjectsOutput<T> = (objects: [T], nextRequest: URLRequest?, response: URLResponse)
    
    func paginatedObjectsTaskPublisher<T>(for request: URLRequest, rootKey: String) -> AnyPublisher<PaginatedObjectsOutput<T>, Error> {
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .extractNextPage { data in
                guard let urlString = data["next"] as? String else { return nil }
                return URL(string: urlString)
            }
            .tryMap { result in
                guard let array = result.data[rootKey] as? [Any] else {
                    throw SRGDataProviderError.invalidData
                }
                
                if let objects = try MTLJSONAdapter.models(of: T.self as? AnyClass, fromJSONArray: array) as? [T] {
                    let nextRequest = self.urlRequest(from: request, withUrl: result.nextUrl)
                    return (objects, nextRequest, result.response)
                }
                else {
                    return ([], nil, result.response)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func objectsTaskPublisher<T>(for request: URLRequest, rootKey: String) -> AnyPublisher<ObjectsOutput<T>, Error> {
        return paginatedObjectsTaskPublisher(for: request, rootKey: rootKey)
            .map { result in
                return (result.objects, result.response)
            }
            .eraseToAnyPublisher()
    }
    
    func objectTaskPublisher<T>(for request: URLRequest) -> AnyPublisher<ObjectOutput<T>, Error> {
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .tryMap { result in
                if let object = try MTLJSONAdapter.model(of: T.self as? AnyClass, fromJSONDictionary: result.data) as? T {
                    return (object, result.response)
                }
                else {
                    throw SRGDataProviderError.invalidData
                }
            }
            .eraseToAnyPublisher()
    }
    
    func urlRequest(for resourcePath: String) -> URLRequest {
        let url = serviceURL.appendingPathComponent(resourcePath)
        return URLRequest(url: url)
    }
    
    func urlRequest(from request: URLRequest, withUrl url: URL?) -> URLRequest {
        guard let url = url else { return request }
        var updatedRequest = request
        updatedRequest.url = url;
        return updatedRequest
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    typealias SimpleOuput<T> = (data: T, response: URLResponse)
    typealias PageOuput<T> = (data: T, nextUrl: URL?, response: URLResponse)
    
    func manageNetworkActivity() -> Publishers.HandleEvents<Self> where Self == URLSession.DataTaskPublisher {
        return handleEvents { _ in
            SRGNetworkActivityManagement.increaseNumberOfRunningRequests()
        } receiveCompletion: { _ in
            SRGNetworkActivityManagement.decreaseNumberOfRunningRequests()
        } receiveCancel: {
            SRGNetworkActivityManagement.decreaseNumberOfRunningRequests()
        }
    }
    
    func reportHttpErrors() -> Publishers.TryMap<Self, Output> where Output == URLSession.DataTaskPublisher.Output {
        return tryMap { result in
            if let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                throw SRGDataProviderError.http(statusCode: httpResponse.statusCode)
            }
            return result
        }
    }
    
    func tryMapJson<T>(_ type: T.Type) -> Publishers.TryMap<Self, SimpleOuput<T>> where Output == URLSession.DataTaskPublisher.Output {
        return tryMap { result in
            if let array = try JSONSerialization.jsonObject(with: result.data, options: []) as? T {
                return (array, result.response)
            }
            else {
                throw SRGDataProviderError.invalidData
            }
        }
    }
    
    func extractNextPage<T>(_ extractor: @escaping (T) -> URL?) -> Publishers.Map<Self, PageOuput<T>> where Output == SimpleOuput<T> {
        return map { result in
            return (result.data, extractor(result.data), result.response)
        }
    }
}
