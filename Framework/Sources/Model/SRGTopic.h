//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGBaseTopic.h"
#import "SRGSubTopic.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Topic (e.g. sports, kids, etc.) information.
 */
@interface SRGTopic : SRGBaseTopic

/**
 *  The sub topic list.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGSubTopic *> *subTopics;

@end

NS_ASSUME_NONNULL_END
