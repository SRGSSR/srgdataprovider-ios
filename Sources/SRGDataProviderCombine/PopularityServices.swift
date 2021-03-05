//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#if canImport(Combine)  // TODO: Can be removed once iOS 11 is the minimum target declared in the package manifest.

import Combine

/**
 *  List of services for popularity measurements supported by the data provider.
 */

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum IncreaseSocialCount {
        public typealias Output = (overview: SRGSocialCountOverview, response: URLResponse)
    }
    
    /**
     *  Increase the specified social count from 1 unit for the specified URN, with the corresponding event data
     *  (see `SRGSubdivision` class).
     */
    func increaseSocialCount(for type: SRGSocialCountType, urn: String, event: String) -> AnyPublisher<IncreaseSocialCount.Output, Error> {
        let request = requestIncreaseSocialCount(for: type, urn: urn, event: event)
        return objectTaskPublisher(for: request, type: SRGSocialCountOverview.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SRGDataProvider {
    enum IncreaseShowSearchResultsViewCount {
        public typealias Output = (overview: SRGShowStatisticsOverview, response: URLResponse)
    }
    
    /**
     *  Increase the number of times a show has been viewed from search results.
     */
    func increaseSearchResultsViewCount(for show: SRGShow) -> AnyPublisher<IncreaseShowSearchResultsViewCount.Output, Error> {
        let request = requestIncreaseSearchResultsViewCount(for: show)
        return objectTaskPublisher(for: request, type: SRGShowStatisticsOverview.self)
            .map { $0 }
            .eraseToAnyPublisher()
    }
}

#endif
