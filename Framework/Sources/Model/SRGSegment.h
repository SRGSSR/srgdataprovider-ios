//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaMetadata.h"
#import "SRGSubtitle.h"
#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGSegment : MTLModel <SRGMediaMetadata, MTLJSONSerializing>

@property (nonatomic, copy, readonly, nullable) NSString *fullLengthURN;
@property (nonatomic, readonly) NSInteger position;
@property (nonatomic, readonly) NSTimeInterval markIn;
@property (nonatomic, readonly) NSTimeInterval markOut;
@property (nonatomic, readonly) SRGBlockingReason blockingReason;
@property (nonatomic, readonly, nullable) NSArray<SRGSubtitle *> *subtitles;

@end

NS_ASSUME_NONNULL_END
