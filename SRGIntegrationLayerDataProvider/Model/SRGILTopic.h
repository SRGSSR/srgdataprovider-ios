//
//  SRGILTopic.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 03/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import "SRGILModelObject.h"

@interface SRGILTopic : SRGILModelObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *lead;
@property(nonatomic, strong) NSString *topicDescription;

@end
