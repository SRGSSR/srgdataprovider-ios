//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SRGDataProvider)

/**
 *  Helper method for custom recursive descriptions
 */
- (id)srg_formattedObjectAtLevel:(NSInteger)level;

@end

NS_ASSUME_NONNULL_END
