//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  A trigger provides a context in which signals can be sent to an associated set of publishers. For each publisher
 *  to which a signal must be sent, an identifier must be retrieved from the trigger first (using an index or, better,
 *  some hashable value).
 *
 *  This identifier mzst itself be used to create an associated sentinel. A sentinel is a publisher which responds
 *  to an associated signal by emitting a value and completing.
 */
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Trigger {
    public typealias Index = Int
    public typealias Subject = PassthroughSubject<Index, Never>
    public typealias Publisher = AnyPublisher<Index, Never>
    public typealias Sentinel = AnyPublisher<Void, Never>
    
    public typealias Id = (publisher: Publisher, index: Index)
    
    private let subject = Subject()
    
    /**
     *  Create a sentinel which emits a value when the corresponding signal is received.
     */
    public static func sentinel(for triggerId: Trigger.Id) -> Sentinel {
        return sentinel(for: triggerId.publisher, index: triggerId.index)
    }
    
    private static func sentinel(for publisher: Publisher, index: Index) -> Sentinel {
        return publisher
            .contains(index)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Create a trigger.
     */
    public init() {}
    
    private var publisher: Publisher {
        return subject.eraseToAnyPublisher()
    }
    
    /**
     *  Generate an identifier for some index.
     */
    public func id(_ index: Index) -> Id {
        return (publisher, index)
    }
    
    /**
     *  Generate an identifier for some hashable value.
     */
    public func id<T>(_ t: T) -> Id where T: Hashable {
        return id(t.hashValue)
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
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    /**
     *  Make the upstream publisher execute again when a second signal publisher emits some value. No matter whether
     *  the second publisher emits a value the upstream publishers executes normally once.
     */
    func publishAgain<S>(on signal: S) -> AnyPublisher<Self.Output, Self.Failure> where S: Publisher, S.Failure == Never {
        return signal
            .map { _ in }
            .prepend(())
            .setFailureType(to: Self.Failure.self)          // TODO: Remove when iOS 14 is the minimum deployment target
            .flatMap { _ in
                return self
            }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Make the upstream publisher wait until a second signal publsher emits some value.
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
