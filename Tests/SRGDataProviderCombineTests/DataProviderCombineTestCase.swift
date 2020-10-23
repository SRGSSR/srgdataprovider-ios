//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

@testable import SRGDataProviderCombine
import XCTest

enum TestError: Error {
    case missingData
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class DataProviderCombineTestCase: XCTestCase {
    var dataProvider: SRGDataProvider!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        dataProvider = SRGDataProvider(serviceURL: SRGIntegrationLayerProductionServiceURL())
        cancellables = []
    }
    
    func testTVChannels() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvChannels(for: .RTS)
            .sink { completion in
                requestExpectation.fulfill()
            } receiveValue: { value in
                XCTAssertNotNil(value.channels)
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testParallelRequests() {
        let requestExpectation1 = expectation(description: "Request 1 finished")
        
        var nextPage: SRGDataProvider.TVLatestMedias.Page?
        dataProvider.tvLatestMedias(for: .RTS)
            .sink { completion in
                requestExpectation1.fulfill()
            } receiveValue: { result in
                nextPage = result.nextPage
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
        XCTAssertNotNil(nextPage)
        
        let requestExpectation2 = expectation(description: "Request 2 finished")
        
        dataProvider.tvLatestMedias(at: nextPage!)
            .sink { completion in
                requestExpectation2.fulfill()
            } receiveValue: { value in
                XCTAssertNotNil(value.medias)
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testNestedRequests() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvTopics(for: .RTS)
            .tryMap { topics, response -> (SRGTopic, URLResponse) in
                if let firstTopic = topics.first {
                    return (firstTopic, response)
                }
                else {
                    throw TestError.missingData
                }
            }
            .flatMap { topic, response in
                return self.dataProvider.latestMediasForTopic(withUrn: topic.urn)
            }
            .sink { completion in
                requestExpectation.fulfill()
            } receiveValue: { value in
                XCTAssertNotNil(value.medias)
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
