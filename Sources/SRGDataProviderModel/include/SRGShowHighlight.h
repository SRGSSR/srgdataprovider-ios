//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMedia.h"
#import "SRGModel.h"
#import "SRGShow.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Show highlight (show with associated media list).
 */
@interface SRGShowHighlight : SRGModel

/**
 *  The show.
 */
@property (nonatomic, readonly, nullable) SRGShow *show;

/**
 *  The associated media list.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGMedia *> *medias;

@end

NS_ASSUME_NONNULL_END
