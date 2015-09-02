//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

#import "SRGILModelObject.h"
#import "SRGILLiveHeaderData.h"

@interface SRGILLiveHeaderChannel : SRGILModelObject

@property(nonatomic, strong) SRGILLiveHeaderData *now;
@property(nonatomic, strong) SRGILLiveHeaderData *next;

@end
