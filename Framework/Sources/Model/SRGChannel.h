//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGModel.h"
#import "SRGProgram.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Channel (TV, radio or online).
 */
@interface SRGChannel : SRGModel <SRGImageMetadata, SRGMetadata>

/**
 *  The unique channel identifier.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  Describes whether the channel is a TV, radio or online channel.
 */
@property (nonatomic, readonly) SRGTransmission transmission;

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

@end

NS_ASSUME_NONNULL_END
