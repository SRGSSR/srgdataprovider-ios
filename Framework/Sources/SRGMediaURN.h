//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import <SRGDataProvider/SRGDataProvider.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGMediaURN : NSObject

/**
 *  The unique media identifier
 */
@property (nonatomic, readonly) NSString *uid;

/**
 *  The media type
 */
@property (nonatomic, readonly) SRGMediaType mediaType;

/**
 *  The business unit which supplied the media
 */
@property (nonatomic, readonly) SRGVendor vendor;

/**
 *  The URN string representation
 */
@property (nonatomic, readonly) NSString *URN;

/**
 *  The default initializer
 *  An URN string has 4 or 5 elements (depend of ais team), separate with colons
 *  With removing "ais" element. we have in this order:
 *  "urn:[vendor]:[mediaType]:[uid]", all in lower case
 *  If it's not respected, a nil object will be return.
 */
- (_Nullable instancetype)initWithURN:(NSString *)URN NS_DESIGNATED_INITIALIZER;

NS_ASSUME_NONNULL_END

@end

@interface SRGMediaURN (Unavailable)

- (_Nullable instancetype)init NS_UNAVAILABLE;

@end
