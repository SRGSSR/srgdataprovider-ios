//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGEntry.h"

@interface SRGEntry ()

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

@end

@implementation SRGEntry

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @"key" : @"key",
                       @"value" : @"value" };
    });
    return s_mapping;
}

@end
