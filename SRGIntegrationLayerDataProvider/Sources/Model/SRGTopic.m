//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTopic.h"

@implementation SRGTopic

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"id": @"uid",
                                                        @"title" : @"title" }];
}

@end
