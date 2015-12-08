//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

@class SRGILURLComponents;

/**
 *  A subclass of NSArray that can also store global properties, and a tag.
 */
@interface SRGILList : NSArray

@property(nonatomic, strong) NSDictionary *globalProperties;
@property(nonatomic, strong) SRGILURLComponents *URLComponents;

@end
