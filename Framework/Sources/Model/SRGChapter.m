//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChapter.h"

@implementation SRGChapter

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *mutableMapping = [[super JSONKeyPathsByPropertyKey] mutableCopy];
        [mutableMapping addEntriesFromDictionary:@{ @"position" : @"position",
                                                    @"markIn" : @"markIn",
                                                    @"markOut" : @"markOut",
                                                    @"eventInformation" : @"eventData" }];
        mapping = [mutableMapping copy];
    });
    return mapping;
}

@end
