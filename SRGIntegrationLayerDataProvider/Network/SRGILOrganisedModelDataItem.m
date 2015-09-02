//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILOrganisedModelDataItem.h"

@implementation SRGILOrganisedModelDataItem

+ (SRGILOrganisedModelDataItem *)dataItemForTag:(id<NSCopying>)tag
                                      withItems:(NSArray *)items
                                          class:(Class)itemClass
                                     properties:(NSDictionary *)props
{
    SRGILOrganisedModelDataItem *dataItem = [[SRGILOrganisedModelDataItem alloc] init];
    dataItem.items = [[SRGILList alloc] initWithArray:items];
    dataItem.items.globalProperties = props;
    dataItem.items.tag = tag;
    return dataItem;
}

@end

