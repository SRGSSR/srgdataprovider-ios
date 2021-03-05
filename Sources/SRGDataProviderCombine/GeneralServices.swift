//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  General services supported by the data provider.
 */

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum ServiceMessage {
        public typealias Output = (message: SRGServiceMessage, response: URLResponse)
    }
    
    /**
     *  Retrieve a message from the service about its status, if there is currently one. If none is available, the
     *  call ends with an HTTP error.
     */
    func serviceMessage(for vendor: SRGVendor) -> AnyPublisher<ServiceMessage.Output, Error> {
        let request = requestServiceMessage(for: vendor)
        return objectTaskPublisher(for: request, type: SRGServiceMessage.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

#endif
