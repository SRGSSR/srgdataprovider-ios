//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaExtendedMetadata.h"

SRGBlockingReason SRGBlockingReasonForMediaMetadata(_Nullable id<SRGMediaExtendedMetadata> mediaMetadata, NSDate *date)
{
    if (! mediaMetadata) {
        return SRGBlockingReasonNone;
    }
    
    if (mediaMetadata.originalBlockingReason != SRGBlockingReasonNone) {
        return mediaMetadata.originalBlockingReason;
    }
    
    if (mediaMetadata.endDate && [mediaMetadata.endDate compare:date] == NSOrderedAscending) {
        return SRGBlockingReasonEndDate;
    }
    else if (mediaMetadata.startDate && [date compare:mediaMetadata.startDate] == NSOrderedAscending) {
        return SRGBlockingReasonStartDate;
    }
    else {
        return SRGBlockingReasonNone;
    }
}

SRGTimeAvailability SRGTimeAvailabilityForMediaMetadata(id<SRGMediaExtendedMetadata> mediaMetadata, NSDate *date)
{
    if (! mediaMetadata) {
        return SRGTimeAvailabilityAvailable;
    }
    
    if (mediaMetadata.originalBlockingReason == SRGBlockingReasonStartDate) {
        return SRGTimeAvailabilityNotYetAvailable;
    }
    
    if (mediaMetadata.originalBlockingReason == SRGBlockingReasonEndDate) {
        return SRGTimeAvailabilityNotAvailableAnymore;
    }
    
    if (mediaMetadata.endDate && [mediaMetadata.endDate compare:date] == NSOrderedAscending) {
        return SRGTimeAvailabilityNotAvailableAnymore;
    }
    else if (mediaMetadata.startDate && [date compare:mediaMetadata.startDate] == NSOrderedAscending) {
        return SRGTimeAvailabilityNotYetAvailable;
    }
    else {
        return SRGTimeAvailabilityAvailable;
    }
}
