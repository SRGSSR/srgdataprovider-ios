//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGModel.h"
#import "SRGTypes.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A resource provides a media URL and its description (quality, encoding, etc.).
 */
@interface SRGResource : SRGModel

/**
 *  The media URL.
 */
@property (nonatomic, readonly) NSURL *URL;

/**
 *  The media quality (standard, high definition, ...).
 */
@property (nonatomic, readonly) SRGQuality quality;

/**
 *  The recommended way to present the media.
 */
@property (nonatomic, readonly) SRGPresentation presentation;

/**
 *  The media MIME type.
 */
@property (nonatomic, readonly, copy, nullable) NSString *MIMEType;

/**
 *  The streaming method.
 */
@property (nonatomic, readonly) SRGStreamingMethod streamingMethod;

/**
 *  The stream type.
 */
@property (nonatomic, readonly) SRGStreamType streamType;

/**
 *  The media container.
 */
@property (nonatomic, readonly) SRGMediaContainer mediaContainer;

/**
 *  The audio codec.
 */
@property (nonatomic, readonly) SRGAudioCodec audioCodec;

/**
 *  The video codec.
 */
@property (nonatomic, readonly) SRGVideoCodec videoCodec;

/**
 *  The list of analytics labels which should be supplied in SRG Analytics events
 *  (https://github.com/SRGSSR/srganalytics-ios).
 */
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *analyticsLabels;

@end

NS_ASSUME_NONNULL_END
