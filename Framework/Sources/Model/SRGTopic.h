//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGTopic : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
