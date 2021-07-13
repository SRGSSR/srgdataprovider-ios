//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Crew members (cast and staff).
 */
@interface SRGCrewMember : SRGModel

/**
 *  Person name.
 */
@property (nonatomic, readonly, copy) NSString *name;

/**
 *  Role.
 */
@property (nonatomic, readonly, copy, nullable) NSString *role;

/**
 *  Character name.
 */
@property (nonatomic, readonly, copy, nullable) NSString *characterName;

@end

NS_ASSUME_NONNULL_END
