//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine
@testable import SRGDataProviderCombine
import XCTest

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class SRGDataProviderCombineTests: XCTestCase {
    var dataProvider: SRGDataProvider!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        dataProvider = SRGDataProvider(serviceUrl: URL(string: "https://il.srgssr.ch/integrationlayer")!)
        cancellables = []
    }
    
    func testExample() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvChannels(for: .RTS).sink { completion in
            switch completion {
                case .finished:
                    print("Done")
                case let .failure(error):
                    print("Error: \(error)")
            }
            requestExpectation.fulfill()
        } receiveValue: { data, response in
            
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
