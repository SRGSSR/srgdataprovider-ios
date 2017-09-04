//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "DataProviderBaseTestCase.h"

#import "SRGJSONTransformers.h"

@interface MediaAvailabilityTestCase : DataProviderBaseTestCase

@end

@implementation MediaAvailabilityTestCase

- (void)testAlwaysAvailable
{
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{};
    
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    XCTAssertEqual(SRGDataProviderAvailabilityForMediaMetadata(media), SRGMediaAvailabilityAvailable);
}

- (void)testNotYetAvailable
{
    NSString *futureDateString = [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:10]];
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom": futureDateString };
    
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    XCTAssertEqual(SRGDataProviderAvailabilityForMediaMetadata(media), SRGMediaAvailabilityNotYetAvailable);
}

- (void)testExpired
{
    NSString *pastDateString = [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:-10]];
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validTo": pastDateString };
    
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    XCTAssertEqual(SRGDataProviderAvailabilityForMediaMetadata(media), SRGMediaAvailabilityExpired);
}

- (void)testAvailableBetweenDates
{
    NSString *pastDateString = [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:-10]];
    NSString *futureDateString = [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:10]];
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom": pastDateString,
                                      @"validTo": futureDateString };
    
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    XCTAssertEqual(SRGDataProviderAvailabilityForMediaMetadata(media), SRGMediaAvailabilityAvailable);
}

- (void)testAvailableWithOldNotYetAvailableMedia
{
    NSString *pastDateString = [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:-10]];
    NSString *startDateBlockReasonString = [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonStartDate)];
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom": pastDateString,
                                      @"blockReason" : startDateBlockReasonString };
    
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    XCTAssertEqual(SRGDataProviderAvailabilityForMediaMetadata(media), SRGMediaAvailabilityAvailable);
}

- (void)testExpiredWithOldNotYetAvailableMedia
{
    NSString *pastDateString1 = [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:-10]];
    NSString *pastDateString2 = [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:-5]];
    NSString *startDateBlockReasonString = [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonStartDate)];
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom": pastDateString1,
                                      @"validTo": pastDateString2,
                                      @"blockReason" : startDateBlockReasonString };
    
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    XCTAssertEqual(SRGDataProviderAvailabilityForMediaMetadata(media), SRGMediaAvailabilityExpired);
}

- (void)testAvailableWithFutureExpiredMedia
{
    NSString *futureDateString = [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:10]];
    NSString *endDateBlockReasonString = [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonEndDate)];
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validTo": futureDateString,
                                      @"blockReason" : endDateBlockReasonString };
    
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    XCTAssertEqual(SRGDataProviderAvailabilityForMediaMetadata(media), SRGMediaAvailabilityAvailable);
}

- (void)testNotYetAvailableWithFutureExpiredMedia
{
    NSString *futureDateString1 = [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:5]];
    NSString *futureDateString2 = [SRGISO8601DateJSONTransformer() reverseTransformedValue:[[NSDate date] dateByAddingTimeInterval:10]];
    NSString *endDateBlockReasonString = [SRGBlockingReasonJSONTransformer() reverseTransformedValue:@(SRGBlockingReasonEndDate)];
    NSError *error = nil;
    NSDictionary *JSONDictionary = @{ @"validFrom": futureDateString1,
                                      @"validTo": futureDateString2,
                                      @"blockReason" : endDateBlockReasonString };
    
    SRGMedia *media = [MTLJSONAdapter modelOfClass:[SRGMedia class] fromJSONDictionary:JSONDictionary error:&error];
    XCTAssertNil(error);
    
    XCTAssertEqual(SRGDataProviderAvailabilityForMediaMetadata(media), SRGMediaAvailabilityNotYetAvailable);
}

@end
