//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGEpisode.h"

#import "NSURL+SRGIntegrationLayerDataProvider.h"

@interface SRGEpisode ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@property (nonatomic) NSArray<SRGMedia *> *medias;

@end

@implementation SRGEpisode

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
                     @"medias" : @"mediaList" };
    });
    return mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)mediasJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGMedia class]];
}

#pragma mark SRGImage protocol

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value];
}

@end
