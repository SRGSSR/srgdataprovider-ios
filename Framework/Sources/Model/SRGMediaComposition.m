//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaComposition.h"

#import "SRGJSONTransformers.h"

#import <libextobjc/libextobjc.h>

@interface SRGMediaComposition ()

@property (nonatomic) SRGMediaURN *chapterURN;
@property (nonatomic) SRGMediaURN *segmentURN;
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

+ (NSValueTransformer *)chapterURNJSONTransformer
{
    return SRGMediaURNJSONTransformer();
}

+ (NSValueTransformer *)segmentURNJSONTransformer
{
    return SRGMediaURNJSONTransformer();
}

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

- (SRGMedia *)fullLengthMedia
{
    // If the main chapter is an episode, it is the full-length
    SRGChapter *mainChapter = self.mainChapter;
    if (mainChapter.contentType == SRGContentTypeEpisode) {
        return [self mediaForRepresentation:mainChapter];
    }
    // Locate the associate full-length
    else if (mainChapter.fullLengthURN) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @keypath(SRGChapter.new, URN), mainChapter.fullLengthURN];
        SRGChapter *fullLengthChapter = [self.chapters filteredArrayUsingPredicate:predicate].firstObject;
        return fullLengthChapter ? [self mediaForRepresentation:fullLengthChapter] : nil;
    }
    else {
        return nil;
    }    
}

#pragma mark Media and media composition generation

- (BOOL)containsRepresentation:(SRGMediaRepresentation *)representation
{
    for (SRGChapter *chapter in self.chapters) {
        if (chapter == representation) {
            return YES;
        }
        else {
            for (SRGSegment *chapterSegment in chapter.segments) {
                if (chapterSegment == representation) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

- (SRGMedia *)mediaForRepresentation:(SRGMediaRepresentation *)representation
{
    if (! [self containsRepresentation:representation]) {
        return nil;
    }
    
    SRGMedia *media = [[SRGMedia alloc] init];
    
    // Start from existing segment values
    NSMutableDictionary *values = [representation.dictionaryValue mutableCopy];
    
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

- (SRGMediaComposition *)mediaCompositionForRepresentation:(SRGMediaRepresentation *)representation
{
    for (SRGChapter *chapter in self.chapters) {
        if (chapter == representation) {
            SRGMediaComposition *mediaComposition = [self copy];
            mediaComposition.chapterURN = chapter.URN;
            return mediaComposition;
        }
        else {
            for (SRGSegment *chapterSegment in chapter.segments) {
                if (chapterSegment == representation) {
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

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGMediaComposition *otherMediaComposition = object;
    if (self.segmentURN) {
        return [self.segmentURN isEqual:otherMediaComposition.segmentURN];
    }
    else {
        return [self.chapterURN isEqual:otherMediaComposition.chapterURN];
    }
}

- (NSUInteger)hash
{
    return self.segmentURN ? self.segmentURN.hash : self.chapterURN.hash;
}

@end
