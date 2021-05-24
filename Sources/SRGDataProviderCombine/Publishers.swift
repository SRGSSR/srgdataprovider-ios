//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

@_implementationOnly import SRGNetwork

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    /**
     *  Make the upstream publisher execute again when a second signal publisher emits some value. No matter whether
     *  the second publisher emits a value the upstream publishers executes normally once.
     */
    func `repeat`<S>(onOutputFrom signal: S) -> AnyPublisher<Self.Output, Self.Failure> where S: Publisher, S.Failure == Never {
        // Use `prepend(_:)` to trigger an initial update
        // Inspired from https://stackoverflow.com/questions/66075000/swift-combine-publishers-where-one-hasnt-sent-a-value-yet
        return signal
            .map { _ in }
            .prepend(())
            .setFailureType(to: Self.Failure.self)          // TODO: Remove when iOS 14 is the minimum deployment target
            .map { _ in
                return self
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    /**
     *  Make the upstream publisher wait until a second signal publisher emits some value.
     */
    func wait<S>(untilOutputFrom signal: S) -> AnyPublisher<Self.Output, Self.Failure> where S: Publisher, S.Failure == Never {
        return self
            .prepend(
                Empty(completeImmediately: false)
                    .prefix(untilOutputFrom: signal)
            )
            .eraseToAnyPublisher()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publishers {
    /**
     *  Accumulate the latest values emitted by several publishers into an array. All the publishers must emit a
     *  value before `AccumulateLatestMany` emits a value, as for `CombineLatest`.
     */
    static func AccumulateLatestMany<T>(_ publishers: AnyPublisher<T, Error>...) -> AnyPublisher<[T], Error> {
        return AccumulateLatestMany(publishers)
    }
    
    /**
     *  Accumulate the latest values emitted by a sequence of publishers into an array. All the publishers must
     *  emit a value before `AccumulateLatestMany` emits a value, as for `CombineLatest`.
     */
    static func AccumulateLatestMany<S, T>(_ publishers: S) -> AnyPublisher<[T], Error> where S: Swift.Sequence, S.Element == AnyPublisher<T, Error> {
        let publishersArray = Array(publishers)
        
        // Recursively split in two until we can process groups of 2 or 3 items
        if publishersArray.count == 2 {
            return Publishers.CombineLatest(publishersArray[0], publishersArray[1])
                .map { t1, t2 in
                    return [t1, t2]
                }
                .eraseToAnyPublisher()
        }
        else if publishersArray.count == 3 {
            return Publishers.CombineLatest3(publishersArray[0], publishersArray[1], publishersArray[2])
                .map { t1, t2, t3 in
                    return [t1, t2, t3]
                }
                .eraseToAnyPublisher()
        }
        else {
            let half = publishersArray.count / 2
            return Publishers.CombineLatest(
                AccumulateLatestMany(Array(publishersArray[0..<half])),
                AccumulateLatestMany(Array(publishersArray[half..<publishersArray.count]))
            )
            .map { array1, array2 in
                return array1 + array2
            }
            .eraseToAnyPublisher()
        }
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

#endif
