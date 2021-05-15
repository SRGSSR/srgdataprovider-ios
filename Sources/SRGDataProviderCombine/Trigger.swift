//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  Trigger for publishers waiting for a signal to continue their processing.
 */
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Trigger {
    public typealias Index = Int
    public typealias Subject = PassthroughSubject<Index, Never>
    public typealias Publisher = AnyPublisher<Index, Never>
    
    public typealias Id = (publisher: Publisher, index: Index)
    
    private let subject = Subject()
    
    static func sentinel(for triggerId: Trigger.Id?) -> AnyPublisher<Bool, Never> {
        if let triggerId = triggerId {
            return triggerId.publisher
                .contains(triggerId.index)
                .eraseToAnyPublisher()
        }
        else {
            return PassthroughSubject<Bool, Never>().eraseToAnyPublisher()
        }
    }
    
    public init() {}
    
    private var publisher: Publisher {
        return subject.eraseToAnyPublisher()
    }
    
    /**
     *  Generate an identifier with the specified index.
     */
    public func id(_ index: Index) -> Id {
        return (publisher, index)
    }
    
    /**
     *  Generate an identifier from a hashable instance.
     */
    public func id<T>(_ t: T) -> Id where T: Hashable {
        return (publisher, t.hashValue)
    }
    
    /**
     *  Tell the associated publisher to continue its processing for the specified index.
     */
    public func signal(_ index: Index) {
        subject.send(index)
    }
    
    /**
     *  Tell the associated publisher to continue for some hashable instance.
     */
    public func signal<T>(_ t: T) where T: Hashable {
        subject.send(t.hashValue)
    }
}

#endif
