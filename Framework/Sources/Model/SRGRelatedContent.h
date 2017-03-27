//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMetadata.h"
#import "SRGModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Content related to a media (e.g. articles providing more information about a subject). Related contents are
 *  simple links to external web pages.
 */
@interface SRGRelatedContent : SRGModel <SRGMetadata>

/**
 *  The unique identifier of the content.
 */
@property (nonatomic, readonly, copy) NSString *uid;

/**
 *  The URL where the content resides.
 */
@property (nonatomic, readonly) NSURL *URL;

@end

NS_ASSUME_NONNULL_END
