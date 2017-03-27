//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSObject+SRGDataProvider.h"

#import "SRGDescribable.h"

@implementation NSObject (SRGDataProvider)

- (id)srg_formattedObjectAtLevel:(NSInteger)level
{
    if ([self respondsToSelector:@selector(srg_descriptionAtLevel:)]) {
        return [(id)self srg_descriptionAtLevel:level];
    }
    else if ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSURL class]]) {
        return [NSString stringWithFormat:@"\"%@\"", self];
    }
    else {
        return self;
    }
}

@end
