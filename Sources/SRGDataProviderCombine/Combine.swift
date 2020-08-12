//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine
import Mantle
import SRGDataProvider
import SRGDataProviderModel
import SRGDataProviderRequests
import SRGNetwork

/**
 *  Errors possibly emitted by the data provider.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public enum SRGDataProviderError: Error {
    /// HTTP error.
    case http(statusCode: Int)
    /// Invalid data (missing or parsing error).
    case invalidData
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    /**
     *  Describes a page of content.
     *
     *  Uses generics to have a different page type associated with each kind of request, so that pages generated
     *  by some kind of request cannot be used with another kind of request.
     */
    public struct Page<T> {
        /// The request associated with the page.
        let request: URLRequest
        
        /// The size of the page.
        public let size: UInt
        
        /// The page number.
        public let number: UInt
        
        /**
         *  Create the first page.
         */
        init(request: URLRequest, size: UInt) {
            func clampedSize(size: UInt) -> UInt {
                if size > SRGDataProviderMaximumPageSize && size != SRGDataProviderUnlimitedPageSize {
                    return SRGDataProviderMaximumPageSize;
                }
                else {
                    return size
                }
            }
            
            func updatedRequest(from request: URLRequest, with url: URL) -> URLRequest {
                var updatedRequest = request
                updatedRequest.url = url
                return updatedRequest
            }
            
            func urlRequest(_ request: URLRequest, withSize size: UInt) -> URLRequest {
                guard let url = request.url,
                      var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                    return request
                    
                }
                
                var queryItems = components.queryItems ?? []
                let pageSize = (size != SRGDataProviderUnlimitedPageSize) ? String(size) : "unlimited"
                queryItems.append(URLQueryItem(name: "pageSize", value: pageSize))
                components.queryItems = queryItems
                
                guard let fullUrl = components.url else { return request }
                return updatedRequest(from: request, with: fullUrl)
            }
            
            let pageSize = clampedSize(size: size)
            self.init(request: urlRequest(request, withSize: pageSize), size: pageSize, number: 0)
        }
        
        /**
         *  Create an arbitrary page.
         */
        private init(request: URLRequest, size: UInt, number: UInt) {
            self.request = request
            self.size = size
            self.number = number
        }
        
        /**
         *  Generate the next page for the receiver, associating the provided request with it.
         */
        func next(with request: URLRequest?) -> Page<T>? {
            if let request = request {
                return Page(request: request, size: size, number: number + 1)
            }
            else {
                return nil
            }
        }
    }
}
    
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    typealias PaginatedObjectsOutput<T> = (objects: [T], total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?, nextRequest: URLRequest?, response: URLResponse)
    
    /**
     *  A publisher able to retrieve possibly paginated arrays of objects.
     */
    func paginatedObjectsTaskPublisher<T>(for request: URLRequest, rootKey: String, type: T.Type) -> AnyPublisher<PaginatedObjectsOutput<T>, Error> where T: MTLModel {
        return paginatedDictionaryTaskPublisher(for: request)
            .tryMap { result in
                // Remark: When the result count is equal to a multiple of the page size, the last link returns an empty list array
                //         (or no such entry at all for the episode composition request)
                // See https://confluence.srg.beecollaboration.com/display/SRGPLAY/Developer+Meeting+2016-10-05
                guard let array = result.object[rootKey] as? [Any] else {
                    return ([], result.total, result.aggregations, result.suggestions, nil, result.response)
                }
                
                if let objects = try? MTLJSONAdapter.models(of: T.self, fromJSONArray: array) as? [T] {
                    return (objects, result.total, result.aggregations, result.suggestions, result.nextRequest, result.response)
                }
                else {
                    throw SRGDataProviderError.invalidData
                }
            }
            .eraseToAnyPublisher()
    }
}


@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    typealias PaginatedObjectOutput<T> = (object: T, total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?, nextRequest: URLRequest?, response: URLResponse)
    
    /**
     *  A publisher able to retrieve possibly paginated objects (one object per page).
     */
    func paginatedObjectTaskPublisher<T>(for request: URLRequest, type: T.Type) -> AnyPublisher<PaginatedObjectOutput<T>, Error> where T: MTLModel {
        return paginatedDictionaryTaskPublisher(for: request)
            .tryMap { result in
                if let object = try? MTLJSONAdapter.model(of: T.self, fromJSONDictionary: result.object) as? T {
                    return (object, result.total, result.aggregations, result.suggestions, result.nextRequest, result.response)
                }
                else {
                    throw SRGDataProviderError.invalidData
                }
            }
            .eraseToAnyPublisher()
    }
    
    /**
     *  A publisher able to retrieve possibly paginated JSON dictionaries.
     */
    private func paginatedDictionaryTaskPublisher(for request: URLRequest) -> AnyPublisher<PaginatedObjectOutput<[String: Any]>, Error> {
        func extractNextUrl(from dictionary: [String: Any]) -> URL? {
            if let nextUrlString = dictionary["next"] as? String {
                return URL(string: nextUrlString)
            }
            else {
                return nil
            }
        }
        
        func updatedRequest(from request: URLRequest, with url: URL?) -> URLRequest? {
            guard let url = url else { return nil }
            var updatedRequest = request
            updatedRequest.url = url
            return updatedRequest
        }
        
        func extractTotal(from dictionary: [String: Any]) -> UInt {
            return dictionary["total"] as? UInt ?? 0
        }
        
        func extractAggregations(from dictionary: [String: Any]) -> SRGMediaAggregations? {
            guard let aggregationsJsonDictionary = dictionary["aggregations"] as? [String: Any] else { return nil }
            return try? MTLJSONAdapter.model(of: SRGMediaAggregations.self, fromJSONDictionary: aggregationsJsonDictionary) as? SRGMediaAggregations
        }
        
        func extractSuggestions(from dictionary: [String: Any]) -> [SRGSearchSuggestion]? {
            guard let suggestionsJsonArray = dictionary["suggestionList"] as? [Any] else { return nil }
            return try? MTLJSONAdapter.models(of: SRGSearchSuggestion.self, fromJSONArray: suggestionsJsonArray) as? [SRGSearchSuggestion]
        }
        
        return session.dataTaskPublisher(for: request)
            .manageNetworkActivity()
            .reportHttpErrors()
            .tryMapJson([String: Any].self)
            .map { result in
                let nextRequest = updatedRequest(from: request, with: extractNextUrl(from: result.data))
                return (result.data, extractTotal(from: result.data), extractAggregations(from: result.data), extractSuggestions(from: result.data), nextRequest, result.response)
            }
            .eraseToAnyPublisher()
    }
}


@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    typealias ObjectsOutput<T> = (objects: [T], response: URLResponse)
    
    /**
     *  A publisher able to retrieve non-paginated arrays of objects.
     */
    func objectsTaskPublisher<T>(for request: URLRequest, rootKey: String, type: T.Type) -> AnyPublisher<ObjectsOutput<T>, Error> where T: MTLModel {
        return paginatedObjectsTaskPublisher(for: request, rootKey: rootKey, type: T.self)
            .map { result in
                return (result.objects, result.response)
            }
            .eraseToAnyPublisher()
    }
    
}


@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    typealias ObjectOutput<T> = (object: T, response: URLResponse)
    
    /**
     *  A publisher able to retrieve a single object.
     */
    func objectTaskPublisher<T>(for request: URLRequest, type: T.Type) -> AnyPublisher<ObjectOutput<T>, Error> where T: MTLModel {
        return paginatedObjectTaskPublisher(for: request, type: T.self)
            .map { result in
                return (result.object, result.response)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {
    typealias Ouput<T> = (data: T, response: URLResponse)
    
    /**
     *  An operator to enable `SRGNetwork` automatic network activity management on a data task publisher.
     */
    func manageNetworkActivity() -> Publishers.HandleEvents<Self> where Self == URLSession.DataTaskPublisher {
        return handleEvents { _ in
            SRGNetworkActivityManagement.increaseNumberOfRunningRequests()
        } receiveCompletion: { _ in
            SRGNetworkActivityManagement.decreaseNumberOfRunningRequests()
        } receiveCancel: {
            SRGNetworkActivityManagement.decreaseNumberOfRunningRequests()
        }
    }
    
    /**
     *  An operator turning all HTTP errors over 400 into proper errors reported to the publisher stream.
     */
    func reportHttpErrors() -> Publishers.TryMap<Self, Output> where Output == URLSession.DataTaskPublisher.Output {
        return tryMap { result in
            if let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode >= 400 {
                throw SRGDataProviderError.http(statusCode: httpResponse.statusCode)
            }
            return result
        }
    }
    
    /**
     *  An operator attempting to map some JSON to an object of a given type.
     */
    func tryMapJson<T>(_ type: T.Type) -> Publishers.TryMap<Self, Ouput<T>> where Output == URLSession.DataTaskPublisher.Output {
        return tryMap { result in
            if let object = try JSONSerialization.jsonObject(with: result.data, options: []) as? T {
                return (object, result.response)
            }
            else {
                throw SRGDataProviderError.invalidData
            }
        }
    }
}
