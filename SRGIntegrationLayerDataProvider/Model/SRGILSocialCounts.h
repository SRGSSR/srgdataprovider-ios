//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"

@interface SRGILSocialCounts : SRGILModelObject

@property(nonatomic, assign, readonly) NSInteger facebookShare;
@property(nonatomic, assign, readonly) NSInteger googleShare;
@property(nonatomic, assign, readonly) NSInteger srgLike;
@property(nonatomic, assign, readonly) NSInteger srgView;
@property(nonatomic, assign, readonly) NSInteger twitterShare;

@end
