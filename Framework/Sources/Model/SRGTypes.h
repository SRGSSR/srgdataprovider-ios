//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SRGImageDimension) {
    SRGImageDimensionWidth,
    SRGImageDimensionHeight
};

typedef NS_ENUM(NSInteger, SRGBlockingReason) {
    SRGBlockingReasonGeoblocking,
    SRGBlockingReasonLegal,
    SRGBlockingReasonCommercial,
    SRGBlockingReasonAgeRating18,
    SRGBlockingReasonAgeRating12,
    SRGBlockingReasonStartDate,
    SRGBlockingReasonEndDate,
    SRGBlockingReasonUnknown
};

typedef NS_ENUM(NSInteger, SRGMediaType) {
    SRGMediaTypeVideo,
    SRGMediaTypeAudio
};

typedef NS_ENUM(NSInteger, SRGContentType) {
    SRGContentTypeEpisode,
    SRGContentTypeTrailer,
    SRGContentTypeClip,
    SRGContentTypeLivestream,
    SRGContentTypeScheduledLivestream
};

typedef NS_ENUM(NSInteger, SRGSource) {
    SRGSourceEditor,
    SRGSourceTrending,
    SRGSourceRecommendation
};

typedef NS_ENUM(NSInteger, SRGEncoding) {
    // Video
    SRGEncodingH264,
    SRGEncodingVP6F,
    SRGEncodingMPEG2,
    SRGEncodingWMV3,
    SRGEncodingMPEG4,
    // Audio
    SRGEncodingAAC,
    SRGEncodingAAC_HE,
    SRGEncodingMP3,
    SRGEncodingMP2,
    SRGEncodingWMAV2,
};

typedef NS_ENUM(NSInteger, SRGProtocol) {
    SRGProtocolHLS,
    SRGProtocolHDS,
    SRGProtocolRTMP,
    SRGProtocolHTTP
};

typedef NS_ENUM(NSInteger, SRGQuality) {
    SRGQualitySD,
    SRGQualityHD,
    SRGQualityHQ,
};

typedef NS_ENUM(NSInteger, SRGSocialCountType) {
    SRGSocialCountTypeSRGView,
    SRGSocialCountTypeSRGLike,
    SRGSocialCountTypeFacebookShare,
    SRGSocialCountTypeTwitterShare,
    SRGSocialCountTypeGooglePlusShare,
    SRGSocialCountTypeWhatsAppShare
};

typedef NS_ENUM(NSInteger, SRGSubtitleFormat) {
    SRGSubtitleFormatTTML,
    SRGSubtitleFormatVTT
};

typedef NS_ENUM(NSInteger, SRGVendor) {
    SRGVendorRSI,
    SRGVendorRTR,
    SRGVendorRTS,
    SRGVendorSRF,
    SRGVendorSWI
};
