//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILModelObject.h"

@interface SRGILSearchResult : SRGILModelObject

@property(nonatomic,readonly,strong) NSString *title;
@property(nonatomic,readonly,strong) NSString *resultDescription;
@property(nonatomic,readonly,strong) NSDate *publishedDate;
@property(nonatomic,readonly,strong) NSURL *imageURL;
@property(nonatomic,readonly) NSInteger duration;

@property(nonatomic,readonly,strong) NSString *assetGroupId;
@property(nonatomic,readonly,strong) NSString *assetGroupTitle;
@property(nonatomic,readonly,strong) NSString *assetSetId;
@property(nonatomic,readonly,strong) NSString *assetSetTitle;

@end
