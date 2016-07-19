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
    return @{ @"type" : @"key",
              @"value" : @"value" };
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
