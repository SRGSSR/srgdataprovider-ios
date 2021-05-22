//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  A trigger is a device used to send signals to an associated set of publisher receivers. Sending a signal
 *  through a trigger will make receivers which understand it respond by emitting a void value. Note that
 *  receiver publishers never complete and thus can be sent as many signals as needed.
 */
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Trigger {
    public typealias Index = Int
    public typealias Publisher = AnyPublisher<Index, Never>
    public typealias Receiver = AnyPublisher<Void, Never>
    
    private typealias Sender = PassthroughSubject<Index, Never>
    
    private let sender = Sender()
    
    /**
     *  Create a trigger.
     */
    public init() {}
    
    private var publisher: Publisher {
        return sender.eraseToAnyPublisher()
    }
    
    /**
     *  Create an associated receiver understanding a given integer signal.
     */
    public func receiver(for index: Index) -> Receiver {
        return publisher
            .filter { $0 == index }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Create an associated receiver understanding a given hashable signal.
     */
    public func receiver<T>(for t: T) -> Receiver where T: Hashable {
        return receiver(for: t.hashValue)
    }
    
    /**
     *  Send an integer signal. Receivers understanding it will respond by emitting a void value.
     */
    public func signal(_ index: Index) {
        sender.send(index)
    }
    
    /**
     *  Send a hashable signal. Receivers understanding it will respond by emitting a void value.
     */
    public func signal<T>(_ t: T) where T: Hashable {
        signal(t.hashValue)
    }
    
    /**
     *  Cereate a triggerable understanding a given integer signal emitted by the trigger.
     */
    public func triggerable(with index: Index) -> Triggerable {
        return Triggerable(for: self, index: index)
    }
    
    /**
     *  Cereate a triggerable understanding a given hashable signal emitted by the trigger.
     */
    public func triggerable<T>(with t: T) -> Triggerable where T: Hashable {
        return Triggerable(for: self, index: t.hashValue)
    }
}

/**
 *  Context for creating triggerable publishers.
 */
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Triggerable {
    private let trigger: Trigger
    private let index: Trigger.Index
    
    /**
     *  Create a triggerable understanding the given integer signal when sent from the specified trigger.
     */
    init(for trigger: Trigger, index: Trigger.Index) {
        self.trigger = trigger
        self.index = index
    }
    
    /**
     *  Return the associated receiver publisher emitting void values when triggered.
     */
    public func receiver() -> Trigger.Receiver {
        return trigger.receiver(for: index)
    }
}

#endif
