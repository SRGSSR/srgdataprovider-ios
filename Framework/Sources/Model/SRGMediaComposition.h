//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGChapter.h"
#import "SRGEpisode.h"
#import "SRGShow.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGMediaComposition : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *chapterURN;

@property (nonatomic, readonly) SRGShow *show;
@property (nonatomic, readonly) SRGEpisode *episode;
@property (nonatomic, readonly) NSArray<SRGChapter *> *chapters;

@property (nonatomic, readonly, copy) NSString *event;

@end

NS_ASSUME_NONNULL_END
