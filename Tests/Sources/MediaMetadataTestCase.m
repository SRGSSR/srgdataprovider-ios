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
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:@{} error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonNone);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityAvailable);
}

- (void)testAvailableMedia1
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:-10]],
                                      @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:10]] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonNone);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityAvailable);
}

- (void)testAvailableMedia2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:-10]] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonNone);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityAvailable);
}

- (void)testAvailableMedia3
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:10]] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonNone);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityAvailable);
}

- (void)testNotYetAvailableMedia1
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:10]] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonStartDate);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityNotYetAvailable);
}

- (void)testNotYetAvailableMedia2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonStartDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonStartDate);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityNotYetAvailable);
}

- (void)testExpiredMedia1
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:-10]] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonEndDate);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityNotAvailableAnymore);
}

- (void)testExpiredMedia2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonEndDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonEndDate);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityNotAvailableAnymore);
}

- (void)testStartDateBlockingReasonPrecedence1
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:-10]],
                                      @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonStartDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonStartDate);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityNotYetAvailable);
}

- (void)testStartDateBlockingReasonPrecedence2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:-5]],
                                      @"blockReason" :  [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonStartDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonStartDate);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityNotYetAvailable);
}

- (void)testEndDateBlockingReasonPrecedence1
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:10]],
                                      @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonEndDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonEndDate);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityNotAvailableAnymore);
}

- (void)testEndDateBlockingReasonPrecedence2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:5]],
                                      @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonEndDate)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonEndDate);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityNotAvailableAnymore);
}

- (void)testOtherBlockingReasonPrecedence1
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:-10]],
                                      @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:10]],
                                      @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonLegal)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonLegal);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityAvailable);
}

- (void)testOtherBlockingReasonPrecedence2
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:5]],
                                      @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:10]],
                                      @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonLegal)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonLegal);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityNotYetAvailable);
}

- (void)testOtherBlockingReasonPrecedence3
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:-10]],
                                      @"validTo" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:-5]],
                                      @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonLegal)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonLegal);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityNotAvailableAnymore);
}

- (void)testOtherBlockingReasonPrecedence4
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom" : [SRGISO8601DateJSONTransformer() reverseTransformedValue:[NSDate.date dateByAddingTimeInterval:-10]],
                                      @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonLegal)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonLegal);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityAvailable);
}

- (void)testBlockingReason
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"blockReason" : [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonLegal)] };
    SRGMedia *media = [MTLJSONAdapter modelOfClass:SRGMedia.class fromJSONDictionary:JSONDictionary error:&error];
    NSDate *currentDate = NSDate.date;
    
    XCTAssertNil(error);
    XCTAssertEqual([media blockingReasonAtDate:currentDate], SRGBlockingReasonLegal);
    XCTAssertEqual([media timeAvailabilityAtDate:currentDate], SRGTimeAvailabilityAvailable);
}

@end
