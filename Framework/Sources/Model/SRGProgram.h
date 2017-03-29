//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGPresenter.h"
#import "SRGShow.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Program information (information about what is currently on air or what will be).
 */
@interface SRGProgram : SRGModel <SRGImageMetadata, SRGMetadata>

/**
 *  The date at which the content starts or started.
 */
@property (nonatomic, readonly) NSDate *startDate;

/**
 *  The date at which the content ends.
 */
@property (nonatomic, readonly) NSDate *endDate;

/**
 *  A URL page associated with the content.
 */
@property (nonatomic, readonly, nullable) NSURL *URL;

/**
 *  The show to which the content belongs.
 */
@property (nonatomic, readonly, nullable) SRGShow *show;

/**
 *  The presenter information.
 */
@property (nonatomic, readonly, nullable) SRGPresenter *presenter;

@end

NS_ASSUME_NONNULL_END
