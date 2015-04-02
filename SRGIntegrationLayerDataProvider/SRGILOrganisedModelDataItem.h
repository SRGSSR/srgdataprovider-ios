//
//  SRGILOrganisedModelDataItem.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 02/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILList.h"

@interface SRGILOrganisedModelDataItem : NSObject

@property(nonatomic, strong) id<NSCopying>tag;
@property(nonatomic, strong) SRGILList *items;

+ (SRGILOrganisedModelDataItem *)dataItemWithTag:(id<NSCopying>)tag items:(NSArray *)items properties:(NSDictionary *)props;

@end
