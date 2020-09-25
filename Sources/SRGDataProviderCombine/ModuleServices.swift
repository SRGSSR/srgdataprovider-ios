//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine

/**
 *  List of module services (e.g. events) supported by the data provider.
 */

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum Modules {
        public typealias Output = (modules: [SRGModule], response: URLResponse)
    }
    
    /**
     *  List modules for a specific type (e.g. events).
     *
     *  - Parameter moduleType: A specific module type.
     */
    func modules(for vendor: SRGVendor, type: SRGModuleType) -> AnyPublisher<Modules.Output, Error> {
        let request = requestModules(for: vendor, type: type)
        return objectsTaskPublisher(for: request, rootKey: "moduleConfigList", type: SRGModule.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}
