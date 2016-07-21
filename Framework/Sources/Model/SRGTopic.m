//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTopic.h"

@interface SRGTopic ()

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@end

@implementation SRGTopic

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @"uid" : @"id",
                       
                       @"title" : @"title",
                       @"lead" : @"lead",
                       @"summary" : @"description" };
    });
    return s_mapping;
}

@end
