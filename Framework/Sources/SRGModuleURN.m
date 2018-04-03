//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModuleURN.h"

#import "SRGJSONTransformers.h"

@interface SRGModuleURN ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *sectionUid;
@property (nonatomic) SRGModuleType moduleType;
@property (nonatomic) SRGVendor vendor;
@property (nonatomic, copy) NSString *URNString;

@end

@implementation SRGModuleURN

#pragma mark Class methods

+ (SRGShowURN *)moduleURNWithString:(NSString *)URNString
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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return [self initWithURNString:@""];
}

#pragma clang diagnostic pop

#pragma mark Parsing

- (BOOL)parseURNString:(NSString *)URNString
{
    NSMutableArray<NSString *> *components = [[URNString componentsSeparatedByString:@":"] mutableCopy];
    if ((components.count != 5 && components.count != 6) || ! [components.firstObject.lowercaseString isEqualToString:@"urn"]
            || ! [components[2].lowercaseString isEqualToString:@"module"]) {
        return NO;
    }
    
    SRGModuleType moduleType = [[SRGModuleTypeJSONTransformer() transformedValue:components[3].uppercaseString] integerValue];
    if (moduleType == SRGModuleTypeNone) {
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
    
    NSString *sectionUid = nil;
    if (components.count == 6) {
        sectionUid = components[5];
        if (sectionUid.length == 0) {
            return nil;
        }
    }
    
    self.uid = uid;
    self.sectionUid = sectionUid;
    self.moduleType = moduleType;
    self.vendor = vendor;
    
    return YES;
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGModuleURN *otherModuleURN = object;
    return [self.URNString isEqualToString:otherModuleURN.URNString];
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
    return [NSString stringWithFormat:@"<%@: %p; uid: %@; sectionUid: %@; moduleType: %@; URNString: %@>",
            [self class],
            self,
            self.uid,
            self.sectionUid,
            [[SRGModuleTypeJSONTransformer() reverseTransformedValue:@(self.moduleType)] lowercaseString],
            self.URNString];
}

@end
