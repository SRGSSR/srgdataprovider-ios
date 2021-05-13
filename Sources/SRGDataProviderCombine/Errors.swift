//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

/**
 *  Errors possibly emitted by the data provider.
 */
public enum SRGDataProviderError: LocalizedError {
    /// HTTP error.
    case http(statusCode: Int)
    /// Invalid data (missing or parsing error).
    case invalidData
    
    public var errorDescription: String? {
        switch self {
        case let .http(statusCode: statusCode):
            return HTTPURLResponse.fixedLocalizedString(forStatusCode: statusCode)
        case .invalidData:
            return NSError(domain: NSCocoaErrorDomain, code: NSFileReadUnknownError, userInfo: nil).localizedDescription
        }
    }
}

private extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

private extension HTTPURLResponse {
    static func fixedLocalizedString(forStatusCode statusCode: Int) -> String {
        // The `localizedString(forStatusCode:)` method always returns the English version, which we use as localization key
        let key = localizedString(forStatusCode: statusCode)
        if let description = Bundle(identifier: "com.apple.CFNetwork")?.localizedString(forKey: key, value: nil, table: nil) {
            return description.capitalizingFirstLetter()
        }
        else {
            return "Unknown error"
        }
    }
}
