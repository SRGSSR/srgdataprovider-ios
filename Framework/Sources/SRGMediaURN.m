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
    NSMutableArray<NSString *> *components = [[URNString componentsSeparatedByString:@":"] mutableCopy];
    if (components.count != 4) {
        return nil;
    }
    
    if (! [components.firstObject.lowercaseString isEqualToString:@"urn"]) {
        return nil;
    }
    
    SRGMediaType mediaType = [[SRGMediaTypeJSONTransformer() transformedValue:components[2].uppercaseString] integerValue];
    if (mediaType == SRGMediaTypeNone) {
        return nil;
    }
    
    SRGVendor vendor = [[SRGVendorJSONTransformer() transformedValue:components[1].uppercaseString] integerValue];
    if (vendor == SRGVendorNone) {
        return nil;
    }
    
    if (self = [super init]) {
        self.uid = components[3];
        self.mediaType = mediaType;
        self.vendor = vendor;
        self.URNString = URNString;
    }
    return self;
}

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return [self initWithURNString:@""];
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
            self.mediaType == SRGMediaTypeAudio ? @"audio" : @"video",
            self.URNString];
}

@end
