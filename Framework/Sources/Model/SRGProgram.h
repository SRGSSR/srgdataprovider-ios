//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGPresenter.h"
#import "SRGShow.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGProgram : MTLModel <SRGImageMetadata, SRGMetadata, MTLJSONSerializing>

@property (nonatomic, readonly) NSDate *startDate;
@property (nonatomic, readonly) NSDate *endDate;
@property (nonatomic, readonly, nullable) NSURL *URL;
@property (nonatomic, readonly, nullable) SRGShow *show;
@property (nonatomic, readonly, nullable) SRGPresenter *presenter;

@end

NS_ASSUME_NONNULL_END
