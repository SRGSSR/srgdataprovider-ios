//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine
import SRGDataProvider
import SRGDataProviderModel

@_implementationOnly import Mantle
@_implementationOnly import SRGDataProviderRequests
@_implementationOnly import SRGNetwork
    
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension SRGDataProvider {
    typealias PaginatedObjectsOutput<T> = (objects: [T], total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?, nextRequest: URLRequest?)
    
    /**
     *  A publisher able to retrieve possibly paginated arrays of objects.
     */
    func paginatedObjectsPublisher<T>(for request: URLRequest, rootKey: String, type: T.Type) -> AnyPublisher<PaginatedObjectsOutput<T>, Error> where T: MTLModel {
        return paginatedDictionaryPublisher(for: request)
            .tryMap { result in
                // Remark: When the result count is equal to a multiple of the page size, the last link returns an empty list array
                //         (or no such entry at all for the episode composition request)
                // See https://confluence.srg.beecollaboration.com/display/SRGPLAY/Developer+Meeting+2016-10-05
                guard let array = result.object[rootKey] as? [Any] else {
                    return ([], result.total, result.aggregations, result.suggestions, nil)
                }
                
                if let objects = try? MTLJSONAdapter.models(of: T.self, fromJSONArray: array) as? [T] {
                    return (objects, result.total, result.aggregations, result.suggestions, result.nextRequest)
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
    typealias PaginatedObjectsTriggeredOutput<T> = (objects: [T], total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?)
    
    /**
     *  Inspired from RXSwift code, see for example:
     *    https://github.com/RxSwiftCommunity/RxPager/blob/master/RxPager/Classes/RxPager.swift
     *    https://stackoverflow.com/a/39645113/760435
     */
    private func paginatedObjectsTriggeredPublisher<T, P>(at page: P, rootKey: String, type: T.Type, trigger: Trigger, currentOutput: PaginatedObjectsTriggeredOutput<T>?) -> AnyPublisher<PaginatedObjectsTriggeredOutput<T>, Error> where T: MTLModel, P: NextLinkable {
        return paginatedObjectsPublisher(for: page.request, rootKey: rootKey, type: T.self)
            .flatMap { result -> AnyPublisher<PaginatedObjectsTriggeredOutput<T>, Error> in
                let output = (currentOutput?.objects ?? [] + result.objects, result.total, result.aggregations, result.suggestions)
                if let nextPage = page.next(with: result.nextRequest) {
                    return self.paginatedObjectsTriggeredPublisher(at: nextPage, rootKey: rootKey, type: type, trigger: trigger, currentOutput: output)
                        // In inverse order: Publish available results and wait for the trigger before proceeding with the
                        // next page of results.
                        .prepend(Empty(completeImmediately: false).prefix(untilOutputFrom: trigger.setFailureType(to: Error.self)))
                        .prepend(output)
                        .eraseToAnyPublisher()
                }
                else {
                    return Just(output)
                        .setFailureType(to: Error.self)         // TODO: Remove when iOS 14 is the minimum deployment target
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    /**
     *  A publisher that recursively retrieves possibly paginated arrays of objects. The first page is automatically retrieved
     *  when connecting a subscriber. Subsequent page retrieval is requested through a `Trigger` stored separately. Consolidated
     *  results are added to the current object array and are provided to subscribers when available. The pipeline reaches
     *  completion when the last page of content has been reached.
     */
    func paginatedObjectsTriggeredPublisher<T, P>(at page: P, rootKey: String, type: T.Type, trigger: Trigger) -> AnyPublisher<PaginatedObjectsTriggeredOutput<T>, Error> where T: MTLModel, P: NextLinkable {
        return paginatedObjectsTriggeredPublisher(at: page, rootKey: rootKey, type: type, trigger: trigger, currentOutput: nil)
    }
    
    func paginatedObjectsTriggeredPublisher<T, P>(at page: P, rootKey: String, type: T.Type, trigger: Trigger) -> AnyPublisher<[T], Error> where T: MTLModel, P: NextLinkable {
        return paginatedObjectsTriggeredPublisher(at: page, rootKey: rootKey, type: type, trigger: trigger, currentOutput: nil)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension SRGDataProvider {
    typealias PaginatedObjectOutput<T> = (object: T, total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?, nextRequest: URLRequest?)
    
    /**
     *  A publisher able to retrieve possibly paginated objects (one object per page).
     */
    func paginatedObjectPublisher<T>(for request: URLRequest, type: T.Type) -> AnyPublisher<PaginatedObjectOutput<T>, Error> where T: MTLModel {
        return paginatedDictionaryPublisher(for: request)
            .tryMap { result in
                if let object = try? MTLJSONAdapter.model(of: T.self, fromJSONDictionary: result.object) as? T {
                    return (object, result.total, result.aggregations, result.suggestions, result.nextRequest)
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
    private func paginatedDictionaryPublisher(for request: URLRequest) -> AnyPublisher<PaginatedObjectOutput<[String: Any]>, Error> {
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
                return (result.data, extractTotal(from: result.data), extractAggregations(from: result.data), extractSuggestions(from: result.data), nextRequest)
            }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    typealias PaginatedObjectTriggeredOutput<T> = (object: T, total: UInt, aggregations: SRGMediaAggregations?, suggestions: [SRGSearchSuggestion]?)
    typealias PaginatedObjectReducer<T, U> = (U?, T) -> U
    
    /**
     *  A publisher that recursively retrieves possibly paginated objects (one object per page). The first page is automatically
     *  retrieved when connecting a subscriber. Subsequent page retrieval is requested through a `Trigger` stored separately.
     *  Consolidated results are added to the current object array and are provided to subscribers when available. The pipeline
     *  reaches completion when the last page of content has been reached.
     *
     *  Inspired from RXSwift code, see for example:
     *    https://github.com/RxSwiftCommunity/RxPager/blob/master/RxPager/Classes/RxPager.swift
     *    https://stackoverflow.com/a/39645113/760435
     */
    private func paginatedObjectTriggeredPublisher<T, U, P>(at page: P, type: T.Type, trigger: Trigger, currentOutput: PaginatedObjectTriggeredOutput<U>?, reducer: @escaping PaginatedObjectReducer<T, U>) -> AnyPublisher<PaginatedObjectTriggeredOutput<U>, Error> where T: MTLModel, P: NextLinkable {
        return paginatedObjectPublisher(for: page.request, type: T.self)
            .flatMap { result -> AnyPublisher<PaginatedObjectTriggeredOutput<U>, Error> in
                let output = (reducer(currentOutput?.object, result.object), result.total, result.aggregations, result.suggestions)
                if let nextPage = page.next(with: result.nextRequest) {
                    return self.paginatedObjectTriggeredPublisher(at: nextPage, type: type, trigger: trigger, currentOutput: output, reducer: reducer)
                        .prepend(Empty(completeImmediately: false).prefix(untilOutputFrom: trigger.setFailureType(to: Error.self)))
                        .prepend(output)
                        .eraseToAnyPublisher()
                }
                else {
                    return Just(output)
                        .setFailureType(to: Error.self)         // TODO: Remove when iOS 14 is the minimum deployment target
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func paginatedObjectTriggeredPublisher<T, U, P>(at page: P, type: T.Type, trigger: Trigger, reducer: @escaping PaginatedObjectReducer<T, U>) -> AnyPublisher<PaginatedObjectTriggeredOutput<U>, Error> where T: MTLModel, P: NextLinkable {
        return paginatedObjectTriggeredPublisher(at: page, type: type, trigger: trigger, currentOutput: nil, reducer: reducer)
    }
    
    func paginatedObjectTriggeredPublisher<T, U, P>(at page: P, type: T.Type, trigger: Trigger, reducer: @escaping PaginatedObjectReducer<T, U>) -> AnyPublisher<U, Error> where T: MTLModel, P: NextLinkable {
        return paginatedObjectTriggeredPublisher(at: page, type: type, trigger: trigger, currentOutput: nil, reducer: reducer)
            .map { $0.object }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    /**
     *  A publisher able to retrieve non-paginated arrays of objects.
     */
    func objectsPublisher<T>(for request: URLRequest, rootKey: String, type: T.Type) -> AnyPublisher<[T], Error> where T: MTLModel {
        return paginatedObjectsPublisher(for: request, rootKey: rootKey, type: T.self)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
    
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    /**
     *  A publisher able to retrieve a single object.
     */
    func objectPublisher<T>(for request: URLRequest, type: T.Type) -> AnyPublisher<T, Error> where T: MTLModel {
        return paginatedObjectPublisher(for: request, type: T.self)
            .map { $0.object }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension Publisher {
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

#endif
