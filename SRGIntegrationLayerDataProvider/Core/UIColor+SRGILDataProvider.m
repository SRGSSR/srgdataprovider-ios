//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "UIColor+SRGILDataProvider.h"

@implementation UIColor (SRGILDataProvider)

// Borrowed from https://github.com/ViccAlexander/Chameleon. Did not want to add a library dependency just to
// parse color hex strings
+ (UIColor *)srg_colorWithHexString:(NSString *)string
{
    if (string.length == 0) {
        return nil;
    }
    
    if('#' != [string characterAtIndex:0]) {
        string = [NSString stringWithFormat:@"#%@", string];
    }
    
    if (string.length != 7 && string.length != 4) {
        return nil;
    }
    
    if(string.length == 4) {
        string = [NSString stringWithFormat:@"#%@%@%@%@%@%@",
                  [string substringWithRange:NSMakeRange(1, 1)],[string substringWithRange:NSMakeRange(1, 1)],
                  [string substringWithRange:NSMakeRange(2, 1)],[string substringWithRange:NSMakeRange(2, 1)],
                  [string substringWithRange:NSMakeRange(3, 1)],[string substringWithRange:NSMakeRange(3, 1)]];
    }
    
    NSString *redHex = [NSString stringWithFormat:@"0x%@", [string substringWithRange:NSMakeRange(1, 2)]];
    unsigned red = [[self class] srg_hexValueToUnsigned:redHex];
    
    NSString *greenHex = [NSString stringWithFormat:@"0x%@", [string substringWithRange:NSMakeRange(3, 2)]];
    unsigned green = [[self class] srg_hexValueToUnsigned:greenHex];
    
    NSString *blueHex = [NSString stringWithFormat:@"0x%@", [string substringWithRange:NSMakeRange(5, 2)]];
    unsigned blue = [[self class] srg_hexValueToUnsigned:blueHex];
    
    return [UIColor colorWithRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:1.f];
}

+ (unsigned)srg_hexValueToUnsigned:(NSString *)hexValue {
    
    //Define default unsigned value
    unsigned value = 0;
    
    //Scan unsigned value
    NSScanner *hexValueScanner = [NSScanner scannerWithString:hexValue];
    [hexValueScanner scanHexInt:&value];
    
    //Return found value
    return value;
}

@end
