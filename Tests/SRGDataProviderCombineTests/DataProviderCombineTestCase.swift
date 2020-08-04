//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import Combine
import SRGDataProvider
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
        dataProvider = SRGDataProvider(serviceURL: SRGIntegrationLayerProductionServiceURL())
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
                print("Channels: \(result.channels)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTvChannel() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvChannel(for: .RTS, withUid: "143932a79bb5a123a646b68b1d1188d7ae493e5b")
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { result in
                print("Channel: \(result.channel)")
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
                print("Latest medias: \(result.medias)")
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
                print("Latest medias: \(result.medias)")
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
            .flatMap { topic, response -> AnyPublisher<(medias: [SRGMedia], response: URLResponse), Error> in
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
            print("Latest medias for first topic: \(result.medias)")
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
