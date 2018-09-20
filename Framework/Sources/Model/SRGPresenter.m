//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPresenter.h"

#import "NSURL+SRGDataProvider.h"

#import <libextobjc/libextobjc.h>

@interface SRGPresenter ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSURL *URL;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@end

@implementation SRGPresenter

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGPresenter.new, name) : @"name",
                       @keypath(SRGPresenter.new, URL) : @"url",
                       
                       @keypath(SRGPresenter.new, imageURL) : @"imageUrl",
                       @keypath(SRGPresenter.new, imageTitle) : @"imageTitle",
                       @keypath(SRGPresenter.new, imageCopyright) : @"imageCopyright" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark SRGImageMetadata protocol

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(SRGImageType)type
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value uid:nil type:type];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! object || ! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGPresenter *otherPresenter = object;
    return [self.name isEqualToString:otherPresenter.name];
}

- (NSUInteger)hash
{
    return self.name.hash;
}

@end
