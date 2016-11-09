//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaComposition.h"

#import <libextobjc/libextobjc.h>

@interface SRGMediaComposition ()

@property (nonatomic, copy) NSString *chapterURN;
@property (nonatomic, copy) NSString *segmentURN;
@property (nonatomic) SRGChannel *channel;
@property (nonatomic) SRGEpisode *episode;
@property (nonatomic) SRGShow *show;
@property (nonatomic) NSArray<SRGChapter *> *chapters;
@property (nonatomic) NSDictionary<NSString *, NSString *> *analyticsLabels;
@property (nonatomic, copy) NSString *event;

@end

@implementation SRGMediaComposition

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGMediaComposition.new, chapterURN) : @"chapterUrn",
                       @keypath(SRGMediaComposition.new, segmentURN) : @"segmentUrn",
                       @keypath(SRGMediaComposition.new, channel) : @"channel",
                       @keypath(SRGMediaComposition.new, episode) : @"episode",
                       @keypath(SRGMediaComposition.new, show) : @"show",
                       @keypath(SRGMediaComposition.new, chapters) : @"chapterList",
                       @keypath(SRGMediaComposition.new, analyticsLabels) : @"analyticsData",
                       @keypath(SRGMediaComposition.new, event) : @"eventData" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)channelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGChannel class]];
}

+ (NSValueTransformer *)episodeJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGEpisode class]];
}

+ (NSValueTransformer *)showJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGShow class]];
}

+ (NSValueTransformer *)chaptersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGChapter class]];
}

#pragma mark Getters and setters

- (SRGChapter *)mainChapter
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGChapter.new, URN), self.chapterURN];
    return [self.chapters filteredArrayUsingPredicate:predicate].firstObject;
}

- (SRGSegment *)mainSegment
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGChapter.new, URN), self.segmentURN];
    return [self.mainChapter.segments filteredArrayUsingPredicate:predicate].firstObject;
}

#pragma mark Chapter generation

- (SRGMediaComposition *)mediaCompositionForSegment:(SRGSegment *)segment
{
    for (SRGChapter *chapter in self.chapters) {
        if (chapter == segment) {
            SRGMediaComposition *mediaComposition = [self copy];
            mediaComposition.chapterURN = chapter.URN;
            return mediaComposition;
        }
        else {
            for (SRGSegment *chapterSegment in chapter.segments) {
                if (chapterSegment == segment) {
                    SRGMediaComposition *mediaComposition = [self copy];
                    mediaComposition.chapterURN = chapter.URN;
                    mediaComposition.segmentURN = chapterSegment.URN;
                    return mediaComposition;
                }
                
            }
        }
    }
    
    // No match found
    return nil;
}

@end
