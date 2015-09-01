//
//  SRGSocialCounts.h
//  SRFPlayer
//
//  Created by Cédric Foellmi on 18/07/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
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
