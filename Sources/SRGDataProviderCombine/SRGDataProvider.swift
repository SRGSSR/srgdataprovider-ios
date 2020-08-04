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
    typealias ChannelOutput = (channel: SRGChannel, response: URLResponse)
    typealias ChannelsOutput = (channels: [SRGChannel], response: URLResponse)
    typealias MediasOutput = (medias: [SRGMedia], response: URLResponse)
    typealias TopicsOutput = (topics: [SRGTopic], response: URLResponse)
    
    func tvChannels(for vendor: SRGVendor) -> AnyPublisher<ChannelsOutput, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/channelList/tv")
        return objectsTaskPublisher(for: request, rootKey: "channelList").map { $0 }.eraseToAnyPublisher()
    }
    
    func tvChannel(for vendor: SRGVendor, withUid channelUid: String) -> AnyPublisher<ChannelOutput, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/channel/\(channelUid)/tv/nowAndNext")
        return objectTaskPublisher(for: request).map { $0 }.eraseToAnyPublisher()
    }
    
    func tvTrendingMedias(for vendor: SRGVendor, limit: Int? = nil, editorialLimit: Int? = nil, episodesOnly: Bool? = nil) -> AnyPublisher<MediasOutput, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/mediaList/video/trending")
        return objectsTaskPublisher(for: request, rootKey: "mediaList").map { $0 }.eraseToAnyPublisher()
    }
    
    func tvLatestMedias(for vendor: SRGVendor) -> AnyPublisher<MediasOutput, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/mediaList/video/latestEpisodes")
        return objectsTaskPublisher(for: request, rootKey: "mediaList").map { $0 }.eraseToAnyPublisher()
    }
    
    func tvTopics(for vendor: SRGVendor) -> AnyPublisher<TopicsOutput, Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/topicList/tv")
        return objectsTaskPublisher(for: request, rootKey: "topicList").map { $0 }.eraseToAnyPublisher()
    }
    
    func latestMediasForTopic(withUrn topicUrn: String) -> AnyPublisher<MediasOutput, Error> {
        let request = urlRequest(for: "2.0/mediaList/latest/byTopicUrn/\(topicUrn)")
        return objectsTaskPublisher(for: request, rootKey: "mediaList").map { $0 }.eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    fileprivate func objectsTaskPublisher<T>(for request: URLRequest, rootKey: String) -> AnyPublisher<([T], URLResponse), Error> {
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .tryMap { result in
                guard let array = result.data[rootKey] as? [Any] else {
                    throw SRGDataProviderError.invalidData
                }
                
                if let objects = try MTLJSONAdapter.models(of: T.self as? AnyClass, fromJSONArray: array) as? [T] {
                    return (objects, result.response)
                }
                else {
                    return ([], result.response)
                }
            }
            .eraseToAnyPublisher()
    }
    
    fileprivate func objectTaskPublisher<T>(for request: URLRequest) -> AnyPublisher<(T, URLResponse), Error> {
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
}

class SRGSessionDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        // Refuse the redirection and return the redirection response (with the proper HTTP status code)
        completionHandler(nil)
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    public typealias Ouput<T> = (data: T, response: URLResponse)
    
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
    
    public func tryMapJson<T>(_ type: T.Type) -> Publishers.TryMap<Self, Ouput<T>> where Output == URLSession.DataTaskPublisher.Output {
        return tryMap { result in
            if let array = try JSONSerialization.jsonObject(with: result.data, options: []) as? T {
                return (array, result.response)
            }
            else {
                throw SRGDataProviderError.invalidData
            }
        }
    }
}
