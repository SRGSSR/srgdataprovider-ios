//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTopicURN.h"

#import "SRGJSONTransformers.h"

@interface SRGTopicURN ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) SRGTransmission transmission;
@property (nonatomic) SRGVendor vendor;
@property (nonatomic, copy) NSString *URNString;

@end

@implementation SRGTopicURN

#pragma mark Class methods

+ (SRGShowURN *)topicURNWithString:(NSString *)URNString
{
    return [[[self class] alloc] initWithURNString:URNString];
}

#pragma mark Object lifecycle

- (instancetype)initWithURNString:(NSString *)URNString
{
    if (self = [super init]) {
        if (! [self parseURNString:URNString]) {
            return nil;
        }
        
        self.URNString = URNString;
    }
    return self;
}

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return [self initWithURNString:@""];
}

#pragma mark Parsing

- (BOOL)parseURNString:(NSString *)URNString
{
    NSMutableArray<NSString *> *components = [[URNString componentsSeparatedByString:@":"] mutableCopy];
    if (components.count != 5 || ! [components.firstObject.lowercaseString isEqualToString:@"urn"]
            || ! [components[2].lowercaseString isEqualToString:@"topic"]) {
        return NO;
    }
    
    SRGTransmission transmission = [[SRGTransmissionJSONTransformer() transformedValue:components[3].uppercaseString] integerValue];
    if (transmission == SRGTransmissionNone) {
        return NO;
    }
    
    SRGVendor vendor = [[SRGVendorJSONTransformer() transformedValue:components[1].uppercaseString] integerValue];
    if (vendor == SRGVendorNone) {
        return NO;
    }
    
    NSString *uid = components[4];
    if (uid.length == 0) {
        return nil;
    }
    
    self.uid = uid;
    self.transmission = transmission;
    self.vendor = vendor;
    
    return YES;
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGTopicURN *otherTopicURN = object;
    return [self.URNString isEqualToString:otherTopicURN.URNString];
}

- (NSUInteger)hash
{
    return self.URNString.hash;
}

#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithURNString:self.URNString];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; uid: %@; transmission: %@; URNString: %@>",
            [self class],
            self,
            self.uid,
            [[SRGTransmissionJSONTransformer() reverseTransformedValue:@(self.transmission)] lowercaseString],
            self.URNString];
}

@end