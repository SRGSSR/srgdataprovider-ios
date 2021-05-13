//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Foundation

/**
 *  Trigger for publishers waiting for a signal to continue their processing.
 */
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Trigger {
    let subject = PassthroughSubject<Void, Never>()
    
    public init() {}
    
    /**
     *  Tell the associated publisher to continue its processing.
     */
    public func pull() {
        subject.send(())
    }
}

#endif
