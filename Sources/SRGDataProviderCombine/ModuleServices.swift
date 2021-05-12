//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  Module services (e.g. events) supported by the data provider.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  List modules for a specific type (e.g. events).
     *
     *  - Parameter moduleType: A specific module type.
     */
    func modules(for vendor: SRGVendor, type: SRGModuleType) -> AnyPublisher<[SRGModule], Error> {
        let request = requestModules(for: vendor, type: type)
        return objectsPublisher(for: request, rootKey: "moduleConfigList", type: SRGModule.self)
            .map { $0.objects }
            .eraseToAnyPublisher()
    }
}

#endif
