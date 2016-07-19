//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SRGResourceQuality) {
    SRGResourceQualityStandard,
    SRGResourceQualityHigh
};

typedef NS_ENUM(NSInteger, SRGResourceProtocol) {
    SRGResourceProtocolHLS,
    SRGResourceProtocolHDS,
    SRGResourceProtocolHTTP
};

typedef NS_ENUM(NSInteger, SRGResourceEncoding) {
    SRGResourceEncodingMPEG4
};

@interface SRGResource : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) SRGResourceQuality quality;
@property (nonatomic, readonly) SRGResourceProtocol protocol;
@property (nonatomic, readonly) SRGResourceEncoding encoding;

@end

NS_ASSUME_NONNULL_END
