//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaExtendedMetadata.h"

SRGBlockingReason SRGBlockingReasonForMediaMetadata(_Nullable id<SRGMediaExtendedMetadata> mediaMetadata)
{
    return SRGBlockingReasonForMediaMetadataAtDate(mediaMetadata, [NSDate date]);
}

SRGBlockingReason SRGBlockingReasonForMediaMetadataAtDate(_Nullable id<SRGMediaExtendedMetadata> mediaMetadata, NSDate *date)
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
