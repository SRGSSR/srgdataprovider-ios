//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaMetadata.h"

SRGBlockingReason SRGBlockingReasonForMediaMetadata(_Nullable id<SRGMediaMetadata> mediaMetadata)
{
    if (! mediaMetadata) {
        return SRGBlockingReasonNone;
    }
    
    if (mediaMetadata.blockingReason != SRGBlockingReasonNone) {
        return mediaMetadata.blockingReason;
    }
    
    NSDate *currentDate = [NSDate date];
    if (mediaMetadata.endDate && [mediaMetadata.endDate compare:currentDate] == NSOrderedAscending) {
        return SRGBlockingReasonEndDate;
    }
    else if (mediaMetadata.startDate && [currentDate compare:mediaMetadata.startDate] == NSOrderedAscending) {
        return SRGBlockingReasonStartDate;
    }
    else {
        return SRGBlockingReasonNone;
    }
}
