//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILModelConstants.h"

@interface SRGILURN : NSObject

@property(nonatomic, strong, readonly) NSString *prefix;
@property(nonatomic, strong, readonly) NSString *businessUnit;
@property(nonatomic, assign, readonly) SRGILMediaType mediaType;
@property(nonatomic, strong, readonly) NSString *identifier;

+ (SRGILURN *)URNWithString:(NSString *)urnString;
+ (NSString *)identifierForURNString:(NSString *)urnString;

@end
