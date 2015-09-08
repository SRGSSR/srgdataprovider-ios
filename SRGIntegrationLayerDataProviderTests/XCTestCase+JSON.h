//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (JSON)

- (id)loadJSONFile:(NSString *)filename withClassName:(NSString *)className;

@end
