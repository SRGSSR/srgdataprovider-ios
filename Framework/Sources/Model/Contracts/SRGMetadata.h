//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol for standard metadata association
 */
@protocol SRGMetadata <NSObject>

/**
 *  The title of the content
 */
@property (nonatomic, readonly, copy) NSString *title;

/**
 *  A short introductory text
 */
@property (nonatomic, readonly, copy, nullable) NSString *lead;

/**
 *  A more comprehensive description of the content
 */
@property (nonatomic, readonly, copy, nullable) NSString *summary;

@end

NS_ASSUME_NONNULL_END
