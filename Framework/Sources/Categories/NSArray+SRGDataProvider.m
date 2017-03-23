//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSArray+SRGDataProvider.h"

#import "NSObject+SRGDataProvider.h"

#pragma SRGDescribable protocol

@implementation NSArray (SRGDataProvider)

- (NSString *)srg_descriptionAtLevel:(NSInteger)level
{
    NSString *normalIndentationString = [@"" stringByPaddingToLength:level withString:@"\t" startingAtIndex:0];
    NSString *fieldIndentationString = [@"" stringByPaddingToLength:level + 1 withString:@"\t" startingAtIndex:0];
    
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%p> (\n", self];
    for (id object in self) {
        id formattedObject = [object srg_formattedObjectAtLevel:level + 1];
        [description appendFormat:@"%@%@,\n", fieldIndentationString, formattedObject];

    }
    [description appendFormat:@"%@)", normalIndentationString];
    return [description copy];
}

@end
