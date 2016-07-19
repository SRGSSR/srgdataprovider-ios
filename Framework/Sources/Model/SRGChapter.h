//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMedia.h"
#import "SRGResource.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRGChapter : SRGMedia

@property (nonatomic) NSInteger position;
@property (nonatomic) NSTimeInterval markIn;
@property (nonatomic) NSTimeInterval markOut;

@property (nonatomic) NSArray<SRGResource *> *resources;

@end

NS_ASSUME_NONNULL_END
