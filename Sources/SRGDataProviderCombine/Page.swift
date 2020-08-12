//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

import SRGDataProvider

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension SRGDataProvider {
    /**
     *  Describes a page of content.
     *
     *  Uses generics to have a different page type associated with each kind of request, so that pages generated
     *  by some kind of request cannot be used with another kind of request.
     */
    public struct Page<T> {
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
            func clampedSize(size: UInt) -> UInt {
                if size > SRGDataProviderMaximumPageSize && size != SRGDataProviderUnlimitedPageSize {
                    return SRGDataProviderMaximumPageSize;
                }
                else {
                    return size
                }
            }
            
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
                
                var queryItems = components.queryItems ?? []
                let pageSize = (size != SRGDataProviderUnlimitedPageSize) ? String(size) : "unlimited"
                queryItems.append(URLQueryItem(name: "pageSize", value: pageSize))
                components.queryItems = queryItems
                
                guard let fullUrl = components.url else { return request }
                return updatedRequest(from: request, with: fullUrl)
            }
            
            let pageSize = clampedSize(size: size)
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
        func next(with request: URLRequest?) -> Page<T>? {
            if let request = request {
                return Page(request: request, size: size, number: number + 1)
            }
            else {
                return nil
            }
        }
    }
}
