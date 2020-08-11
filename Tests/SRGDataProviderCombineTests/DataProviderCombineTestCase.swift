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
final class SRGDataProviderCombineTests: XCTestCase {
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
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { value in
                print("Result: \(value)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTVChannel() {
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
            } receiveValue: { value in
                print("Result: \(value)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTVLatestPrograms() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvLatestPrograms(for: .RTS, channelUid: "143932a79bb5a123a646b68b1d1188d7ae493e5b")
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { value in
                print("Result: \(value)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTVTrendingMedias() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvTrendingMedias(for: .RTS, limit: 10, editorialLimit: 2, episodesOnly: true)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { value in
                print("Result: \(value)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTVLatestMedias() {
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
            } receiveValue: { value in
                print("Result: \(value)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTVLatestEpisodes() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvLatestEpisodes(for: .RTS)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { value in
                print("Result: \(value)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTVEpisodes() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvEpisodes(for: .RTS, day: SRGDay(10, month: 6, year: 2020), pageSize: 30)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { value in
                print("Result: \(value)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTVShows() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvShows(for: .RTS)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { value in
                print("Result: \(value)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTVSearchShows() {
        let requestExpectation = expectation(description: "Request finished")
        
        dataProvider.tvShows(for: .RTS, matchingQuery: "journal")
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { value in
                print("Result: \(value)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testPagesNested() {
        // Use flat map to send next request and consolidate both result lists
    }
    
    func testPagesNonNested() {
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
                print("Result: \(value)")
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testMediasMatchingQuery() {
        let requestExpectation = expectation(description: "Request finished")
        
        let settings = SRGMediaSearchSettings()
        settings.suggestionsEnabled = true
        
        dataProvider.medias(for: .RTS, matchingQuery: "fedberer", with: settings)
            .sink { completion in
                switch completion {
                    case .finished:
                        print("Done")
                    case let .failure(error):
                        print("Error: \(error)")
                }
                requestExpectation.fulfill()
            } receiveValue: { value in
                print("Result: \(value)")
            }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testTVTopics() {
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
            switch completion {
                case .finished:
                    print("Done")
                case let .failure(error):
                    print("Error: \(error)")
            }
            requestExpectation.fulfill()
        } receiveValue: { value in
            print("Result: \(value)")
        }.store(in: &cancellables)
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
