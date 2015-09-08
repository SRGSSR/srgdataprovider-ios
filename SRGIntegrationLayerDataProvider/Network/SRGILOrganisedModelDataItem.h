//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILList.h"

@interface SRGILOrganisedModelDataItem : NSObject

@property(nonatomic, strong) SRGILList *items;
@property(nonatomic, strong) Class itemClass;

+ (SRGILOrganisedModelDataItem *)dataItemForTag:(id<NSCopying>)tag
                                      withItems:(NSArray *)items
                                          class:(Class)itemClass
                                     properties:(NSDictionary *)props;

@end
