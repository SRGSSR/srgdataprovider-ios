//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface SRGTopic : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;

@end
