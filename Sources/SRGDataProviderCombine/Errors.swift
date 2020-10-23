//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

/**
 *  Errors possibly emitted by the data provider.
 */
public enum SRGDataProviderError: Error {
    /// HTTP error.
    case http(statusCode: Int)
    /// Invalid data (missing or parsing error).
    case invalidData
}
