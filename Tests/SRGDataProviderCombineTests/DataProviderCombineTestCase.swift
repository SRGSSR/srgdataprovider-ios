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
    
    func testSingleObjectRequest() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.radioCurrentSong(for: .RTS, channelUid: "a9e7621504c6959e35c3ecbe7f6bed0446cdf8da")
            .sink(receiveCompletion: { completion in
                requestExpectation.fulfill()
            }, receiveValue: { song in
                print("\(song)")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testRequest() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvChannels(for: .RTS)
            .sink(receiveCompletion: { _ in
                // No pagination, pipeline ends with the first result received
                requestExpectation.fulfill()
            }, receiveValue: { medias in
                print("\(medias)")
                XCTAssertNotNil(medias)
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testPaginatedRequest() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.latestMediasForShow(withUrn: "urn:rts:show:tv:532539")
            .sink(receiveCompletion: { _ in
                // Nothing
            }, receiveValue: { medias in
                print("\(medias)")
                XCTAssertNotNil(medias)
                
                // Pipeline stays open unless pages are exhausted. Fulfills after receiving the first value
                requestExpectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testNestedRequests() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvTopics(for: .RTS)
            .tryMap { topics -> SRGTopic in
                if let firstTopic = topics.first {
                    return firstTopic
                }
                else {
                    throw TestError.missingData
                }
            }
            .flatMap { topic in
                return self.dataProvider.latestMediasForTopic(withUrn: topic.urn)
            }
            .sink(receiveCompletion: { _ in
                // Nothing
            }, receiveValue: { medias in
                print("\(medias)")
                XCTAssertNotNil(medias)
                
                // Pipeline stays open unless pages are exhausted. Fulfills after receiving the first value
                requestExpectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
