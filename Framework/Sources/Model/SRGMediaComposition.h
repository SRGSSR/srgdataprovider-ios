//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGEntry.h"
#import "SRGChannel.h"
#import "SRGChapter.h"
#import "SRGEpisode.h"
#import "SRGShow.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGMediaComposition : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *chapterURN;
@property (nonatomic, readonly, copy, nullable) NSString *segmentURN;
@property (nonatomic, readonly, nullable) SRGEpisode *episode;
@property (nonatomic, readonly, nullable) SRGShow *show;
@property (nonatomic, readonly, nullable) SRGChannel *channel;
@property (nonatomic, readonly) NSArray<SRGChapter *> *chapters;
@property (nonatomic, readonly, nullable) NSArray<SRGEntry *> *analyticsEntries;
@property (nonatomic, readonly, copy, nullable) NSString *event;

@end

@interface SRGMediaComposition (Helpers)

@property (nonatomic, readonly) SRGChapter *mainChapter;
@property (nonatomic, readonly) SRGChapter *mainSegment;

@end

NS_ASSUME_NONNULL_END
