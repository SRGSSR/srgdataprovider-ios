//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSArray+SRGDataProvider.h"

@implementation NSArray (SRGDataProvider)

- (NSString *)srg_descriptionAtLevel:(NSInteger)level
{
    NSString *normalIndentationString = [@"" stringByPaddingToLength:level withString:@"\t" startingAtIndex:0];
    NSString *fieldIndentationString = [@"" stringByPaddingToLength:level + 1 withString:@"\t" startingAtIndex:0];
    
    NSMutableString *description = [NSMutableString stringWithFormat:@"(\n"];
    for (id object in self) {
        id formattedObject = nil;
        if ([object respondsToSelector:@selector(srg_descriptionAtLevel:)]) {
            formattedObject = [object srg_descriptionAtLevel:level + 1];
        }
        else if ([object isKindOfClass:[NSString class]]) {
            formattedObject = [NSString stringWithFormat:@"\"%@\"", object];
        }
        else {
            formattedObject = object;
        }
        [description appendFormat:@"%@%@,\n", fieldIndentationString, formattedObject];

    }
    [description appendFormat:@"%@)", normalIndentationString];
    return [description copy];
}

@end
