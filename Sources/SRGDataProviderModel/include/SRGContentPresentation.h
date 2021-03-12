//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describes how content must be presented on screen.
 */
@interface SRGContentPresentation : SRGModel

/**
 *  The presentation type.
 */
@property (nonatomic, readonly) SRGContentPresentationType type;

/**
 *  The title to be displayed alongside the content.
 */
@property (nonatomic, readonly, copy, nullable) NSString *title;

/**
 *  Short label associated with the content.
 */
@property (nonatomic, readonly, copy, nullable) NSString *label;

/**
 *  `YES` iff a detail page is available for the content.
 */
@property (nonatomic, readonly) BOOL hasDetailPage;

@end

NS_ASSUME_NONNULL_END
