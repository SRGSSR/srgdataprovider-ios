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
 *  Media subtitles information.
 */
@interface SRGSubtitles : SRGModel

/**
 *  The external subtitles languages.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGLanguage *> *externalLanguages;

/**
 *  The HLS subtitles languages.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGLanguage *> *HLSLanguages;

/**
 *  The HDS subtitles languages.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGLanguage *> *HDSLanguages;

/**
 *  The DASH subtitles languages.
 */
@property (nonatomic, readonly, nullable) NSArray<SRGLanguage *> *DASHLanguages;

@end

NS_ASSUME_NONNULL_END
