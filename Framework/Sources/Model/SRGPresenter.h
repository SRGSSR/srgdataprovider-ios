//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Presenter (of a show)
 */
@interface SRGPresenter : MTLModel <SRGImageMetadata, MTLJSONSerializing>

/**
 *  The name of the presenter
 */
@property (nonatomic, readonly, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
