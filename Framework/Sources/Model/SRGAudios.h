//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGLanguage.h"
#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Media audio tracks information.
 */
@interface SRGAudios : SRGModel

/**
 *  The HLS audio tracks languages.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGLanguage *> *HLSLanguages;

/**
 *  The HDS audio tracks languages.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGLanguage *> *HDSLanguages;

/**
 *  The DASH audio tracks languages.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGLanguage *> *DASHLanguages;

@end

NS_ASSUME_NONNULL_END
