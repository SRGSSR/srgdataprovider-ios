//
//  SegmentCollectionViewCell.h
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 21.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILVideo.h"
#import <CoreMedia/CoreMedia.h>
#import <UIKit/UIKit.h>

@interface SegmentCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) SRGILVideo *segment;

- (void)updateAppearanceWithTime:(CMTime)time;

@end
