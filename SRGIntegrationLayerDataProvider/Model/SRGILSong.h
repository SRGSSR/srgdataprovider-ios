//
//  SRGILSong.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 03/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import "SRGILModelObject.h"

@class SRGILArtist;

@interface SRGILSong : SRGILModelObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSDate *modifiedDate;
@property(nonatomic, strong) NSDate *createdDate;
@property(nonatomic, strong) SRGILArtist *artist;

@end
