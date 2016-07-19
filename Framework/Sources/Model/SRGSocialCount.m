//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSocialCount.h"

@interface SRGSocialCount ()

@property (nonatomic) SRGSocialCountType type;
@property (nonatomic) NSInteger value;

@end

@implementation SRGSocialCount

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{ @"type" : @"key",
                     @"value" : @"value" };
    });
    return mapping;
}

#pragma mark Parsers

+ (NSValueTransformer *)typeJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"srgView": @(SRGSocialCountTypeSRGView),
                                                                            @"srgLike": @(SRGSocialCountTypeSRGLike),
                                                                            @"fbShare": @(SRGSocialCountTypeFacebookShare),
                                                                            @"twitterShare": @(SRGSocialCountTypeTwitterShare),
                                                                            @"googleShare": @(SRGSocialCountTypeGooglePlusShare),
                                                                            @"whatsAppShare": @(SRGSocialCountTypeWhatsAppShare) }];
}

@end
