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
    
    NSDate *nowDate = [NSDate date];
    if (mediaMetadata.startDate && [nowDate compare:mediaMetadata.startDate] == NSOrderedAscending) {
        return SRGMediaAvailabilityNotYetAvailable;
    }
    else if (mediaMetadata.endDate && [mediaMetadata.endDate compare:nowDate] == NSOrderedAscending) {
        return SRGMediaAvailabilityNotAvailableAnymore;
    }
    else {
        return SRGMediaAvailabilityAvailable;
    }
}
