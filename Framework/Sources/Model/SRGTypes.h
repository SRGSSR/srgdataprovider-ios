//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SRGMediaType) {
    SRGMediaTypeVideo,
    SRGMediaTypeAudio
};

typedef NS_ENUM(NSInteger, SRGContentType) {
    SRGContentTypeEpisode
};

typedef NS_ENUM(NSInteger, SRGSource) {
    SRGSourceEditor,
    SRGSourceTrending
};

typedef NS_ENUM(NSInteger, SRGEncoding) {
    SRGEncodingMPEG4,
    SRGEncodingH264
};

typedef NS_ENUM(NSInteger, SRGProtocol) {
    SRGProtocolHLS,
    SRGProtocolHDS,
    SRGProtocolHTTP
};

typedef NS_ENUM(NSInteger, SRGQuality) {
    SRGQualityStandard,
    SRGQualityHigh
};

typedef NS_ENUM(NSInteger, SRGSocialCountType) {
    SRGSocialCountTypeSRGView,
    SRGSocialCountTypeSRGLike,
    SRGSocialCountTypeFacebookShare,
    SRGSocialCountTypeTwitterShare,
    SRGSocialCountTypeGooglePlusShare,
    SRGSocialCountTypeWhatsAppShare
};
