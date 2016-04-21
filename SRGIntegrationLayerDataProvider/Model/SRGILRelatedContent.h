//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILModelObject.h"

/**
 * Related content information (information and link to related article)
 */
@interface SRGILRelatedContent : SRGILModelObject

/**
 * The related content title
 */
@property (nonatomic, readonly, strong) NSString *title;

/**
 * A description text for the related content
 */
@property (nonatomic, readonly, strong) NSString *text;

/**
 * The URL pointing at the related content
 */
@property (nonatomic, readonly, strong) NSURL *URL;

@end
