//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

#import "SRGJSONTransformers.h"

@interface MediaMetadataTestCase : DataProviderBaseTestCase

@end

@implementation MediaMetadataTestCase

- (void)testSimplestMedia
{
    NSError *error = nil;
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:@{} error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testAvailableMedia
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:-10]],
                                      @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:10]] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:[NSDate date]], SRGBlockingReasonNone);
}

- (void)testNotYetAvailableMedia1
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:10]] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:[NSDate date]], SRGBlockingReasonStartDate);
}

- (void)testNotYetAvailableMedia2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonStartDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:[NSDate date]], SRGBlockingReasonStartDate);
}

- (void)testExpiredMedia1
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:-10]] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:[NSDate date]], SRGBlockingReasonEndDate);
}

- (void)testExpiredMedia2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonEndDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:[NSDate date]], SRGBlockingReasonEndDate);
}

- (void)testStartDateBlockingReasonPrecedence1
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:-10]],
                                      @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonStartDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:[NSDate date]], SRGBlockingReasonStartDate);
}

- (void)testStartDateBlockingReasonPrecedence2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:-5]],
                                      @"blockReason" :  [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonStartDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:[NSDate date]], SRGBlockingReasonStartDate);
}

- (void)testEndDateBlockingReasonPrecedence1
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:10]],
                                      @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonEndDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:[NSDate date]], SRGBlockingReasonEndDate);
}

- (void)testEndDateBlockingReasonPrecedence2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:5]],
                                      @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonEndDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:[NSDate date]], SRGBlockingReasonEndDate);
}

- (void)testOtherBlockingReasonPrecedence
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:-10]],
                                      @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:10]],
                                      @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonLegal)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:[NSDate date]], SRGBlockingReasonLegal);
}

@end
