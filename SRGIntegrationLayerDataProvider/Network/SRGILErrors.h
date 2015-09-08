//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILDataProviderConstants.h"

NSError *SRGILCreateUserFacingError(NSString *failureReason, NSError *underlyingError, enum SRGILDataProviderErrorCode errorCode);
