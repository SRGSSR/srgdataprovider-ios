//
//  SRGErrors.h
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Our error codes
*
* Let's try to keep this in sync with the Android code ( ErrorCursor.java )
*
*/
typedef NS_ENUM (NSUInteger, SRGILErrorCode) {
    SRGILErrorCodeEnumBegin = 0,
    SRGILErrorCodeInvalidData = SRGILErrorCodeEnumBegin,
    SRGILErrorContentProviderWrongUri = 1,
    SRGILErrorContentProviderBadQuery = 2,
    SRGILErrorHttpIo = 3,
    SRGILErrorHttpCode = 4, /* for unknown http errors, otherwise it's always >= 100 */
    SRGILErrorJsonIo = 5,
    SRGILErrorJsonParse = 6,
    SRGILErrorJsonMalformedObject = 7,
    SRGILErrorJsonEmptyResponse = 8,
    SRGILErrorVideoNoSourceURL = 9,
    SRGILErrorVideoNoSourceURLForToken = 10,
    SRGILErrorCodeEnumEnd,
    SRGILErrorCodeEnumSize = SRGILErrorCodeEnumEnd - SRGILErrorCodeEnumBegin
};

// Domain for IL errors
extern NSString *const SRGErrorDomain;

//NSError *SRGCreateUserFacingError(NSString *failureReason, NSError *underlyingError, enum SRGILErrorCode errorCode);
