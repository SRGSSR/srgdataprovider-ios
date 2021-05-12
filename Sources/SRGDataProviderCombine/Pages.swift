//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import SRGDataProvider

@_implementationOnly import SRGDataProviderRequests

protocol NextLinkable {
    var request: URLRequest { get }
    func next(with request: URLRequest?) -> Self?
}

extension SRGDataProvider {
    /**
     *  Ensure correct page values in the expected range.
     */
    static func clampedSize(size: UInt) -> UInt {
        if size > SRGDataProviderMaximumPageSize && size != SRGDataProviderUnlimitedPageSize {
            return SRGDataProviderMaximumPageSize;
        }
        else {
            return size
        }
    }
    
    /**
     *  Describes a page of content.
     */
    public struct Page: NextLinkable {
        /// The request associated with the page.
        let request: URLRequest
        
        /// The size of the page.
        public let size: UInt
        
        /// The page number.
        public let number: UInt
        
        /**
         *  Create the first page.
         */
        init(request: URLRequest, size: UInt) {
            func updatedRequest(from request: URLRequest, with url: URL) -> URLRequest {
                var updatedRequest = request
                updatedRequest.url = url
                return updatedRequest
            }
            
            func urlRequest(_ request: URLRequest, withSize size: UInt) -> URLRequest {
                guard let url = request.url,
                      var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                    return request
                }
                
#warning("Workaround until the Integration Layer supports pagination for PAC section requests")
                if components.path.components(separatedBy: "/").contains("section") {
                    return request
                }
                
                var queryItems = components.queryItems ?? []
                let pageSize = (size != SRGDataProviderUnlimitedPageSize) ? String(size) : "unlimited"
                queryItems.append(URLQueryItem(name: "pageSize", value: pageSize))
                components.queryItems = queryItems
                
                guard let fullUrl = components.url else { return request }
                return updatedRequest(from: request, with: fullUrl)
            }
            
            let pageSize = SRGDataProvider.clampedSize(size: size)
            self.init(request: urlRequest(request, withSize: pageSize), size: pageSize, number: 0)
        }
        
        /**
         *  Create an arbitrary page.
         */
        private init(request: URLRequest, size: UInt, number: UInt) {
            self.request = request
            self.size = size
            self.number = number
        }
        
        /**
         *  Generate the next page for the receiver, associating the provided request with it.
         */
        func next(with request: URLRequest?) -> Page? {
            if let request = request {
                return Page(request: request, size: size, number: number + 1)
            }
            else {
                return nil
            }
        }
    }
    
    /**
     *  Describes a page of URNs built client-side.
     */
    public struct URNPage: NextLinkable {
        /// The original unpaginated request.
        private let originalRequest: URLRequest
        
        /// The page request.
        let request: URLRequest
        
        /// The query parameter under which a comma-separated list of URNs is available in the request.
        let queryParameter: String
        
        /// The size of the page.
        public let size: UInt
        
        /// The page number.
        public let number: UInt
        
        /**
         *  Create the first page.
         */
        init(originalRequest: URLRequest, queryParameter: String, size: UInt) {
            let request = SRGDataProvider.urlRequestForURNsPage(withSize: size, number: 0, urlRequest: originalRequest, queryParameter: queryParameter) ?? originalRequest
            self.init(originalRequest: originalRequest, request: request, queryParameter: queryParameter, size: size, number: 0)
        }
        
        /**
         *  Create an arbitrary page.
         */
        private init(originalRequest: URLRequest, request: URLRequest, queryParameter: String, size: UInt, number: UInt) {
            self.originalRequest = originalRequest
            self.request = request
            self.queryParameter = queryParameter
            self.size = size
            self.number = number
        }
        
        /**
         *  Generate the next page for the receiver.
         */
        func next(with request: URLRequest?) -> URNPage? {
            let nextNumber = number + 1
            if let request = SRGDataProvider.urlRequestForURNsPage(withSize: size, number: nextNumber, urlRequest: originalRequest, queryParameter: queryParameter) {
                return URNPage(originalRequest: originalRequest, request: request, queryParameter: queryParameter, size: size, number: nextNumber)
            }
            else {
                return nil
            }
        }
    }
}

extension SRGDataProvider.Page: CustomStringConvertible {
    public var description: String {
        return "Page \(number) (size \(size)): \(request.url!)"
    }
}

extension SRGDataProvider.URNPage: CustomStringConvertible {
    public var description: String {
        return "Page \(number) (size \(size)): \(request.url!)"
    }
}
