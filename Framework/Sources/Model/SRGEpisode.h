//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Mantle/Mantle.h>

@interface SRGEpisode : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSURL *imageURL;

@end
