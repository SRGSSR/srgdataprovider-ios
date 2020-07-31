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
    public func tvChannels(for vendor: SRGVendor) -> AnyPublisher<([SRGChannel], URLResponse), Error> {
        let request = urlRequest(for: "2.0/rts/channelList/tv")
        return session.dataTaskPublisher(for: request).tryMap { result -> ([SRGChannel], URLResponse) in
            if let httpResponse = result.response as? HTTPURLResponse {
                guard (0..<400).contains(httpResponse.statusCode) else {
                    throw SRGDataProviderError.http(statusCode: httpResponse.statusCode)
                }
            }
            
            guard let dictionary = try JSONSerialization.jsonObject(with: result.data, options: []) as? [String: Any],
                  let array = dictionary["channelList"] as? [Any] else {
                return ([], result.response)
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
