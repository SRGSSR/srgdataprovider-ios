//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGCrewMember.h"

@import libextobjc;

@interface SRGCrewMember ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *characterName;

@end

@implementation SRGCrewMember

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_mapping = @{ @keypath(SRGCrewMember.new, name) : @"realName",
                       @keypath(SRGCrewMember.new, role) : @"role",
                       @keypath(SRGCrewMember.new, characterName) : @"name"
        };
    });
    return s_mapping;
}

@end
