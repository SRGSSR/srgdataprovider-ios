//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

/**
 *  Standard transformers for use with Mantle
 */
OBJC_EXPORT NSValueTransformer *SRGBlockingReasonJSONTransformer(void);
OBJC_EXPORT NSValueTransformer *SRGContentTypeJSONTransformer(void);
OBJC_EXPORT NSValueTransformer *SRGEncodingJSONTransformer(void);
OBJC_EXPORT NSValueTransformer *SRGMediaTypeJSONTransformer(void);
OBJC_EXPORT NSValueTransformer *SRGProtocolJSONTransformer(void);
OBJC_EXPORT NSValueTransformer *SRGQualityJSONTransformer(void);
OBJC_EXPORT NSValueTransformer *SRGSocialCountTypeJSONTransformer(void);
OBJC_EXPORT NSValueTransformer *SRGSourceJSONTransformer(void);
OBJC_EXPORT NSValueTransformer *SRGSubtitleFormatJSONTransformer(void);
OBJC_EXPORT NSValueTransformer *SRGTransmissionJSONTransformer(void);
OBJC_EXPORT NSValueTransformer *SRGVendorJSONTransformer(void);

OBJC_EXPORT NSValueTransformer *SRGISO8601DateJSONTransformer(void);
OBJC_EXPORT NSValueTransformer *SRGHexColorJSONTransformer(void);
