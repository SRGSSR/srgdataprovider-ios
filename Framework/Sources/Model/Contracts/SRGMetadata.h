//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Match group definitions from IL xsd files

@protocol SRGMetadata <NSObject>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *lead;
@property (nonatomic, readonly, copy, nullable) NSString *summary;

@end

NS_ASSUME_NONNULL_END
