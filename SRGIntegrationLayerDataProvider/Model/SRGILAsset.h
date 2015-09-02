//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"

@class SRGILMedia;

@interface SRGILAsset : SRGILModelObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) SRGILMedia *fullLengthMedia;
@property(nonatomic, strong) NSArray *mediaSegments;

- (void)reloadWithFullLengthMedia:(SRGILMedia *)media;

@end
