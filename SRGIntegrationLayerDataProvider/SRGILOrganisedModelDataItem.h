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

@property(nonatomic, copy) id<NSCopying> tag;
@property(nonatomic, strong) SRGILList *items;
@property(nonatomic, strong) Class itemClass;

+ (SRGILOrganisedModelDataItem *)dataItemForTag:(id<NSCopying>)tag
                                      withItems:(NSArray *)items
                                          class:(Class)itemClass
                                     properties:(NSDictionary *)props;

@end
