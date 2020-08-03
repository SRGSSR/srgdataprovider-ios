//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine
import SRGDataProviderModel
@testable import SRGDataProviderCombine
import XCTest

enum TestError: Error {
    case missingData
}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class SRGDataProviderCombineTests: XCTestCase {
    var dataProvider: SRGDataProvider!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        dataProvider = SRGDataProvider(serviceUrl: URL(string: "https://il.srgssr.ch/integrationlayer")!)
        cancellables = []
    }
    
    func testTvChannels() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvChannels(for: .RTS)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { result in
                print("Channels: \(result.0)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTvTrendingMedias() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvTrendingMedias(for: .RTS)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { result in
                print("Latest medias: \(result.0)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTvLatestMedias() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvLatestMedias(for: .RTS)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { result in
                print("Latest medias: \(result.0)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTvTopics() {
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
            .flatMap { topic, response -> AnyPublisher<([SRGMedia], URLResponse), Error> in
                return self.dataProvider.latestMediasForTopic(withUrn: topic.urn)
            }
            .sink { completion in
            switch completion {
                case .finished:
                    print("Done")
                case let .failure(error):
                    print("Error: \(error)")
            }
            requestExpectation.fulfill()
        } receiveValue: { result in
            print("Latest medias for first topic: \(result.0)")
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
