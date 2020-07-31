//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine
import SRGDataProviderModel

enum SRGDataProviderError: Error {
    case http(statusCode: Int)
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct SRGDataProvider {
    let session: URLSession = URLSession(configuration: .default, delegate: SRGSessionDelegate(), delegateQueue: nil)
    let serviceUrl: URL
    
    // TODO: Possible to abstract with generics for common request logic (non-paginated / paginated)?
    // TODO: Do request with pagination support as well (with pagination API)
    // TODO: Share common parsing logic / error handling with SRGDataProvider / SRGNetwork
    // TODO: As for DataTaskPublisher.Output, define typealias for tuples
    public func tvChannels(for vendor: SRGVendor) -> AnyPublisher<([SRGChannel], URLResponse), Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/channelList/tv")
        return session.dataTaskPublisher(for: request).tryMap { result -> ([SRGChannel], URLResponse) in
            // TODO: Should be in SRGNetwork combine wrapper
            if let httpResponse = result.response as? HTTPURLResponse {
                guard (0..<400).contains(httpResponse.statusCode) else {
                    throw SRGDataProviderError.http(statusCode: httpResponse.statusCode)
                }
            }
            
            // TODO: SRGNetwork should implement support for Combine and parsing errors returned to it
            if let channels = SRGDataProviderParseObjects(result.data, "channelList", SRGChannel.self, nil /* TODO: Return to SRGNetwork */) as? [SRGChannel] {
                return (channels, result.response)
            }
            else {
                return ([], result.response)
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func tvLatestMedias(for vendor: SRGVendor) -> AnyPublisher<([SRGMedia], URLResponse), Error> {
        let request = urlRequest(for: "2.0/\(SRGPathComponentForVendor(vendor))/mediaList/video/latestEpisodes")
        return session.dataTaskPublisher(for: request).tryMap { result -> ([SRGMedia], URLResponse) in
            if let httpResponse = result.response as? HTTPURLResponse {
                guard (0..<400).contains(httpResponse.statusCode) else {
                    throw SRGDataProviderError.http(statusCode: httpResponse.statusCode)
                }
            }
            
            if let medias = SRGDataProviderParseObjects(result.data, "mediaList", SRGMedia.self, nil /* TODO: Return to SRGNetwork */) as? [SRGMedia] {
                return (medias, result.response)
            }
            else {
                return ([], result.response)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func urlRequest(for resourcePath: String) -> URLRequest {
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
