//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMedia.h"
#import "SRGResource.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRGChapter : SRGMedia

@property (nonatomic, readonly) NSInteger position;
@property (nonatomic, readonly) NSTimeInterval markIn;
@property (nonatomic, readonly) NSTimeInterval markOut;

@property (nonatomic, readonly) NSArray<SRGResource *> *resources;

@end

NS_ASSUME_NONNULL_END
