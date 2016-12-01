//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "NSURL+SRGDataProvider.h"

#import <UIKit/UIKit.h>

@implementation NSString (SRGUtils)

- (NSString *)srg_stringByAddingPercentEncoding
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@" \"#%/:<>?@[\\]^`{|}"] invertedSet]];
}

@end
