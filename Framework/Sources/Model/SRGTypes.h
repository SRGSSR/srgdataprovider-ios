//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

/**
 * Native Integration Layer types
 */

typedef NS_ENUM(NSInteger, SRGBlockingReason) {
    SRGBlockingReasonNone = 0,
    SRGBlockingReasonGeoblocking,
    SRGBlockingReasonLegal,
    SRGBlockingReasonCommercial,
    SRGBlockingReasonAgeRating18,
    SRGBlockingReasonAgeRating12,
    SRGBlockingReasonStartDate,
    SRGBlockingReasonEndDate,
    SRGBlockingReasonUnknown
};

typedef NS_ENUM(NSInteger, SRGContentType) {
    SRGContentTypeNone = 0,
    SRGContentTypeEpisode,
    SRGContentTypeTrailer,
    SRGContentTypeClip,
    SRGContentTypeLivestream,
    SRGContentTypeScheduledLivestream
};

typedef NS_ENUM(NSInteger, SRGEncoding) {
    SRGEncodingNone = 0,
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

typedef NS_ENUM(NSInteger, SRGMediaType) {
    SRGMediaTypeNone = 0,
    SRGMediaTypeVideo,
    SRGMediaTypeAudio
};

typedef NS_ENUM(NSInteger, SRGProtocol) {
    SRGProtocolNone = 0,
    SRGProtocolHLS,
    SRGProtocolHDS,
    SRGProtocolRTMP,
    SRGProtocolHTTP
};

typedef NS_ENUM(NSInteger, SRGQuality) {
    SRGQualityNone = 0,
    SRGQualitySD,
    SRGQualityHD,
    SRGQualityHQ,
};

typedef NS_ENUM(NSInteger, SRGSocialCountType) {
    SRGSocialCountTypeNone = 0,
    SRGSocialCountTypeSRGView,
    SRGSocialCountTypeSRGLike,
    SRGSocialCountTypeFacebookShare,
    SRGSocialCountTypeTwitterShare,
    SRGSocialCountTypeGooglePlusShare,
    SRGSocialCountTypeWhatsAppShare
};

typedef NS_ENUM(NSInteger, SRGSource) {
    SRGSourceNone = 0,
    SRGSourceEditor,
    SRGSourceTrending,
    SRGSourceRecommendation
};

typedef NS_ENUM(NSInteger, SRGSubtitleFormat) {
    SRGSubtitleFormatNone = 0,
    SRGSubtitleFormatTTML,
    SRGSubtitleFormatVTT
};

typedef NS_ENUM(NSInteger, SRGTransmission) {
    SRGTransmissionNone,
    SRGTransmissionTV,
    SRGTransmissionRadio,
    SRGTransmissionOnline,
    SRGTransmissionUnknown
};

typedef NS_ENUM(NSInteger, SRGVendor) {
    SRGVendorNone = 0,
    SRGVendorRSI,
    SRGVendorRTR,
    SRGVendorRTS,
    SRGVendorSRF,
    SRGVendorSWI
};


/**
 * Other types
 */

typedef NS_ENUM(NSInteger, SRGImageDimension) {
    SRGImageDimensionWidth,
    SRGImageDimensionHeight
};
