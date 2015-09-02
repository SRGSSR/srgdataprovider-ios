//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILSocialCounts.h"

@interface SRGILSocialCounts ()
@property(nonatomic, assign) NSInteger facebookShare;
@property(nonatomic, assign) NSInteger googleShare;
@property(nonatomic, assign) NSInteger srgLike;
@property(nonatomic, assign) NSInteger srgView;
@property(nonatomic, assign) NSInteger twitterShare;
@end

@implementation SRGILSocialCounts

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.facebookShare = [[dictionary objectForKey:@"fbShare"] integerValue];
        self.googleShare = [[dictionary objectForKey:@"googleShare"] integerValue];
        self.srgLike = [[dictionary objectForKey:@"srgLike"] integerValue];
        self.srgView = [[dictionary objectForKey:@"srgView"] integerValue];
        self.twitterShare = [[dictionary objectForKey:@"twitterShare"] integerValue];
    }
    return self;
}

@end
