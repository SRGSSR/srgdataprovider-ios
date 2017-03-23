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
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: %p> {\n", [self class], self];
    for (NSString *propertyKey in [[self class] propertyKeys]) {
        id value = [self valueForKey:propertyKey];
        if (! value) {
            continue;
        }
        
        NSString *valueString = [value isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@"\"%@\"", value] : value;
        [description appendFormat:@"%@ = %@;\n", propertyKey, valueString];
    }
    [description appendString:@"}\n"];
    return [description copy];
}

@end
