//
//  SRGILOrganisedModelDataItem.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 02/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILOrganisedModelDataItem.h"

@implementation SRGILOrganisedModelDataItem

+ (SRGILOrganisedModelDataItem *)dataItemForTag:(id<NSCopying>)tag
                                      withItems:(NSArray *)items
                                          class:(Class)itemClass
                                     properties:(NSDictionary *)props
{
    SRGILOrganisedModelDataItem *dataItem = [[SRGILOrganisedModelDataItem alloc] init];
    dataItem.tag = tag;
    dataItem.items = [[SRGILList alloc] initWithArray:items];
    dataItem.items.globalProperties = props;
    return dataItem;
}

@end

