//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMetadata.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGRelatedContent : MTLModel <SRGMetadata, MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
