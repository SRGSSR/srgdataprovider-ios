//
//  SRGAssetMetadata.m
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILAssetMetadata.h"

@interface SRGILAssetMetadata ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *assetDescription;
@end

@implementation SRGILAssetMetadata

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _title = [dictionary objectForKey:@"title"];
        _assetDescription = [dictionary objectForKey:@"description"];
        _assetIdentifer = [dictionary objectForKey:@"assetId"];
    }
    return self;
}

@end
