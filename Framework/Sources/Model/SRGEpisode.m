//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGEpisode.h"

#import "NSURL+SRGDataProvider.h"
#import "SRGJSONTransformers.h"
#import "SRGMedia.h"

#import <libextobjc/libextobjc.h>

@interface SRGEpisode ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSArray<SRGMedia *> *medias;
@property (nonatomic) SRGSocialCount *socialCount;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@end

@implementation SRGEpisode

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGEpisode.new, uid) : @"id",
                       @keypath(SRGEpisode.new, date) : @"publishedDate",
                       @keypath(SRGEpisode.new, medias) : @"mediaList",
                       @keypath(SRGEpisode.new, socialCount) : @"socialCount",
                       
                       @keypath(SRGEpisode.new, title) : @"title",
                       @keypath(SRGEpisode.new, lead) : @"lead",
                       @keypath(SRGEpisode.new, summary) : @"description",
                       
                       @keypath(SRGEpisode.new, imageURL) : @"imageUrl",
                       @keypath(SRGEpisode.new, imageTitle) : @"imageTitle",
                       @keypath(SRGEpisode.new, imageCopyright) : @"imageCopyright" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)mediasJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGMedia class]];
}

+ (NSValueTransformer *)dateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)socialCountJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SRGSocialCount class]];
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark SRGImage protocol

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value];
}

@end
