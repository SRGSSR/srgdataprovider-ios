//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "XCTestCase+JSON.h"

@implementation XCTestCase (JSON)

- (id)loadJSONFile:(NSString *)filename withClassName:(NSString *)className
{
    NSAssert(! ! filename, @"nil filename");
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"json"];
    NSError *error;
    
    NSAssert(! ! path, @"nil path (means can't find file)");
    
    id result = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                                options:0
                                                  error:&error];
    if (error) {
        XCTFail(@"Could not parse sample file");
        return nil;
    }
    else {
        if (className) {
            result = [result valueForKey:className];
        }
        return result;
    }
}

@end
