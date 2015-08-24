//
//  RTSShowMetadata.m
//  SRGOfflineStorage
//
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "RTSShowMetadata.h"

#define REALM_NONNULL_STRING(value) ((value == nil) ? @"" : (value))

@implementation RTSShowMetadata

+ (NSString *)primaryKey
{
    return @"identifier";
}

+ (NSDictionary *)defaultPropertyValues
{
    NSMutableDictionary *defaults = [[[self superclass] defaultPropertyValues] mutableCopy];
    defaults[@"showDescription"] = @"";
    return [defaults copy];
}

- (instancetype)initWithContainer:(id<SRGShowMetadataContainer>)container
{
    self = [super initWithContainer:container];
    if (self) {
        [self udpateWithContainer:container];
    }
    return self;
}

- (void)udpateWithContainer:(id<SRGShowMetadataContainer>)container
{
    [super udpateWithContainer:container];
    self.showDescription = REALM_NONNULL_STRING([container showDescription]);
}

@end
