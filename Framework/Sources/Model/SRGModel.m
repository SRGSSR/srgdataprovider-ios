//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"

#import "NSObject+SRGDataProvider.h"

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
    return [self srg_descriptionAtLevel:0];
}

- (NSString *)srg_descriptionAtLevel:(NSInteger)level
{
    NSString *normalIndentationString = [@"" stringByPaddingToLength:level withString:@"\t" startingAtIndex:0];
    NSString *fieldIndentationString = [@"" stringByPaddingToLength:level + 1 withString:@"\t" startingAtIndex:0];
    
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: %p> {\n", [self class], self];
    NSArray *sortedPropertyKeys = [[[self class] propertyKeys].allObjects sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (NSString *propertyKey in sortedPropertyKeys) {
        id value = [self valueForKey:propertyKey];
        if (! value) {
            continue;
        }
        
        id formattedValue = [value srg_formattedObjectAtLevel:level + 1];
        [description appendFormat:@"%@%@ = %@;\n", fieldIndentationString, propertyKey, formattedValue];
    }
    [description appendFormat:@"%@}", normalIndentationString];
    return [description copy];
}

@end
