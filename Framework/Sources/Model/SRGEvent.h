//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMetadata.h"
#import "SRGSection.h"
#import "SRGTypes.h"

#import <Mantle/Mantle.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGEvent : MTLModel <SRGMetadata, MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly) NSDate *startDate;
@property (nonatomic, readonly) NSDate *endDate;
@property (nonatomic, readonly) UIColor *headerBackgroundColor;
@property (nonatomic, readonly) UIColor *headerTitleColor;
@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly, nullable) UIColor *textColor;
@property (nonatomic, readonly, nullable) UIColor *linkColor;
@property (nonatomic, readonly, copy, nullable) NSString *websiteTitle;
@property (nonatomic, readonly, nullable) NSURL *websiteURL;
@property (nonatomic, readonly, nullable) NSArray<SRGSection *> *sections;

@end

@interface SRGEvent (Images)

- (NSURL *)backgroundImageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;
- (nullable NSURL *)logoImageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;
- (nullable NSURL *)keyVisualImageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
