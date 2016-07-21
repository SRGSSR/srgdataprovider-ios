//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGPresenter : MTLModel <SRGImageMetadata, MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
