//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SRGSocialCountType) {
    SRGSocialCountTypeSRGView,
    SRGSocialCountTypeSRGLike,
    SRGSocialCountTypeFacebookShare,
    SRGSocialCountTypeTwitterShare,
    SRGSocialCountTypeGooglePlusShare,
    SRGSocialCountTypeWhatsAppShare
};

@interface SRGSocialCount : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) SRGSocialCountType type;
@property (nonatomic, readonly) NSInteger value;

@end

NS_ASSUME_NONNULL_END
