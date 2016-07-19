//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChapter.h"

@interface SRGChapter ()

@property (nonatomic) NSInteger position;
@property (nonatomic) NSTimeInterval markIn;
@property (nonatomic) NSTimeInterval markOut;

@property (nonatomic) NSArray<SRGResource *> *resources;

@end

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
                                                    @"resources" : @"resourceList" }];
        mapping = [mutableMapping copy];
    });
    return mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)resourcesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGResource class]];
}

@end
