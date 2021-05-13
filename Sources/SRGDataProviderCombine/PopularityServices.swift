//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  Services for popularity measurements.
 */
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    /**
     *  Increase the specified social count of 1 unit for the specified URN, with the corresponding opaque event
     *  information (see `SRGSubdivision` class).
     */
    func increaseSocialCount(for type: SRGSocialCountType, urn: String, event: String) -> AnyPublisher<SRGSocialCountOverview, Error> {
        let request = requestIncreaseSocialCount(for: type, urn: urn, event: event)
        return objectPublisher(for: request, type: SRGSocialCountOverview.self)
    }
    
    /**
     *  Increase the number of times a show has been viewed from search results.
     */
    func increaseSearchResultsViewCount(for show: SRGShow) -> AnyPublisher<SRGShowStatisticsOverview, Error> {
        let request = requestIncreaseSearchResultsViewCount(for: show)
        return objectPublisher(for: request, type: SRGShowStatisticsOverview.self)
    }
}

#endif
