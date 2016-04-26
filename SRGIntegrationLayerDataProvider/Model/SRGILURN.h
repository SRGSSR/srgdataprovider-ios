//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILModelConstants.h"

extern NSString * _Nonnull const defaultURNStringSeparator;

/**
 *  This class is meant to ease the handling of URN strings. 
 *  It does not correspond to any object class in the IL data scheme.
 *
 *  We support today 3 media types which are playable:
 *  - Video (for a video/play call)
 *  - Audio (for a audio/play call)
 *  - VideoSet (for a video/playByAssetSetId call)
 *
 */
@interface SRGILURN : NSObject

@property(nonatomic, strong, readonly, nonnull) NSString *prefix;
@property(nonatomic, strong, readonly, nonnull) NSString *businessUnit;
@property(nonatomic, assign, readonly) SRGILMediaType mediaType;
@property(nonatomic, strong, readonly, nonnull) NSString *identifier;

+ (nullable SRGILURN *)URNWithString:(nonnull NSString *)urnString;
+ (nullable SRGILURN *)URNForIdentifier:(nonnull NSString *)identifier mediaType:(SRGILMediaType)type businessUnit:(nonnull NSString *)bu;

+ (nullable NSString *)identifierForURNString:(nonnull NSString *)urnString;

- (nonnull NSString *)URNStringWithSeparator:(nonnull NSString *)separator;
- (nonnull NSString *)URNString; // Using ':' as default separator

@end
