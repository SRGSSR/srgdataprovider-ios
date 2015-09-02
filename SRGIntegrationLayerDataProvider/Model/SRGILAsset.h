//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"

@class SRGILMedia;

@interface SRGILAsset : SRGILModelObject

@property(nonatomic, strong, nullable) NSString *title;
@property(nonatomic, strong, nullable) SRGILMedia *fullLengthMedia;
@property(nonatomic, strong, nullable) NSArray *mediaSegments;

- (void)reloadWithFullLengthMedia:(nonnull SRGILMedia *)media;

@end
