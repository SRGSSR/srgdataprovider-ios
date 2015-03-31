//
//  SRGAsset.h
//  SRFPlayer
//
//  Created by Cédric Foellmi on 28/08/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
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
