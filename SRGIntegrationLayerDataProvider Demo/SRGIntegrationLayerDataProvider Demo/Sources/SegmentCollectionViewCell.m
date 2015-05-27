//
//  SegmentCollectionViewCell.m
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 21.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SegmentCollectionViewCell.h"

@interface SegmentCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *textLabel;

@end

@implementation SegmentCollectionViewCell

- (void)setSegment:(SRGILVideo *)segment
{
    _segment = segment;
    
    self.textLabel.text = segment.title;
}

@end
