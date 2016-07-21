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
@property (nonatomic, copy) NSString *primaryChannelUid;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSURL *homepageURL;
@property (nonatomic) NSURL *podcastSubscriptionURL;

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
                     @"primaryChannelUid" : @"primaryChannelId",
                     @"imageURL" : @"imageUrl",
                     @"homepageURL" : @"homepageUrl",
                     @"podcastSubscriptionURL" : @"podcastSubscriptionUrl" };
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

@end

@implementation SRGShow (SRGImageResizing)

- (NSURL *)imageURLForWidth:(CGFloat)width
{
    return [self.imageURL srg_URLForWidth:width];
}

- (NSURL *)imageURLForHeight:(CGFloat)height
{
    return [self.imageURL srg_URLForHeight:height];
}

@end
