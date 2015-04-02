//
//  XCTestCase+JSON.h
//  SRFPlayer
//
//  Created by Cédric Foellmi on 26/06/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (JSON)

- (id)loadJSONFile:(NSString *)filename withClassName:(NSString *)className;

@end
