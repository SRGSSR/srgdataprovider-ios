//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

/**
 *  Reasons for content blocking
 */
typedef NS_ENUM(NSInteger, SRGBlockingReason) {
    /**
     *  The content is not blocked
     */
    SRGBlockingReasonNone = 0,
    /**
     *  The content is blocked because the user is in a country where it is not available
     */
    SRGBlockingReasonGeoblocking,
    /**
     *  The content is blocked for legal reasons
     */
    SRGBlockingReasonLegal,
    /**
     *  The content is a commercial
     */
    SRGBlockingReasonCommercial,
    /**
     *  The content is not suitable for people under 18
     */
    SRGBlockingReasonAgeRating18,
    /**
     *  The content is not suitable for people under 12
     */
    SRGBlockingReasonAgeRating12,
    /**
     *  The content is not available yet
     */
    SRGBlockingReasonStartDate,
    /**
     *  The content is not available anymore
     */
    SRGBlockingReasonEndDate,
    /**
     *  The content is blocked for some unknown reason
     */
    SRGBlockingReasonUnknown
};

/**
 *  Content types
 */
typedef NS_ENUM(NSInteger, SRGContentType) {
    /**
     *  Not specified
     */
    SRGContentTypeNone = 0,
    /**
     *  Episode
     */
    SRGContentTypeEpisode,
    /**
     *  Trailer
     */
    SRGContentTypeTrailer,
    /**
     *  Clip
     */
    SRGContentTypeClip,
    /**
     *  Live
     */
    SRGContentTypeLivestream,
    /**
     *  Live in the future
     */
    SRGContentTypeScheduledLivestream
};

/**
 *  Media encodings
 */
typedef NS_ENUM(NSInteger, SRGEncoding) {
    /**
     *  Not specified
     */
    SRGEncodingNone = 0,
    /**
     *  Video encodings
     */
    SRGEncodingH264,
    SRGEncodingVP6F,
    SRGEncodingMPEG2,
    SRGEncodingWMV3,
    SRGEncodingMPEG4,
    /**
     *  Audio encodings
     */
    SRGEncodingAAC,
    SRGEncodingAAC_HE,
    SRGEncodingMP3,
    SRGEncodingMP2,
    SRGEncodingWMAV2,
};

/**
 *  Media types
 */
typedef NS_ENUM(NSInteger, SRGMediaType) {
    /**
     *  Not specified
     */
    SRGMediaTypeNone = 0,
    /**
     *  Video
     */
    SRGMediaTypeVideo,
    /**
     *  Audio
     */
    SRGMediaTypeAudio
};

/**
 *  Protocols over which medias are served
 */
typedef NS_ENUM(NSInteger, SRGProtocol) {
    /**
     *  Not specified
     */
    SRGProtocolNone = 0,
    /**
     *  HTTP Live Streaming
     */
    SRGProtocolHLS,
    /**
     *  HTTP Dynamic Streaming
     */
    SRGProtocolHDS,
    /**
     *  Real Time Messaging Protocol
     */
    SRGProtocolRTMP,
    /**
     *  HTTP
     */
    SRGProtocolHTTP
};

/**
 *  Media qualities
 */
typedef NS_ENUM(NSInteger, SRGQuality) {
    /**
     *  Not specified
     */
    SRGQualityNone = 0,
    /**
     *  Standard definition
     */
    SRGQualitySD,
    /**
     *  High definition
     */
    SRGQualityHD,
    /**
     *  High quality
     */
    SRGQualityHQ,
};

/**
 *  Types of social or popularity measurement services
 */
typedef NS_ENUM(NSInteger, SRGSocialCountType) {
    /**
     *  Not specified
     */
    SRGSocialCountTypeNone = 0,
    /**
     *  SRG view count service
     */
    SRGSocialCountTypeSRGView,
    /**
     *  SRG like service
     */
    SRGSocialCountTypeSRGLike,
    /**
     *  Facebook
     */
    SRGSocialCountTypeFacebookShare,
    /**
     *  Twitter
     */
    SRGSocialCountTypeTwitterShare,
    /**
     *  Google+
     */
    SRGSocialCountTypeGooglePlusShare,
    /**
     *  WhatsApp
     */
    SRGSocialCountTypeWhatsAppShare
};

/**
 *  Media providing sources
 */
typedef NS_ENUM(NSInteger, SRGSource) {
    /**
     *  Not specified
     */
    SRGSourceNone = 0,
    /**
     *  Editorial
     */
    SRGSourceEditor,
    /**
     *  Trending media identification system
     */
    SRGSourceTrending,
    /**
     *  Recommendation system
     */
    SRGSourceRecommendation
};

/**
 *  Subtitle formats
 */
typedef NS_ENUM(NSInteger, SRGSubtitleFormat) {
    /**
     *  Not specified
     */
    SRGSubtitleFormatNone = 0,
    /**
     *  Timed Text Markup Language
     */
    SRGSubtitleFormatTTML,
    /**
     *  Video Text Tracks
     */
    SRGSubtitleFormatVTT
};

/**
 *  Transmission types
 */
typedef NS_ENUM(NSInteger, SRGTransmission) {
    /**
     *  Not specified
     */
    SRGTransmissionNone,
    /**
     *  Television
     */
    SRGTransmissionTV,
    /**
     *  Radio
     */
    SRGTransmissionRadio,
    /**
     *  Online
     */
    SRGTransmissionOnline,
    /**
     *  Unknown
     */
    SRGTransmissionUnknown
};

/**
 *  Business units which provide content
 */
typedef NS_ENUM(NSInteger, SRGVendor) {
    SRGVendorNone = 0,
    SRGVendorRSI,
    SRGVendorRTR,
    SRGVendorRTS,
    SRGVendorSRF,
    SRGVendorSWI
};

/**
 *  Image dimensions for image retrieval
 */
typedef NS_ENUM(NSInteger, SRGImageDimension) {
    /**
     *  Width
     */
    SRGImageDimensionWidth,
    /**
     *  Height
     */
    SRGImageDimensionHeight
};