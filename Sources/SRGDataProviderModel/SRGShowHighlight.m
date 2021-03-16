//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGShowHighlight.h"

@import libextobjc;

@interface SRGShowHighlight ()

@property (nonatomic) SRGShow *show;
@property (nonatomic) NSArray<SRGMedia *> *medias;

@end

@implementation SRGShowHighlight

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGShowHighlight.new, show) : @"show",
                       @keypath(SRGShowHighlight.new, medias) : @"mediaList" };
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
    
    SRGShowHighlight *otherShowHighlight = object;
    return [self.show.URN isEqual:otherShowHighlight.show.URN];
}

- (NSUInteger)hash
{
    return self.show.URN.hash;
}

@end
