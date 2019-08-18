//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGProgramComposition.h"

#import <libextobjc/libextobjc.h>

@interface SRGProgramComposition ()

@property (nonatomic) SRGChannel *channel;
@property (nonatomic) NSArray<SRGProgram *> *programs;

@end

@implementation SRGProgramComposition

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGProgramComposition.new, channel) : @"channel",
                       @keypath(SRGProgramComposition.new, programs) : @"programList" };
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)channelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:SRGChannel.class];
}

+ (NSValueTransformer *)programsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SRGProgram.class];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (! [object isKindOfClass:self.class]) {
        return NO;
    }
    
    SRGProgramComposition *otherProgramComposition = object;
    return [self.channel.uid isEqual:otherProgramComposition.channel.uid];
}

- (NSUInteger)hash
{
    return self.channel.uid.hash;
}

@end
