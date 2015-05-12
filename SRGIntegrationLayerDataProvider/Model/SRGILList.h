//
//  SRGILList.h
//  SRFPlayer
//
//  Created by Cédric Foellmi on 08/09/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRGILList : NSArray

@property(nonatomic, strong) NSDictionary *globalProperties;
@property(nonatomic, copy) id<NSCopying> tag;

@end
