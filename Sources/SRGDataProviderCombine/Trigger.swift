//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  A trigger provides a context in which signals can be sent to an associated set of publishers called sentinels.
 *  When a matching signal is received by a sentinel it responds by emitting a value without completing.
 */
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Trigger {
    public typealias Index = Int
    public typealias Subject = PassthroughSubject<Index, Never>
    public typealias Publisher = AnyPublisher<Index, Never>
    public typealias Sentinel = AnyPublisher<Void, Never>
    
    private let subject = Subject()
    
    /**
     *  Create a trigger.
     */
    public init() {}
    
    private var publisher: Publisher {
        return subject.eraseToAnyPublisher()
    }
    
    /**
     *  Send a signal to publishers associated with the specified index.
     */
    public func signal(_ index: Index) {
        subject.send(index)
    }
    
    /**
     *  Send a signal to publishers associated with the specified hashable value.
     */
    public func signal<T>(_ t: T) where T: Hashable {
        signal(t.hashValue)
    }
    
    /**
     *  Create a sentinel associated with the receiver and triggered by a signal (associated with some index).
     */
    public func sentinel(for index: Index) -> Sentinel {
        return Self.sentinel(for: publisher, index: index)
    }
    
    /**
     *  Create a sentinel associated with the receiver and triggered by a signal (associated with some hashable value).
     */
    public func sentinel<T>(for t: T) -> Sentinel where T: Hashable {
        return Self.sentinel(for: publisher, index: t.hashValue)
    }
    
    private static func sentinel(for publisher: Publisher, index: Index) -> Sentinel {
        return publisher
            .filter { $0 == index }
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

/**
 *  Trigger identifiers provide a way to conveniently pass trigger definitions around as a single value.
 */
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Trigger {
    typealias Id = (publisher: Publisher, index: Index)
    
    /**
     *  Generate a trigger identifier associated with the specified index.
     */
    func id(_ index: Index) -> Id {
        return (publisher, index)
    }
    
    /**
     *  Generate a trigger identifier associated with the specified hashable value.
     */
    func id<T>(_ t: T) -> Id where T: Hashable {
        return id(t.hashValue)
    }
    
    /**
     *  Create a sentinel from a trigger identifier.
     */
    static func sentinel(for triggerId: Trigger.Id) -> Sentinel {
        return sentinel(for: triggerId.publisher, index: triggerId.index)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    /**
     *  Make the upstream publisher execute again when a second signal publisher emits some value. No matter whether
     *  the second publisher emits a value the upstream publishers executes normally once.
     */
    func publishAgain<S>(on signal: S) -> AnyPublisher<Self.Output, Self.Failure> where S: Publisher, S.Failure == Never {
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
    func wait<S>(until signal: S) -> AnyPublisher<Self.Output, Self.Failure> where S: Publisher, S.Failure == Never {
        return self
            .prepend(
                Empty(completeImmediately: false)
                    .prefix(untilOutputFrom: signal)
            )
            .eraseToAnyPublisher()
    }
}

#endif
