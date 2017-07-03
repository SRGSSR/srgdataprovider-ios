//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaURN.h"

#import "SRGJSONTransformers.h"

@interface SRGMediaURN ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic) SRGVendor vendor;
@property (nonatomic, copy) NSString *URNString;
@property (nonatomic, getter=isLiveEvent) BOOL liveCenterEvent;

@end

@implementation SRGMediaURN

#pragma mark Class methods

+ (SRGMediaURN *)mediaURNWithString:(NSString *)URNString
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
    if (components.count < 4 || ! [components.firstObject.lowercaseString isEqualToString:@"urn"]) {
        return NO;
    }
    
    // Special case of SwissTXT URLs
    if ([components[1] isEqualToString:@"swisstxt"]) {
        if (components.count != 5) {
            return NO;
        }
        
        self.liveCenterEvent = YES;
        
        // Reorder URN components to get a standard non-SwissTXT URN from a SwissTXT one
        // e.g. urn:swisstxt:type:bu:id must be reordered to urn:bu:type:id 
        [components replaceObjectAtIndex:1 withObject:components[3]];
        [components removeObjectAtIndex:3];
        
        NSString *shortURNString = [components componentsJoinedByString:@":"];
        return [self parseURNString:shortURNString];
    }
    
    SRGMediaType mediaType = [[SRGMediaTypeJSONTransformer() transformedValue:components[2].uppercaseString] integerValue];
    if (mediaType == SRGMediaTypeNone) {
        return NO;
    }
    
    SRGVendor vendor = [[SRGVendorJSONTransformer() transformedValue:components[1].uppercaseString] integerValue];
    if (vendor == SRGVendorNone) {
        return NO;
    }
    
    NSString *uid = components[3];
    if (uid.length == 0) {
        return nil;
    }
    
    self.uid = uid;
    self.mediaType = mediaType;
    self.vendor = vendor;
    
    return YES;
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGMediaURN *otherMediaURN = object;
    return [self.URNString isEqualToString:otherMediaURN.URNString];
}

- (NSUInteger)hash
{
    return self.URNString.hash;
}

#pragma mark NSCopying protocol

- (id)copyWithZone:(NSZone *)zone
{
    return [[SRGMediaURN alloc] initWithURNString:self.URNString];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; uid: %@; mediaType: %@; URNString: %@>",
            [self class],
            self,
            self.uid,
            [[SRGMediaTypeJSONTransformer() reverseTransformedValue:@(self.mediaType)] lowercaseString],
            self.URNString];
}

@end
