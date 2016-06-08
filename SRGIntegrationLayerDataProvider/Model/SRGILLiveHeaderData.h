//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILModelObject.h"

@interface SRGILLiveHeaderData : SRGILModelObject

@property(nonatomic, strong) NSDate *startTime;
@property(nonatomic, strong) NSDate *endTime;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *subtitle;
@property(nonatomic, strong) NSString *programEpisodeURI;
@property(nonatomic, strong) NSURL *imageURL;

@property(nonatomic, strong) NSDate *contentReceptionDate;

@end
