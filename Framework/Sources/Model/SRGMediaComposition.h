//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Mantle/Mantle.h>

#import "SRGChapter.h"
#import "SRGEpisode.h"
#import "SRGShow.h"

@interface SRGMediaComposition : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *chapterURN;

@property (nonatomic) SRGShow *show;
@property (nonatomic) SRGEpisode *episode;
@property (nonatomic) NSArray<SRGChapter *> *chapters;

@property (nonatomic, copy) NSString *event;

@end
