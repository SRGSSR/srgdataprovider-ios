//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

@interface SRGILList : NSArray

@property(nonatomic, strong) NSDictionary *globalProperties;
@property(nonatomic, copy) id<NSCopying> tag;

@end
