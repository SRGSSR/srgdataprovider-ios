//
//  SRGILArtist.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 03/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import "SRGILModelObject.h"

@interface SRGILArtist : SRGILModelObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSDate *modifiedDate;
@property(nonatomic, strong) NSDate *createdDate;

@end
