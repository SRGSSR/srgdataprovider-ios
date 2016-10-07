//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGShow.h"

#import "NSURL+SRGDataProvider.h"

#import <libextobjc/libextobjc.h>

@interface SRGShow ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) NSURL *homepageURL;
@property (nonatomic) NSURL *podcastSubscriptionURL;
@property (nonatomic, copy) NSString *primaryChannelUid;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@end

@implementation SRGShow

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGShow.new, uid) : @"id",
                       @keypath(SRGShow.new, homepageURL) : @"homepageUrl",
                       @keypath(SRGShow.new, podcastSubscriptionURL) : @"podcastSubscriptionUrl",
                       @keypath(SRGShow.new, primaryChannelUid) : @"primaryChannelId",
                       
                       @keypath(SRGShow.new, title) : @"title",
                       @keypath(SRGShow.new, lead) : @"lead",
                       @keypath(SRGShow.new, summary) : @"description",
                       
                       @keypath(SRGShow.new, imageURL) : @"imageUrl",
                       @keypath(SRGShow.new, imageTitle) : @"imageTitle",
                       @keypath(SRGShow.new, imageCopyright) : @"imageCopyright" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)homepageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)podcastSubscriptionURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
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
