//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describe a page of content. You never instantiate such objects, they are merely returned from requests when a
 *  next page of content is available.
 */
@interface SRGPage : NSObject <NSCopying>

/**
 *  The page size
 *
 *  @discussion The page size is the requested page size, not the actual number of records returned for the page
 *              (this information can be extracted by counting the number of objects returned by the request)
 */
@property (nonatomic, readonly) NSInteger size;

/**
 *  The page number, starting at 0 for the first page
 */
@property (nonatomic, readonly) NSInteger number;

@end

@interface SRGPage (Unavailable)

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
