//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@_exported import Combine
@_exported import SRGDataProvider
@_exported import SRGDataProviderModel

import Mantle
import SRGDataProviderRequests
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
        let request = requestTVChannels(for: vendor)
        return objectsTaskPublisher(for: request, rootKey: "channelList").map { $0 }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVChannel {
        public typealias Output = (channel: SRGChannel, response: URLResponse)
    }
    
    func tvChannel(for vendor: SRGVendor, withUid channelUid: String) -> AnyPublisher<TVChannel.Output, Error> {
        let request = requestTVChannel(for: vendor, withUid: channelUid)
        return objectTaskPublisher(for: request).map { $0 }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVLatestPrograms {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (programComposition: SRGProgramComposition, page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func tvLatestPrograms(for vendor: SRGVendor, channelUid: String, livestreamUid: String? = nil, from: Date? = nil, to: Date? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVLatestPrograms.Output, Error> {
        let request = requestTVLatestPrograms(for: vendor, channelUid: channelUid, livestreamUid: livestreamUid, from:from, to: to)
        return tvLatestPrograms(at: Page(request: request, size: pageSize))
    }
    
    func tvLatestPrograms(at page: TVLatestPrograms.Page) -> AnyPublisher<TVLatestPrograms.Output, Error> {
        return paginatedObjectTaskPublisher(for: page.request)
            .map { result in
                (result.object, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVLivestreams {
        public typealias Output = (medias: [SRGMedia], response: URLResponse)
    }
    
    func tvLivestreams(for vendor: SRGVendor) -> AnyPublisher<TVLivestreams.Output, Error> {
        let request = requestTVLivestreams(for: vendor)
        return objectsTaskPublisher(for: request, rootKey: "mediaList").map { $0 }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVScheduledLivestreams {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func tvLatestPrograms(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVScheduledLivestreams.Output, Error> {
        let request = requestTVScheduledLivestreams(for: vendor)
        return tvScheduledLivestreams(at: Page(request: request, size: pageSize))
    }
    
    func tvScheduledLivestreams(at page: TVScheduledLivestreams.Page) -> AnyPublisher<TVScheduledLivestreams.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList")
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVEditorialMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func tvEditorialMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVEditorialMedias.Output, Error> {
        let request = requestTVEditorialMedias(for: vendor)
        return tvEditorialMedias(at: Page(request: request, size: pageSize))
    }
    
    func tvEditorialMedias(at page: TVEditorialMedias.Page) -> AnyPublisher<TVEditorialMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList")
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVLatestMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func tvLatestMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVLatestMedias.Output, Error> {
        let request = requestTVLatestMedias(for: vendor)
        return tvLatestMedias(at: Page(request: request, size: pageSize))
    }
    
    func tvLatestMedias(at page: TVLatestMedias.Page) -> AnyPublisher<TVLatestMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList")
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVMostPopularMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func tvMostPopularMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVMostPopularMedias.Output, Error> {
        let request = requestTVMostPopularMedias(for: vendor)
        return tvMostPopularMedias(at: Page(request: request, size: pageSize))
    }
    
    func tvMostPopularMedias(at page: TVMostPopularMedias.Page) -> AnyPublisher<TVMostPopularMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList")
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVSoonExpiringMedias {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func tvSoonExpiringMedias(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVSoonExpiringMedias.Output, Error> {
        let request = requestTVSoonExpiringMedias(for: vendor)
        return tvSoonExpiringMedias(at: Page(request: request, size: pageSize))
    }
    
    func tvSoonExpiringMedias(at page: TVSoonExpiringMedias.Page) -> AnyPublisher<TVSoonExpiringMedias.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList")
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVTrendingMedias {
        public typealias Output = (medias: [SRGMedia], response: URLResponse)
    }
    
    func tvTrendingMedias(for vendor: SRGVendor, limit: Int? = nil, editorialLimit: Int? = nil, episodesOnly: Bool = false, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVTrendingMedias.Output, Error> {
        let request = requestTVTrendingMedias(for: vendor, withLimit: limit as NSNumber?, editorialLimit: editorialLimit as NSNumber?, episodesOnly: episodesOnly)
        return objectsTaskPublisher(for: request, rootKey: "mediaList").map { $0 }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVLatestEpisodes {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func tvLatestEpisodes(for vendor: SRGVendor, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVLatestEpisodes.Output, Error> {
        let request = requestTVLatestEpisodes(for: vendor)
        return tvLatestEpisodes(at: Page(request: request, size: pageSize))
    }
    
    func tvLatestEpisodes(at page: TVLatestEpisodes.Page) -> AnyPublisher<TVLatestEpisodes.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList")
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVEpisodes {
        public typealias Page = SRGDataProvider.Page<Self>
        public typealias Output = (medias: [SRGMedia], page: Page, nextPage: Page?, response: URLResponse)
    }
    
    func tvEpisodes(for vendor: SRGVendor, day: SRGDay? = nil, pageSize: UInt = SRGDataProviderDefaultPageSize) -> AnyPublisher<TVEpisodes.Output, Error> {
        let request = requestTVEpisodes(for: vendor, day: day)
        return tvEpisodes(at: Page(request: request, size: pageSize))
    }
    
    func tvEpisodes(at page: TVEpisodes.Page) -> AnyPublisher<TVEpisodes.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList")
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum TVTopics {
        public typealias Output = (topics: [SRGTopic], response: URLResponse)
    }
    
    func tvTopics(for vendor: SRGVendor) -> AnyPublisher<TVTopics.Output, Error> {
        let request = requestTVTopics(for: vendor)
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
        let request = requestLatestMediasForTopic(withURN: topicUrn)
        return latestMediasForTopic(at: Page(request: request, size: pageSize))
    }
    
    func latestMediasForTopic(at page: LatestMediasForTopic.Page) -> AnyPublisher<LatestMediasForTopic.Output, Error> {
        return paginatedObjectsTaskPublisher(for: page.request, rootKey: "mediaList")
            .map { result in
                (result.objects, page, page.next(with: result.nextRequest), result.response)
            }
            .eraseToAnyPublisher()
    }
}

// TODO: Unlimited page size support

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
    
    typealias PaginatedObjectOutput<T> = (object: T, nextRequest: URLRequest?, response: URLResponse)
    typealias PaginatedObjectsOutput<T> = (objects: [T], nextRequest: URLRequest?, response: URLResponse)
    
    func paginatedDictionaryTaskPublisher(for request: URLRequest) -> AnyPublisher<PaginatedObjectOutput<[String: Any]>, Error> {
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .extractNextPage { data in
                guard let urlString = data["next"] as? String else { return nil }
                return URL(string: urlString)
            }
            .map { result in
                let nextRequest = self.urlRequest(from: request, withUrl: result.nextUrl)
                return (result.data, nextRequest, result.response)
            }
            .eraseToAnyPublisher()
    }
    
    func paginatedObjectsTaskPublisher<T>(for request: URLRequest, rootKey: String) -> AnyPublisher<PaginatedObjectsOutput<T>, Error> {
        return paginatedDictionaryTaskPublisher(for: request)
            .tryMap { result in
                // Remark: When the result count is equal to a multiple of the page size, the last link returns an empty list array
                //         (or no such entry at all for the episode composition request)
                // See https://confluence.srg.beecollaboration.com/display/SRGPLAY/Developer+Meeting+2016-10-05
                guard let array = result.object[rootKey] as? [Any] else {
                    return ([], nil, result.response)
                }
                
                if let objects = try MTLJSONAdapter.models(of: T.self as? AnyClass, fromJSONArray: array) as? [T] {
                    return (objects, result.nextRequest, result.response)
                }
                else {
                    throw SRGDataProviderError.invalidData
                }
            }
            .eraseToAnyPublisher()
    }
    
    func paginatedObjectTaskPublisher<T>(for request: URLRequest) -> AnyPublisher<PaginatedObjectOutput<T>, Error> {
        return paginatedDictionaryTaskPublisher(for: request)
            .tryMap { result in
                if let object = try MTLJSONAdapter.model(of: T.self as? AnyClass, fromJSONDictionary: result.object) as? T {
                    return (object, result.nextRequest, result.response)
                }
                else {
                    throw SRGDataProviderError.invalidData
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
        return paginatedObjectTaskPublisher(for: request)
            .map { result in
                return (result.object, result.response)
            }
            .eraseToAnyPublisher()
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
            if let object = try JSONSerialization.jsonObject(with: result.data, options: []) as? T {
                return (object, result.response)
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
