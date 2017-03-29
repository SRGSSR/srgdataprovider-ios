//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SRGDataProvider)

/**
 *  Return an object suited for recursive description.
 */
- (id)srg_formattedObjectAtLevel:(NSInteger)level;

@end

NS_ASSUME_NONNULL_END
