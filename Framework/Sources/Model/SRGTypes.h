//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

/**
 *  @name Native service types.
 */

/**
 *  Reasons for content blocking.
 */
typedef NS_ENUM(NSInteger, SRGBlockingReason) {
    /**
     *  The content is not blocked.
     */
    SRGBlockingReasonNone = 0,
    /**
     *  The content is blocked because the user is in a country where it is not available.
     */
    SRGBlockingReasonGeoblocking,
    /**
     *  The content is blocked for legal reasons.
     */
    SRGBlockingReasonLegal,
    /**
     *  The content is a commercial.
     */
    SRGBlockingReasonCommercial,
    /**
     *  The content is not suitable for people under 18.
     */
    SRGBlockingReasonAgeRating18,
    /**
     *  The content is not suitable for people under 12.
     */
    SRGBlockingReasonAgeRating12,
    /**
     *  The content is not available yet.
     */
    SRGBlockingReasonStartDate,
    /**
     *  The content is not available anymore.
     */
    SRGBlockingReasonEndDate,
    /**
     *  The content is blocked for some unknown reason.
     */
    SRGBlockingReasonUnknown
};

/**
 *  Return a suggested error message for a chapter or a media blocking reason (a full episode is blocked, or we just have a media object), nil if none
 */
OBJC_EXPORT NSString * _Nullable SRGMessageForBlockedMediaWithBlockingReason(SRGBlockingReason blockingReason);

/**
 *  Return a suggested error message for a segment blocking reason (just a segment of an episode is blocked, and skipped during the playback), nil if none
 */
OBJC_EXPORT NSString * _Nullable SRGMessageForSkippedSegmentWithBlockingReason(SRGBlockingReason blockingReason);

/**
 *  Content types.
 */
typedef NS_ENUM(NSInteger, SRGContentType) {
    /**
     *  Not specified.
     */
    SRGContentTypeNone = 0,
    /**
     *  Episode.
     */
    SRGContentTypeEpisode,
    /**
     *  Extract.
     */
    SRGContentTypeExtract,
    /**
     *  Trailer.
     */
    SRGContentTypeTrailer,
    /**
     *  Clip.
     */
    SRGContentTypeClip,
    /**
     *  Live.
     */
    SRGContentTypeLivestream,
    /**
     *  Live in the future.
     */
    SRGContentTypeScheduledLivestream
};

/**
 *  Media encodings.
 */
typedef NS_ENUM(NSInteger, SRGEncoding) {
    /**
     *  Not specified.
     */
    SRGEncodingNone = 0,
    /**
     *  Video encodings.
     */
    SRGEncodingH264,
    SRGEncodingVP6F,
    SRGEncodingMPEG2,
    SRGEncodingWMV3,
    /**
     *  Audio encodings.
     */
    SRGEncodingAAC,
    SRGEncodingAAC_HE,
    SRGEncodingMP3,
    SRGEncodingMP2,
    SRGEncodingWMAV2
};

/**
 *  Media types.
 */
typedef NS_ENUM(NSInteger, SRGMediaType) {
    /**
     *  Not specified.
     */
    SRGMediaTypeNone = 0,
    /**
     *  Video.
     */
    SRGMediaTypeVideo,
    /**
     *  Audio.
     */
    SRGMediaTypeAudio
};

/**
 *  Module types.
 */
typedef NS_ENUM(NSInteger, SRGModuleType) {
    /**
     *  Not specified.
     */
    SRGModuleTypeNone = 0,
    /**
     *  Event.
     */
    SRGModuleTypeEvent
};

/**
 *  Content presentation types.
 */
typedef NS_ENUM(NSInteger, SRGPresentation) {
    /**
     *  Not specified.
     */
    SRGPresentationNone = 0,
    /**
     *  Default presentation.
     */
    SRGPresentationDefault,
    /**
     *  360° presentation.
     */
    SRGPresentation360
};

/**
 *  Protocols over which medias are served.
 */
typedef NS_ENUM(NSInteger, SRGProtocol) {
    /**
     *  Not specified.
     */
    SRGProtocolNone = 0,
    /**
     *  HTTP Live Streaming.
     */
    SRGProtocolHLS,
    /**
     *  HTTP DVR Live Streaming.
     */
    SRGProtocolHLS_DVR,
    /**
     *  HTTP Dynamic Streaming.
     */
    SRGProtocolHDS,
    /**
     *  HTTP DVR Dynamic Streaming.
     */
    SRGProtocolHDS_DVR,
    /**
     *  Real Time Messaging Protocol.
     */
    SRGProtocolRTMP,
    /**
     *  HTTP.
     */
    SRGProtocolHTTP,
    /**
     *  HTTPS.
     */
    SRGProtocolHTTPS,
    /**
     *  HTTP M3U.
     */
    SRGProtocolHTTP_M3U,
    /**
     *  HTTP MP3 stream.
     */
    SRGProtocolHTTP_MP3Stream
};

/**
 *  Media qualities.
 */
typedef NS_ENUM(NSInteger, SRGQuality) {
    /**
     *  Not specified.
     */
    SRGQualityNone = 0,
    /**
     *  Standard definition.
     */
    SRGQualitySD,
    /**
     *  High definition.
     */
    SRGQualityHD,
    /**
     *  High quality.
     */
    SRGQualityHQ,
};

/**
 *  Types of social or popularity measurement services.
 */
typedef NS_ENUM(NSInteger, SRGSocialCountType) {
    /**
     *  Not specified.
     */
    SRGSocialCountTypeNone = 0,
    /**
     *  SRG view count service.
     */
    SRGSocialCountTypeSRGView,
    /**
     *  SRG like service.
     */
    SRGSocialCountTypeSRGLike,
    /**
     *  Facebook.
     */
    SRGSocialCountTypeFacebookShare,
    /**
     *  Twitter.
     */
    SRGSocialCountTypeTwitterShare,
    /**
     *  Google+.
     */
    SRGSocialCountTypeGooglePlusShare,
    /**
     *  WhatsApp.
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
 *  Transmission types.
 */
typedef NS_ENUM(NSInteger, SRGTransmission) {
    /**
     *  Not specified.
     */
    SRGTransmissionNone = 0,
    /**
     *  Television.
     */
    SRGTransmissionTV,
    /**
     *  Radio.
     */
    SRGTransmissionRadio,
    /**
     *  Online.
     */
    SRGTransmissionOnline,
    /**
     *  Unknown.
     */
    SRGTransmissionUnknown
};

/**
 *  Content producers and providers.
 */
typedef NS_ENUM(NSInteger, SRGVendor) {
    SRGVendorNone = 0,
    /**
     *  SRG SSR business units.
     */
    SRGVendorRSI,
    SRGVendorRTR,
    SRGVendorRTS,
    SRGVendorSRF,
    SRGVendorSWI,
    /**
     *  Regional radios and televisions.
     */
    SRGVendorTVO,
    SRGVendorCanalAlpha
};

/**
 *  @name Data provider library types.
 */

/**
 *  Image dimensions for image retrieval.
 */
typedef NS_ENUM(NSInteger, SRGImageDimension) {
    /**
     *  Width.
     */
    SRGImageDimensionWidth,
    /**
     *  Height.
     */
    SRGImageDimensionHeight
};
