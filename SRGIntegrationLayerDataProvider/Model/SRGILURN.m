//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILURN.h"

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

    urn.identifier = components[components.count-1];
    
    return urn;
}

+ (NSString *)identifierForURNString:(NSString *)urnString
{
    return [[urnString componentsSeparatedByString:@":"] lastObject];
}

@end
