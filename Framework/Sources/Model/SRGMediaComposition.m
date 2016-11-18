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
                       @keypath(SRGMediaComposition.new, analyticsLabels) : @"analyticsData" };
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

- (BOOL)containsSegment:(SRGSegment *)segment
{
    for (SRGChapter *chapter in self.chapters) {
        if (chapter == segment) {
            return YES;
        }
        else {
            for (SRGSegment *chapterSegment in chapter.segments) {
                if (chapterSegment == segment) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (SRGMedia *)mediaForSegment:(SRGSegment *)segment
{
    if (! [self containsSegment:segment]) {
        return nil;
    }
    
    SRGMedia *media = [[SRGMedia alloc] init];
    
    // Start from existing segment values
    NSMutableDictionary *values = [segment.dictionaryValue mutableCopy];
    
    // Merge with parent metadata available at the media composition level
    if (self.channel) {
        values[@keypath(media.channel)] = self.channel;
    }
    if (self.episode) {
        values[@keypath(media.episode)] = self.episode;
    }
    if (self.show) {
        values[@keypath(media.show)] = self.show;
    }
    
    // Fill the media object
    for (NSString *key in [SRGMedia propertyKeys]) {
        id value = values[key];
        if (value && value != [NSNull null]) {
            [media setValue:value forKey:key];
        }
    }
    
    return media;
}

- (SRGMedia *)mediaForChapter:(SRGChapter *)chapter
{
    return [self mediaForSegment:chapter];
}

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

- (SRGMediaComposition *)mediaCompositionForChapter:(SRGChapter *)chapter
{
    return [self mediaCompositionForChapter:chapter];
}

@end
