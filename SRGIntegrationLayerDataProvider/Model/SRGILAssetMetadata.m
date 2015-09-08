//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
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
