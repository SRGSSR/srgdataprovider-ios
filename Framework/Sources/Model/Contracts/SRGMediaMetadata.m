//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaMetadata.h"

SRGMediaAvailability SRGDataProviderAvailabilityForMediaMetadata(id<SRGMediaMetadata> mediaMetadata)
{
    if (! mediaMetadata) {
        return SRGMediaAvailabilityNone;
    }
    
    // Precedence: Blocking reasons first, then dates. Ending conditions are in both cases tested first.
    NSDate *currentDate = [NSDate date];
    if (mediaMetadata.blockingReason == SRGBlockingReasonEndDate) {
        return SRGMediaAvailabilityNotAvailableAnymore;
    }
    else if (mediaMetadata.blockingReason == SRGBlockingReasonStartDate) {
        return SRGMediaAvailabilityNotYetAvailable;
    }
    else if (mediaMetadata.blockingReason != SRGBlockingReasonNone) {
        return SRGMediaAvailabilityBlocked;
    }
    else if (mediaMetadata.endDate && [mediaMetadata.endDate compare:currentDate] == NSOrderedAscending) {
        return SRGMediaAvailabilityNotAvailableAnymore;
    }
    else if (mediaMetadata.startDate && [currentDate compare:mediaMetadata.startDate] == NSOrderedAscending) {
        return SRGMediaAvailabilityNotYetAvailable;
    }
    else {
        return SRGMediaAvailabilityAvailable;
    }
}
