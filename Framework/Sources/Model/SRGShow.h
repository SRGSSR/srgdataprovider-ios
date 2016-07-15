//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Mantle/Mantle.h>

@interface SRGShow : MTLModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSURL *imageURL;
@property (nonatomic) NSURL *homepageURL;

@end
