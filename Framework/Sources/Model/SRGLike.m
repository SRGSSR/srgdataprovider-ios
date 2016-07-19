//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGLike.h"

@interface SRGLike ()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic, copy) NSString *vendor;
@property (nonatomic, copy) NSString *URN;

@property (nonatomic) NSArray<SRGSocialCount *> *socialCounts;

@end

@implementation SRGLike

@end
