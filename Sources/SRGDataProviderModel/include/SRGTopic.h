//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGBaseTopic.h"
#import "SRGSubtopic.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Topic (e.g. sports, kids, etc.) information.
 */
@interface SRGTopic : SRGBaseTopic

/**
 *  The subtopic list.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSubtopic *> *subtopics;

@end

NS_ASSUME_NONNULL_END
