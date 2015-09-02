//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>
#import "SRGILVideo.h"

@interface SegmentCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) SRGILVideo *segment;

- (void)updateAppearanceWithTime:(CMTime)time;

@end
