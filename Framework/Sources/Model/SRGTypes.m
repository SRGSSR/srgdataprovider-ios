//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import "NSBundle+SRGDataProvider.h"

NSString *SRGMessageForBlockedMediaWithBlockingReason(SRGBlockingReason blockingReason)
{
    static dispatch_once_t onceToken;
    static NSDictionary *messages;
    dispatch_once(&onceToken, ^{
        messages = @{ @(SRGBlockingReasonGeoblocking) : SRGDataProviderLocalizedString(@"This media is not available outside Switzerland.", @"A blocking reason message displayed to the user if the media can't be played."),
                      @(SRGBlockingReasonLegal) : SRGDataProviderLocalizedString(@"This media is not available due to legal restrictions.", @"A blocking reason message displayed to the user if the media can't be played."),
                      @(SRGBlockingReasonCommercial) : SRGDataProviderLocalizedString(@"This commercial media is not available.", @"A blocking reason message displayed to the user if the media can't be played."),
                      @(SRGBlockingReasonAgeRating18) : SRGDataProviderLocalizedString(@"To protect children, this media is only available between 11PM and 5AM.", @"A blocking reason message displayed to the user if the media can't be played."),
                      @(SRGBlockingReasonAgeRating12) : SRGDataProviderLocalizedString(@"To protect children, this media is only available between 8PM and 6AM.", @"A blocking reason message displayed to the user if the media can't be played."),
                      @(SRGBlockingReasonStartDate) : SRGDataProviderLocalizedString(@"This media is not available yet. Please try again later.", @"A blocking reason message displayed to the user if the media can't be played."),
                      @(SRGBlockingReasonEndDate) : SRGDataProviderLocalizedString(@"This media is not available anymore.", @"A blocking reason message displayed to the user if the media can't be played."),
                      @(SRGBlockingReasonUnknown) : SRGDataProviderLocalizedString(@"This media is not available.", @"A blocking reason message displayed to the user if the media can't be played.") };
    });
    return messages[@(blockingReason)];
}

NSString *SRGMessageForSkippedSegmentWithBlockingReason(SRGBlockingReason blockingReason)
{
    static dispatch_once_t onceToken;
    static NSDictionary *messages;
    dispatch_once(&onceToken, ^{
        messages = @{ @(SRGBlockingReasonGeoblocking) : SRGDataProviderLocalizedString(@"The content was skipped because it is not available outside Switzerland.", @"A blocking reason message displayed to the user during the playback if a segment was skipped."),
                      @(SRGBlockingReasonLegal) : SRGDataProviderLocalizedString(@"The content was skipped due to legal restrictions.", @"A blocking reason message displayed to the user during the playback if a segment was skipped."),
                      @(SRGBlockingReasonCommercial) : SRGDataProviderLocalizedString(@"The commercial content was skipped.", @"A blocking reason message displayed to the user during the playback if a segment was skipped."),
                      @(SRGBlockingReasonAgeRating18) : SRGDataProviderLocalizedString(@"The content was skipped to protect children. Please try again between 11PM and 5AM.", @"A blocking reason message displayed to the user during the playback if a segment was skipped."),
                      @(SRGBlockingReasonAgeRating12) : SRGDataProviderLocalizedString(@"The content was skipped to protect children. Please try again between 8AM and 6AM.", @"A blocking reason message displayed to the user during the playback if a segment was skipped."),
                      @(SRGBlockingReasonStartDate) : SRGDataProviderLocalizedString(@"The content was skipped because it is not available yet. Please try again later.", @"A blocking reason message displayed to the user during the playback if a segment was skipped."),
                      @(SRGBlockingReasonEndDate) : SRGDataProviderLocalizedString(@"The content was skipped because it is not available anymore.", @"A blocking reason message displayed to the user during the playback if a segment was skipped."),
                      @(SRGBlockingReasonUnknown) : SRGDataProviderLocalizedString(@"The content was skipped because it is not available.", @"A blocking reason message displayed to the user during the playback if a segment was skipped.") };
    });
    return messages[@(blockingReason)];
}
