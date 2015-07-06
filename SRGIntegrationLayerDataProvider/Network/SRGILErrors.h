//
//  SRGErrors.h
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILDataProviderConstants.h"

NSError *SRGILCreateUserFacingError(NSString *failureReason, NSError *underlyingError, enum SRGILDataProviderErrorCode errorCode);
