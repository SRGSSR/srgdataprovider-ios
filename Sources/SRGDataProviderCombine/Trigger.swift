//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Foundation

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Common type for triggers driving other processes (e.g. page retrieval).
     */
    typealias Trigger = AnyPublisher<Void, Never>
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider.Trigger {
    /**
     *  Active trigger which can be pulled.
     */
    static let active: PassthroughSubject<Void, Never> = {
        return PassthroughSubject<Void, Never>()
    }()
    
    /**
     *  Inactive trigger that can never be pulled.
     */
    static let inactive: SRGDataProvider.Trigger = {
        return Empty<Void, Never>(completeImmediately: false)
            .eraseToAnyPublisher()
    }()
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension PassthroughSubject where Output == Void, Failure == Never {
    /**
     *  Pull a trigger to signal to the process it controls it must perform its task.
     */
    func pull() {
        return send(())
    }
}

#endif
