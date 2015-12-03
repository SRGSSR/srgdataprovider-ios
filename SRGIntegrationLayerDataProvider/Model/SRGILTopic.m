//
//  SRGILTopic.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 03/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import "SRGILTopic.h"

@implementation SRGILTopic

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _title = dictionary[@"title"];
        _lead = dictionary[@"lead"];
        _topicDescription = dictionary[@"description"];
    }
    return self;
}

@end
