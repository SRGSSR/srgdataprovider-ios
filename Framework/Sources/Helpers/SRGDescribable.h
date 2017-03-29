//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

/**
 *  Protocol which can be implemented by classes that need to be recursively describable.
 */
@protocol SRGDescribable <NSObject>

/**
 *  Return the description for display at the specified indentation level.
 */
- (NSString *)srg_descriptionAtLevel:(NSInteger)level;

@end
