//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import "SRGILDataProvider.h"

@class SRGILRequestsManager;

@interface SRGILDataProvider ()

@property(nonatomic, strong) NSMutableDictionary *identifiedMedias;
@property(nonatomic, strong) NSMutableDictionary *identifiedShows;
@property(nonatomic, strong) SRGILRequestsManager *requestManager;

@end

