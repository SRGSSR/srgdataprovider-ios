//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

@implementation SRGModel

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Subclasses of SRGModel must implement -JSONKeyPathsByPropertyKey:"
                                 userInfo:nil];
}

#pragma mark Description

- (NSString *)description
{
    return [self descriptionAtLevel:0];
}

- (NSString *)descriptionAtLevel:(NSInteger)level
{
    NSString *normalIndentationString = [@"" stringByPaddingToLength:level withString:@"\t" startingAtIndex:0];
    NSString *fieldIndentationString = [@"" stringByPaddingToLength:level + 1 withString:@"\t" startingAtIndex:0];
    
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: %p> {\n", [self class], self];
    for (NSString *propertyKey in [[self class] propertyKeys]) {
        id value = [self valueForKey:propertyKey];
        if (! value) {
            continue;
        }
        
        id formattedValue = nil;
        if ([value isKindOfClass:[NSString class]]) {
            formattedValue = [NSString stringWithFormat:@"\"%@\"", value];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            formattedValue = @"dictionary";
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            formattedValue = @"array";
        }
        else if ([value isKindOfClass:[SRGModel class]]) {
            formattedValue = [value descriptionAtLevel:level + 1];
        }
        else {
            formattedValue = value;
        }
        [description appendFormat:@"%@%@ = %@;\n", fieldIndentationString, propertyKey, formattedValue];
    }
    [description appendFormat:@"%@}", normalIndentationString];
    return [description copy];
}

@end
