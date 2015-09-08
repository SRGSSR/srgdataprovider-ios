//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

/**
 *  A subclass of NSArray that can also store global properties, and a tag.
 */
@interface SRGILList : NSArray

@property(nonatomic, strong) NSDictionary *globalProperties;
@property(nonatomic, copy) id<NSCopying> tag;

@end
