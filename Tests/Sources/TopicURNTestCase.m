//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

@interface TopicURNTestCase : DataProviderBaseTestCase

@end

@implementation TopicURNTestCase

#pragma mark Tests

- (void)testCreation
{
    NSString *URNString = @"urn:rts:topic:tv:1081";
    
    SRGTopicURN *topicURN = [[SRGTopicURN alloc] initWithURNString:URNString];
    XCTAssertEqualObjects(topicURN.uid, @"1081");
    XCTAssertEqualObjects(@(topicURN.transmission), @(SRGTransmissionTV));
    XCTAssertEqualObjects(@(topicURN.vendor), @(SRGVendorRTS));
    XCTAssertEqualObjects(topicURN.URNString, URNString);
}

- (void)testCaseInsensitive
{
    SRGTopicURN *topicURN1 = [[SRGTopicURN alloc] initWithURNString:@"URN:rts:topic:tv:1081"];
    XCTAssertNotNil(topicURN1);
    
    SRGTopicURN *topicURN2 = [[SRGTopicURN alloc] initWithURNString:@"urn:RTS:topic:tv:1081"];
    XCTAssertNotNil(topicURN2);
    
    SRGTopicURN *topicURN3 = [[SRGTopicURN alloc] initWithURNString:@"Urn:rts:TOPIC:TV:1081"];
    XCTAssertNotNil(topicURN3);
}

- (void)testCaseSensitive
{
    SRGTopicURN *topicURN = [[SRGTopicURN alloc] initWithURNString:@"urn:rts:topic:tv:TeStUrN"];
    XCTAssertNotNil(topicURN);
    XCTAssertEqualObjects(topicURN.uid, @"TeStUrN");
}

- (void)testIncorrectURNs
{
    SRGTopicURN *topicURN1 = [[SRGTopicURN alloc] initWithURNString:@"fakeURN:rts:topic:tv:1081"];
    XCTAssertNil(topicURN1);
    
    SRGTopicURN *topicURN2 = [[SRGTopicURN alloc] initWithURNString:@"urn:rts:tv:1081"];
    XCTAssertNil(topicURN2);
    
    SRGTopicURN *topicURN3 = [[SRGTopicURN alloc] initWithURNString:@"urn:rts:topic:tv:"];
    XCTAssertNil(topicURN3);
    
    SRGTopicURN *topicURN4 = [[SRGTopicURN alloc] initWithURNString:@"urn:rts:dummy:tv:1081"];
    XCTAssertNil(topicURN4);
    
    SRGTopicURN *topicURN5 = [[SRGTopicURN alloc] initWithURNString:@"urn:rts:topic:dummy:1081"];
    XCTAssertNil(topicURN5);
}

- (void)testEquality
{
    SRGTopicURN *topicURN1 = [[SRGTopicURN alloc] initWithURNString:@"urn:rts:topic:tv:1"];
    SRGTopicURN *topicURN2 = [[SRGTopicURN alloc] initWithURNString:@"urn:rts:topic:tv:1"];
    SRGTopicURN *topicURN3 = [[SRGTopicURN alloc] initWithURNString:@"urn:srf:topic:tv:1"];
    SRGTopicURN *topicURN4 = [[SRGTopicURN alloc] initWithURNString:@"urn:rts:topic:tv:100"];
    SRGTopicURN *topicURN5 = [[SRGTopicURN alloc] initWithURNString:@"urn:swi:show:online:1"];
    
    XCTAssertTrue([topicURN1 isEqual:topicURN2]);
    XCTAssertFalse([topicURN1 isEqual:topicURN3]);
    XCTAssertFalse([topicURN1 isEqual:topicURN4]);
    XCTAssertFalse([topicURN1 isEqual:topicURN5]);
}

@end
