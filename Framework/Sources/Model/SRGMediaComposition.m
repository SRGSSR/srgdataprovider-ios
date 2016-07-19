//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaComposition.h"

@interface SRGMediaComposition ()

@property (nonatomic, copy) NSString *chapterURN;

@property (nonatomic) SRGShow *show;
@property (nonatomic) SRGEpisode *episode;
@property (nonatomic) NSArray<SRGChapter *> *chapters;

@property (nonatomic, copy) NSString *event;

@end

@implementation SRGMediaComposition

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{ @"chapterURN" : @"chapterUrn",
                     @"show" : @"show",
                     @"episode" : @"episode",
                     @"chapters" : @"chapterList",
                     @"event" : @"eventData" };
    });
    return mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)showJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGShow class]];
}

+ (NSValueTransformer *)episodeJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGEpisode class]];
}

+ (NSValueTransformer *)chaptersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGChapter class]];
}

#pragma mark Getters and setters

- (SRGChapter *)mainChapter
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"URN == %@", self.chapterURN];
    return [self.chapters filteredArrayUsingPredicate:predicate].firstObject;
}

@end

