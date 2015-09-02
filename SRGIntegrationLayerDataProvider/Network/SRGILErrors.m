//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILErrors.h"

NSError *SRGILCreateUserFacingError(NSString *failureReason, NSError *underlyingError, enum SRGILDataProviderErrorCode errorCode)
{
    NSMutableDictionary *errorInfo = [NSMutableDictionary dictionary];
    
    [errorInfo setObject:NSLocalizedString(@"GENERIC_ERROR_MESSAGE", nil) forKey:NSLocalizedDescriptionKey];
    if (failureReason) {
        [errorInfo setObject:failureReason forKey:NSLocalizedFailureReasonErrorKey];
    }
    
    if (underlyingError) {
        [errorInfo setObject:underlyingError forKey:NSUnderlyingErrorKey];
    }
    
    NSError *newError = [NSError errorWithDomain:SRGILDataProviderErrorDomain code:errorCode userInfo:errorInfo];
    return newError;
}
