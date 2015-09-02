//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"

@interface SRGILAssetMetadata : SRGILModelObject

@property (nonatomic, readonly, strong) NSString *title;
@property (nonatomic, readonly, strong) NSString *assetDescription;
@property (nonatomic, readonly, strong) NSString *assetIdentifer;

@end
