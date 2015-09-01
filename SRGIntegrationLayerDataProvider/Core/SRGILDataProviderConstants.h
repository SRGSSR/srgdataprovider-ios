//
//  SRGILDataProviderConstants.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 06/07/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Our error codes
 *
 * Let's try to keep this in sync with the Android code ( ErrorCursor.java )
 *
 */
typedef NS_ENUM (NSInteger, SRGILDataProviderErrorCode) {
    SRGILDataProviderErrorCodeEnumBegin = 0,
    SRGILDataProviderErrorCodeInvalidFetchIndex = SRGILDataProviderErrorCodeEnumBegin,
    SRGILDataProviderErrorCodeInvalidPathArgument,
    SRGILDataProviderErrorCodeInvalidMediaIdentifier,
    SRGILDataProviderErrorCodeInvalidData,
    SRGILDataProviderErrorContentProviderWrongUri,
    SRGILDataProviderErrorContentProviderBadQuery,
    SRGILDataProviderErrorHttpIo,
    SRGILDataProviderErrorHttpCode, /* for unknown http errors, otherwise it's always >= 100 */
    SRGILDataProviderErrorJsonIo,
    SRGILDataProviderErrorJsonParse,
    SRGILDataProviderErrorJsonMalformedObject,
    SRGILDataProviderErrorJsonEmptyResponse,
    SRGILDataProviderErrorVideoNoSourceURL,
    SRGILDataProviderErrorVideoNoSourceURLForToken,
    SRGILDataProviderErrorCodeEnumEnd,
    SRGILDataProviderErrorCodeEnumSize = SRGILDataProviderErrorCodeEnumEnd - SRGILDataProviderErrorCodeEnumBegin
};

// Domain for IL errors
extern NSString *const SRGILDataProviderErrorDomain;
