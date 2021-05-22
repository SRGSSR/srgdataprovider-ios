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
                requestExpectation.fulfill()
            }, receiveValue: { medias in
                print("\(medias)")
                XCTAssertNotNil(medias)
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
            .map { topic in
                return self.dataProvider.latestMediasForTopic(withUrn: topic.urn)
            }
            .switchToLatest()
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
    
    func testExhaustiveRequest() {
        let requestExpectation = expectation(description: "Request finished")
        
        let trigger = Trigger()
        
        let urns = ["urn:rts:show:tv:9517680", "urn:rts:show:tv:1799609", "urn:rts:show:tv:11178126", "urn:rts:show:tv:9720862", "urn:rts:show:tv:548307", "urn:rts:show:tv:10875381", "urn:rts:show:tv:11511172", "urn:rts:show:tv:11340592", "urn:rts:show:tv:11430664"]
        dataProvider.shows(withUrns: urns, pageSize: 3, triggeredBy: trigger.triggerable(with: 1))
            .handleEvents(receiveOutput: { _ in
                // TODO: Workaround. Can we do better?
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    trigger.signal(1)
                }
            })
            .scan([]) { $0 + $1 }
            .sink { completion in
                print("Completion: \(completion)")
                requestExpectation.fulfill()
            } receiveValue: { shows in
                print("Received \(shows.count): \(shows.map(\.title))")
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    // TODO: Should test Triggers and associated publisher operators
}
