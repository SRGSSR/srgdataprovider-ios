//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILModelObject.h"
#import "SRGILModelConstants.h"

@interface SRGILDownload : SRGILModelObject

@property(nonatomic, assign, readonly) SRGILDownloadProtocol protocol;

- (nullable NSURL *)URLForQuality:(SRGILDownloadURLQuality)quality;

@end
