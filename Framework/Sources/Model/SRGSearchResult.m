//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSearchResult.h"

#import "NSURL+SRGDataProvider.h"

#import <libextobjc/libextobjc.h>

@interface SRGSearchResult ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *URN;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;
@property (nonatomic, copy) NSString *imageCopyright;

@end

@implementation SRGSearchResult

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGSearchResult.new, uid) : @"id",
                       @keypath(SRGSearchResult.new, URN) : @"urn",
                        
                       @keypath(SRGSearchResult.new, title) : @"title",
                       @keypath(SRGSearchResult.new, lead) : @"lead",
                       @keypath(SRGSearchResult.new, summary) : @"description",
                        
                       @keypath(SRGSearchResult.new, imageURL) : @"imageUrl",
                       @keypath(SRGSearchResult.new, imageTitle) : @"imageTitle",
                       @keypath(SRGSearchResult.new, imageCopyright) : @"imageCopyright" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

#pragma mark SRGImageMetadata protocol

- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value];
}

@end
