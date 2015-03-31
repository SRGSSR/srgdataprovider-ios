//
//  SRGAssetMetadata.h
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"

@interface SRGILAssetMetadata : SRGILModelObject

@property (nonatomic, readonly, strong) NSString *title;
@property (nonatomic, readonly, strong) NSString *assetDescription;
@property (nonatomic, readonly, strong) NSString *assetIdentifer;

@end
