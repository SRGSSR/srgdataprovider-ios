//
//  SRGILDownload.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 25/08/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILModelObject.h"
#import "SRGILModelConstants.h"

@interface SRGILDownload : SRGILModelObject

@property(nonatomic, assign, readonly) SRGILDownloadProtocol protocol;

- (NSURL *)URLForQuality:(SRGILDownloadURLQuality)quality;

@end
