//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGShowAndMedias.h"

@import libextobjc;

@interface SRGShowAndMedias ()

@property (nonatomic) SRGShow *show;
@property (nonatomic) NSArray<SRGMedia *> *medias;

@end

@implementation SRGShowAndMedias

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGShowAndMedias.new, show) : @"show",
                       @keypath(SRGShowAndMedias.new, medias) : @"mediaList" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)showJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGShow.class];
}

+ (NSValueTransformer *)mediasJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGMedia.class];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGShowAndMedias *otherShowAndMedias = object;
    return [self.show.URN isEqual:otherShowAndMedias.show.URN];
}

- (NSUInteger)hash
{
    return self.show.URN.hash;
}

@end
