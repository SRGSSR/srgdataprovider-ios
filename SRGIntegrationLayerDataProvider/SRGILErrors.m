//
//  SRGErrors.m
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "SRGILErrors.h"

NSString *const SRGErrorDomain = @"ch.srgssr.integrationlayer";

//NSError *SRGCreateUserFacingError(NSString *failureReason, NSError *underlyingError, enum SRGILErrorCode errorCode)
//{
//    NSMutableDictionary *errorInfo = [NSMutableDictionary dictionary];
//    [errorInfo setObject:NSLocalizedString(@"GENERIC_ERROR_MESSAGE", nil) forKey:NSLocalizedDescriptionKey];
//    if (failureReason) {
//        [errorInfo setObject:failureReason forKey:NSLocalizedFailureReasonErrorKey];
//    }
//    if (underlyingError) {
//        [errorInfo setObject:underlyingError forKey:NSUnderlyingErrorKey];
//        if (errorCode == SRGILErrorCodeInvalidData &&
//                [[underlyingError domain] isEqualToString:AFNetworkingErrorDomain]) {
//            errorCode = [(NSHTTPURLResponse*)([underlyingError userInfo][@"AFNetworkingOperationFailingURLResponseErrorKey"]) statusCode];
//
//        }
//    }
//    
//    NSError *newError = [NSError errorWithDomain:SRGErrorDomain code:errorCode userInfo:errorInfo];
//    return newError;
//}
