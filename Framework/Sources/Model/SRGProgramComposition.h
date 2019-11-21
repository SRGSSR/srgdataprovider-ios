//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChannel.h"
#import "SRGModel.h"
#import "SRGProgram.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  List of programs for a channel.
 */
@interface SRGProgramComposition : SRGModel

/**
 *  The channel which the programs belong to.
 */
@property (nonatomic, readonly, nullable) SRGChannel *channel;

/**
 *  The list of programs.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGProgram *> *programs;

@end

NS_ASSUME_NONNULL_END
