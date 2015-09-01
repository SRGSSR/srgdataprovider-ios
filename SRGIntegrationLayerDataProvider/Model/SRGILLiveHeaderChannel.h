//
//  SRGILLiveHeaderChannel.h
//  SRGILMediaPlayer
//
//  Created by Cédric Foellmi on 03/12/14.
//  Copyright (c) 2014 onekiloparsec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SRGILModelObject.h"
#import "SRGILLiveHeaderData.h"

@interface SRGILLiveHeaderChannel : SRGILModelObject

@property(nonatomic, strong) SRGILLiveHeaderData *now;
@property(nonatomic, strong) SRGILLiveHeaderData *next;

@end
