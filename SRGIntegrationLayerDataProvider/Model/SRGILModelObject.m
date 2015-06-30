
//
//  SRFModelObject.m
//  SRFPlayer
//
//  Created by Samuel Défago on 15/01/14.
//
//  Copyright (c) 2014 SRG SSR. All rights reserved.

#import "SRGILModelObject.h"
#import <objc/runtime.h>

@interface SRGILModelObject () <NSCoding>
@end

@implementation SRGILModelObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }

    NSAssert([dictionary isKindOfClass:NSDictionary.class], @"Expected a dictionary, received a %@°", [dictionary class]);
    
    self = [super init];
    if (self) {
        _identifier = [dictionary objectForKey:@"id"];
        _urnString = [dictionary objectForKey:@"urn"];
        _downloadDate = [NSDate date];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        if ([self supportAutomaticPropertiesCoding]) {
            [[self propertiesNames] enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
                [self setValue:[aDecoder decodeObjectForKey:propertyName] forKey:propertyName];
            }];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if ([self supportAutomaticPropertiesCoding]) {
        [[self propertiesNames] enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
            id obj = [self valueForKey:propertyName];
            if (obj) {
                [aCoder encodeObject:obj forKey:propertyName];
            }
        }];
    }
}

- (BOOL)supportAutomaticPropertiesCoding;
{
    return NO;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    BOOL answer = [super conformsToProtocol:aProtocol];
    if (aProtocol == @protocol(NSCoding)) {
        answer |= [self supportAutomaticPropertiesCoding];
    }
    return answer;
}

- (NSArray *)propertiesNames
{
    NSMutableArray *names = [NSMutableArray array];
    unsigned int numberOfProperties = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &numberOfProperties);
    for (unsigned int i = 0; i < numberOfProperties; ++i) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [names addObject:propertyName];
    }
    free(properties);
    return [names copy];
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: %p", [self class], self];
    [[self propertiesNames] enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        [description appendFormat:@"; %@: %@", propertyName, [self valueForKey:propertyName]];
    }];
    [description appendString:@">"];
    return [description copy];
}

@end
