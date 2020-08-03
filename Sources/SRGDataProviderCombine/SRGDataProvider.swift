//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine
import Mantle
import SRGDataProviderModel
import SRGNetworkCombine

enum SRGDataProviderError: Error {
    case http(statusCode: Int)
    case invalidData
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct SRGDataProvider {
    let session: URLSession = URLSession(configuration: .default, delegate: SRGSessionDelegate(), delegateQueue: nil)
    let serviceUrl: URL
    
    // TODO: Add typealiases for return publishers? (e.g. DataPublisher<[SRGChannel], Error>], DataPagePublisher<[SRGChannel], Error>])
    //       Maybe with named arguments for tuple so that .data, .response are possible in sink
    
    public func tvChannels(for vendor: SRGVendor) -> AnyPublisher<([SRGChannel], URLResponse), Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/channelList/tv")
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .tryMap { result in
                guard let array = result.data["channelList"] as? [Any] else {
                    throw SRGDataProviderError.invalidData
                }
                
                if let channels = try MTLJSONAdapter.models(of: SRGChannel.self, fromJSONArray: array) as? [SRGChannel] {
                    return (channels, result.response)
                }
                else {
                    return ([], result.response)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func tvTrendingMedias(for vendor: SRGVendor, limit: Int? = nil, editorialLimit: Int? = nil, episodesOnly: Bool? = nil) -> AnyPublisher<([SRGMedia], URLResponse), Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/mediaList/video/trending")
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .tryMap { result in
                guard let array = result.data["mediaList"] as? [Any] else {
                    throw SRGDataProviderError.invalidData
                }
                
                if let medias = try MTLJSONAdapter.models(of: SRGMedia.self, fromJSONArray: array) as? [SRGMedia] {
                    return (medias, result.response)
                }
                else {
                    return ([], result.response)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func tvLatestMedias(for vendor: SRGVendor) -> AnyPublisher<([SRGMedia], URLResponse), Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/mediaList/video/latestEpisodes")
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .tryMap { result in
                guard let array = result.data["mediaList"] as? [Any] else {
                    throw SRGDataProviderError.invalidData
                }
                
                if let medias = try MTLJSONAdapter.models(of: SRGMedia.self, fromJSONArray: array) as? [SRGMedia] {
                    return (medias, result.response)
                }
                else {
                    return ([], result.response)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func tvTopics(for vendor: SRGVendor) -> AnyPublisher<([SRGTopic], URLResponse), Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/topicList/tv")
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .tryMap { result in
                guard let array = result.data["topicList"] as? [Any] else {
                    throw SRGDataProviderError.invalidData
                }
                
                if let topics = try MTLJSONAdapter.models(of: SRGTopic.self, fromJSONArray: array) as? [SRGTopic] {
                    return (topics, result.response)
                }
                else {
                    return ([], result.response)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func latestMediasForTopic(withUrn topicUrn: String) -> AnyPublisher<([SRGMedia], URLResponse), Error> {
        let request = urlRequest(for: "2.0/mediaList/latest/byTopicUrn/\(topicUrn)")
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .tryMap { result in
                guard let array = result.data["mediaList"] as? [Any] else {
                    throw SRGDataProviderError.invalidData
                }
                
                if let medias = try MTLJSONAdapter.models(of: SRGMedia.self, fromJSONArray: array) as? [SRGMedia] {
                    return (medias, result.response)
                }
                else {
                    return ([], result.response)
                }
            }
            .eraseToAnyPublisher()
    }
        
    private func urlRequest(for resourcePath: String) -> URLRequest {
        let url = serviceUrl.appendingPathComponent(resourcePath)
        return URLRequest(url: url)
    }
}

class SRGSessionDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        // Refuse the redirection and return the redirection response (with the proper HTTP status code)
        completionHandler(nil)
    }
}
