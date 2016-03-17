//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILModelObject.h"

#import <UIKit/UIKit.h>

@interface SRGILEventConfig : SRGILModelObject

@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) UIColor *backgroundColor;

@property (nonatomic, readonly) UIColor *textColor;
@property (nonatomic, readonly) UIColor *linkColor;

@property (nonatomic, readonly) UIColor *headerBackgroundColor;
@property (nonatomic, readonly) UIColor *headerTitleColor;

@property (nonatomic, readonly) NSURL *backgroundImageURL;
@property (nonatomic, readonly) NSURL *logoImageURL;

@end
