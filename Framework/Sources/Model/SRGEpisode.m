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
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic) NSURL *imageURL;

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
                     @"imageURL" : @"imageUrl",
                     @"imageTitle" : @"imageTitle" };
    });
    return mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end

@implementation SRGEpisode (SRGImageResizing)

- (NSURL *)imageURLForWidth:(CGFloat)width
{
    return [self.imageURL srg_URLForWidth:width];
}

- (NSURL *)imageURLForHeight:(CGFloat)height
{
    return [self.imageURL srg_URLForHeight:height];
}

@end
