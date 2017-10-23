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

SRGMediaTimeAvailability SRGDataProviderTimeAvailabilityForMediaMetadata(id<SRGMediaExtendedMetadata> mediaMetadata, NSDate *date)
{
    if (! mediaMetadata) {
        return SRGMediaTimeAvailabilityAvailable;
    }
    
    if (mediaMetadata.originalBlockingReason == SRGBlockingReasonStartDate) {
        return SRGMediaTimeAvailabilityNotYetAvailable;
    }
    else if (mediaMetadata.originalBlockingReason == SRGBlockingReasonEndDate) {
        return SRGMediaTimeAvailabilityNotAvailableAnymore;
    }
    else {
        if (mediaMetadata.startDate && [date compare:mediaMetadata.startDate] == NSOrderedAscending) {
            return SRGMediaTimeAvailabilityNotYetAvailable;
        }
        else if (mediaMetadata.endDate && [mediaMetadata.endDate compare:date] == NSOrderedAscending) {
            return SRGMediaTimeAvailabilityNotAvailableAnymore;
        }
        else {
            return SRGMediaTimeAvailabilityAvailable;
        }
    }
}
