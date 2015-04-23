//
//  SRGILLiveHeaderData.h
//  SRGILMediaPlayer
//
//  Created by Cédric Foellmi on 03/12/14.
//  Copyright (c) 2014 onekiloparsec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"

@interface SRGILLiveHeaderData : SRGILModelObject

@property(nonatomic, strong) NSDate *startTime;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *subtitle;
@property(nonatomic, strong) NSString *programEpisodeURI;
@property(nonatomic, strong) NSURL *imageURL;

@property(nonatomic, strong) NSDate *contentReceptionDate;

@end
