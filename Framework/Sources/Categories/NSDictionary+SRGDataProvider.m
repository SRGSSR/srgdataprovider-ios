//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSDictionary+SRGDataProvider.h"

@implementation NSDictionary (SRGDataProvider)

- (NSString *)srg_descriptionAtLevel:(NSInteger)level
{
    NSString *normalIndentationString = [@"" stringByPaddingToLength:level withString:@"\t" startingAtIndex:0];
    NSString *fieldIndentationString = [@"" stringByPaddingToLength:level + 1 withString:@"\t" startingAtIndex:0];
    
    NSMutableString *description = [NSMutableString stringWithFormat:@"(\n"];
    for (id key in self.allKeys) {
        id value = self[key];
        
        id formattedValue = nil;
        if ([value respondsToSelector:@selector(srg_descriptionAtLevel:)]) {
            formattedValue = [value srg_descriptionAtLevel:level + 1];
        }
        else if ([value isKindOfClass:[NSString class]]) {
            formattedValue = [NSString stringWithFormat:@"\"%@\"", value];
        }
        else {
            formattedValue = value;
        }
        [description appendFormat:@"%@%@ = %@,\n", fieldIndentationString, key, formattedValue];
    }
    [description appendFormat:@"%@)", normalIndentationString];
    return [description copy];
}

@end
