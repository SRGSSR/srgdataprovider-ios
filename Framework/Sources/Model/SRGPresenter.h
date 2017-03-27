//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGModel.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Show presenter information.
 */
@interface SRGPresenter : SRGModel <SRGImageMetadata>

/**
 *  The name of the presenter.
 */
@property (nonatomic, readonly, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
