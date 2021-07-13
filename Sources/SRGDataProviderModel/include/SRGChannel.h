//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChannelIdentifierMetadata.h"
#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGProgram.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Channel (TV, radio or online).
 */
@interface SRGChannel : SRGModel <SRGChannelIdentifierMetadata, SRGImageMetadata, SRGMetadata>

/**
 *  The URL at which the schedule can be retrieved.
 */
@property (nonatomic, readonly, nullable) NSURL *timetableURL;

/**
 *  Information about the program currently on air.
 */
@property (nonatomic, readonly, nullable) SRGProgram *currentProgram;

/**
 *  Information about the next program to be on air.
 */
@property (nonatomic, readonly, nullable) SRGProgram *nextProgram;

/**
 *  The presenter information.
 */
@property (nonatomic, readonly, nullable) SRGPresenter *presenter;

@end

NS_ASSUME_NONNULL_END
