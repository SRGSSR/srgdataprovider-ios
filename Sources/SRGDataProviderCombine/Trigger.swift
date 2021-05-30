//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  A trigger is a device used to control a set of signal publishers. Signal publishers are publishers remotely
 *  controlled by the trigger which emit a void value when activated. Signal publishers never complete and thus
 *  can be activated as many times as needed.
 */
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Trigger {
    public typealias Index = Int
    public typealias Signal = AnyPublisher<Void, Never>
    
    private let sender = PassthroughSubject<Index, Never>()
    
    /**
     *  Create a trigger.
     */
    public init() {}
    
    /**
     *  Create an associated signal activated by some integer index.
     */
    public func signal(activatedBy index: Index) -> Signal {
        return sender
            .filter { $0 == index }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    /**
     *  Create an associated signal activated by some hashable value.
     */
    public func signal<T>(activatedBy t: T) -> Signal where T: Hashable {
        return signal(activatedBy: t.hashValue)
    }
    
    /**
     *  Activate associated signal publishers matching the provided integer index, making them emit a single void value.
     */
    public func activate(for index: Index) {
        sender.send(index)
    }
    
    /**
     *  Activate associated signal publishers matching the provided hashable value, making them emit a single void value.
     */
    public func activate<T>(for t: T) where T: Hashable {
        activate(for: t.hashValue)
    }
    
    /**
     *  Create a triggerable activated by the specified index.
     */
    public func triggerable(activatedBy index: Index) -> Triggerable {
        return Triggerable(for: self, activatedBy: index)
    }
    
    /**
     *  Create a triggerable activated by the specified hashable value.
     */
    public func triggerable<T>(activatedBy t: T) -> Triggerable where T: Hashable {
        return Triggerable(for: self, activatedBy: t.hashValue)
    }
}

/**
 *  A triggerable contains the context needed to create a signal associated with some trigger and index.
 */
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Triggerable {
    private let trigger: Trigger
    private let index: Trigger.Index
    
    /**
     *  Create a triggerable for the specified trigger and index.
     */
    init(for trigger: Trigger, activatedBy index: Trigger.Index) {
        self.trigger = trigger
        self.index = index
    }
    
    /**
     *  Return the associated signal publisher.
     */
    public func signal() -> Trigger.Signal {
        return trigger.signal(activatedBy: index)
    }
}

#endif
