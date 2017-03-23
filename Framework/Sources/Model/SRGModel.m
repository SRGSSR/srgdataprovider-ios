//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

@implementation SRGModel

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Subclasses of SRGModel must implement -JSONKeyPathsByPropertyKey:"
                                 userInfo:nil];
}

@end
