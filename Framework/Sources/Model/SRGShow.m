//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGShow.h"

#import "NSURL+SRGIntegrationLayerDataProvider.h"

@interface SRGShow ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;
@property (nonatomic) NSURL *homepageURL;
@property (nonatomic) NSURL *podcastSubscriptionURL;
@property (nonatomic, copy) NSString *primaryChannelUid;

@end

@implementation SRGShow

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{ @"uid" : @"id",
                     @"title" : @"title",
                     @"lead" : @"lead",
                     @"summary" : @"description",
                     @"imageURL" : @"imageUrl",
                     @"imageTitle" : @"imageTitle",
                     @"imageCopyright" : @"imageCopyright",
                     @"homepageURL" : @"homepageUrl",
                     @"podcastSubscriptionURL" : @"podcastSubscriptionUrl",
                     @"primaryChannelUid" : @"primaryChannelId" };
    });
    return mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)homepageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)podcastSubscriptionURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark SRGImage protocol

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value];
}

@end
