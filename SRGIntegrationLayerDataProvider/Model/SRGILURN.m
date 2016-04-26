//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILURN.h"

NSString * const defaultURNStringSeparator = @":";

@interface SRGILURN ()
@property(nonatomic, strong) NSString *prefix;
@property(nonatomic, strong) NSString *businessUnit;
@property(nonatomic, assign) SRGILMediaType mediaType;
@property(nonatomic, strong) NSString *identifier;
@end

@implementation SRGILURN

+ (SRGILURN *)URNWithString:(NSString *)urnString
{
    NSArray *components = [urnString componentsSeparatedByString:@":"];
    if (components.count < 4) {
        return nil;
    }
    
    SRGILURN *urn = [[SRGILURN alloc] init];
    urn.prefix = components[0];
    urn.businessUnit = components[1];
    urn.mediaType = SRGILMediaTypeUndefined;
    
    // Going backward because of the intermettitent presence of 'ais' component... (yes, we have a gang of winners over there...
    // did I told you about requests returning 200 with 404 in the body?...)
    NSString *mediaTypeString = components[components.count-2];
    if ([mediaTypeString.lowercaseString isEqualToString:@"video"]) {
        urn.mediaType = SRGILMediaTypeVideo;
    }
    else if ([mediaTypeString.lowercaseString isEqualToString:@"audio"]) {
        urn.mediaType = SRGILMediaTypeAudio;
    }
    else if ([mediaTypeString.lowercaseString isEqualToString:@"videoset"]) {
        urn.mediaType = SRGILMediaTypeVideoSet;
    }

    urn.identifier = components[components.count-1];
    
    return urn;
}

+ (NSString *)identifierForURNString:(NSString *)urnString
{
    return [[urnString componentsSeparatedByString:@":"] lastObject];
}

+ (SRGILURN *)URNForIdentifier:(NSString *)identifier mediaType:(SRGILMediaType)type businessUnit:(NSString *)bu
{
    NSAssert(bu, @"Missing BU?");
    NSAssert(type != SRGILMediaTypeUndefined, @"Undefined?");
    
    SRGILURN *urn = [SRGILURN URNWithString:identifier];
    if (urn) {
        // If identifier is in fact already an URN string, just returns the URN.
        return urn;
    }
    
    urn = [[SRGILURN alloc] init];
    urn.prefix = @"urn";
    urn.businessUnit = bu;
    urn.mediaType = type;
    urn.identifier = identifier;
    
    return urn;
}

- (NSString *)URNStringWithSeparator:(NSString *)separator
{
    NSMutableArray *components = [NSMutableArray array];
    if (self.prefix) {
        [components addObject:self.prefix];
    }
    [components addObject:self.businessUnit];
    [components addObject:(self.mediaType == SRGILMediaTypeVideo || self.mediaType == SRGILMediaTypeVideoSet) ? @"video": @"audio"];
    [components addObject:self.identifier];
    
    if (!separator) {
        separator = defaultURNStringSeparator;
    }
    
    return [components componentsJoinedByString:separator];
}

- (nonnull NSString *)URNString
{
    return [self URNStringWithSeparator:@":"];
}

@end
