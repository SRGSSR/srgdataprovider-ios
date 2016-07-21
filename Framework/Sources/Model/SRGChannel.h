//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGImageMetadata.h"
#import "SRGMetadata.h"
#import "SRGProgram.h"
#import "SRGTypes.h"

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGChannel : MTLModel <SRGImageMetadata, SRGMetadata, MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly) SRGTransmission transmission;
@property (nonatomic, readonly, nullable) NSURL *timetableURL;
@property (nonatomic, readonly, nullable) SRGProgram *currentProgram;
@property (nonatomic, readonly, nullable) SRGProgram *nextProgram;

@end

NS_ASSUME_NONNULL_END
