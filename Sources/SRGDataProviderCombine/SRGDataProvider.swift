//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine
import Mantle
import SRGDataProvider

enum SRGDataProviderError: Error {
    case http(statusCode: Int)
    case invalidData
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    struct Page {
        let request: URLRequest
        
        fileprivate init?(request: URLRequest?) {
            if let request = request {
                self.request = request;
            }
            else {
                return nil
            }
        }
    }
    
    typealias ChannelOutput = (channel: SRGChannel, response: URLResponse)
    typealias ChannelsOutput = (channels: [SRGChannel], response: URLResponse)
    typealias TopicsOutput = (topics: [SRGTopic], response: URLResponse)
    
    typealias MediasPageOutput = (medias: [SRGMedia], next: Page?, response: URLResponse)
    
    func tvChannels(for vendor: SRGVendor) -> AnyPublisher<ChannelsOutput, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/channelList/tv")
        return objectsTaskPublisher(for: request, rootKey: "channelList").map { ($0, $2) }.eraseToAnyPublisher()
    }
    
    func tvChannel(for vendor: SRGVendor, withUid channelUid: String) -> AnyPublisher<ChannelOutput, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/channel/\(channelUid)/tv/nowAndNext")
        return objectTaskPublisher(for: request).map { $0 }.eraseToAnyPublisher()
    }
    
    func tvTrendingMedias(for vendor: SRGVendor, limit: Int? = nil, editorialLimit: Int? = nil, episodesOnly: Bool? = nil) -> AnyPublisher<MediasPageOutput, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/mediaList/video/trending")
        return objectsTaskPublisher(for: request, rootKey: "mediaList").map { result in
            (result.objects, Page(request: result.nextRequest), result.response)
        }.eraseToAnyPublisher()
    }
    
    func tvLatestMedias(for vendor: SRGVendor) -> AnyPublisher<MediasPageOutput, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/mediaList/video/latestEpisodes")
        return tvLatestMedias(for: request)
    }
    
    func tvLatestMedias(for page: Page) -> AnyPublisher<MediasPageOutput, Error> {
        return tvLatestMedias(for: page.request)
    }
    
    private func tvLatestMedias(for request: URLRequest) -> AnyPublisher<MediasPageOutput, Error> {
        return objectsTaskPublisher(for: request, rootKey: "mediaList").map { result in
            (result.objects, Page(request: result.nextRequest), result.response)
        }.eraseToAnyPublisher()
    }
    
    func tvTopics(for vendor: SRGVendor) -> AnyPublisher<TopicsOutput, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/topicList/tv")
        return objectsTaskPublisher(for: request, rootKey: "topicList").map { ($0, $2) }.eraseToAnyPublisher()
    }
    
    func latestMediasForTopic(withUrn topicUrn: String) -> AnyPublisher<MediasPageOutput, Error> {
        let request = urlRequest(for: "2.0/mediaList/latest/byTopicUrn/\(topicUrn)")
        return objectsTaskPublisher(for: request, rootKey: "mediaList").map { result in
            (result.objects, Page(request: result.nextRequest), result.response)
        }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    typealias ObjectOutput<T> = (object: T, response: URLResponse)
    typealias ObjectsOutput<T> = (objects: [T], nextRequest: URLRequest?, response: URLResponse)
    
    fileprivate func objectsTaskPublisher<T>(for request: URLRequest, rootKey: String) -> AnyPublisher<ObjectsOutput<T>, Error> {
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
    
    fileprivate func objectTaskPublisher<T>(for request: URLRequest) -> AnyPublisher<ObjectOutput<T>, Error> {
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
    
    fileprivate func urlRequest(for resourcePath: String) -> URLRequest {
        let url = serviceURL.appendingPathComponent(resourcePath)
        return URLRequest(url: url)
    }
    
    fileprivate func urlRequest(from request: URLRequest, withUrl url: URL?) -> URLRequest {
        guard let url = url else { return request }
        var updatedRequest = request
        updatedRequest.url = url;
        return updatedRequest
    }
}

class SRGSessionDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        // Refuse the redirection and return the redirection response (with the proper HTTP status code)
        completionHandler(nil)
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    public typealias SimpleOuput<T> = (data: T, response: URLResponse)
    public typealias PageOuput<T> = (data: T, nextUrl: URL?, response: URLResponse)
    
    public func manageNetworkActivity() -> Publishers.HandleEvents<Self> where Self == URLSession.DataTaskPublisher {
        return handleEvents { _ in
            SRGNetworkActivityManagement.increaseNumberOfRunningRequests()
        } receiveCompletion: { _ in
            SRGNetworkActivityManagement.decreaseNumberOfRunningRequests()
        } receiveCancel: {
            SRGNetworkActivityManagement.decreaseNumberOfRunningRequests()
        }
    }
    
    public func reportHttpErrors() -> Publishers.TryMap<Self, Output> where Output == URLSession.DataTaskPublisher.Output {
        return tryMap { result in
            if let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                throw SRGDataProviderError.http(statusCode: httpResponse.statusCode)
            }
            return result
        }
    }
    
    public func tryMapJson<T>(_ type: T.Type) -> Publishers.TryMap<Self, SimpleOuput<T>> where Output == URLSession.DataTaskPublisher.Output {
        return tryMap { result in
            if let array = try JSONSerialization.jsonObject(with: result.data, options: []) as? T {
                return (array, result.response)
            }
            else {
                throw SRGDataProviderError.invalidData
            }
        }
    }
    
    public func extractNextPage<T>(_ extractor: @escaping (T) -> URL?) -> Publishers.Map<Self, PageOuput<T>> where Output == SimpleOuput<T> {
        return map { result in
            return (result.data, extractor(result.data), result.response)
        }
    }
}
