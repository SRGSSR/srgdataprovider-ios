//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTopic.h"

@interface SRGTopic ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;

@end

@implementation SRGTopic

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{ @"uid" : @"id",
                     @"title" : @"title" };
    });
    return mapping;
}

@end
