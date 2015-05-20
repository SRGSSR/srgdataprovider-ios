//
//  RTSShowMetadata.m
//  Pods
//
//  Created by Cédric Foellmi on 06/05/15.
//
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

- (instancetype)initWithContainer:(id<RTSShowMetadataContainer>)container
{
    self = [super initWithContainer:container];
    if (self) {
        self.showDescription = REALM_NONNULL_STRING([container showDescription]);
    }
    return self;
}

@end
