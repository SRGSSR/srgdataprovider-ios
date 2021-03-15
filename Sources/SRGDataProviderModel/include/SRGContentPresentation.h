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
 *  The description to be displayed alongside the content.
 */
@property (nonatomic, readonly, copy, nullable) NSString *summary;

/**
 *  Short label associated with the content.
 */
@property (nonatomic, readonly, copy, nullable) NSString *label;

/**
 *  `YES` iff a detail page should be made available for the content.
 */
@property (nonatomic, readonly) BOOL hasDetailPage;

/**
 *  `YES` if the content is randomized.
 */
@property (nonatomic, readonly, getter=isRandomized) BOOL randomized;

@end

NS_ASSUME_NONNULL_END
