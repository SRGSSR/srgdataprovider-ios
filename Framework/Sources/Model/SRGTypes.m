//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGTypes.h"

#import "NSBundle+SRGDataProvider.h"

NSString *SRGMessageForBlockingReason(SRGBlockingReason blockingReason)
{
    static dispatch_once_t onceToken;
    static NSDictionary *messages;
    dispatch_once(&onceToken, ^{
        messages = @{ @(SRGBlockingReasonGeoblocking) : SRGDataProviderLocalizedString(@"For legal reasons, this content is not available in your region.", nil),
                      @(SRGBlockingReasonLegal) : SRGDataProviderLocalizedString(@"This content is not available due to legal restrictions.", nil),
                      @(SRGBlockingReasonCommercial) : SRGDataProviderLocalizedString(@"Commercial is being skipped. Please wait – playback will resume shortly.", nil),
                      @(SRGBlockingReasonAgeRating18) : SRGDataProviderLocalizedString(@"To protect children under the age of 18, this content is only available between 11 p.m. and 5 a.m.", nil),
                      @(SRGBlockingReasonAgeRating12) : SRGDataProviderLocalizedString(@"To protect children under the age of 12, this content is only available between 8 p.m. and 6 a.m.", nil),
                      @(SRGBlockingReasonStartDate) : SRGDataProviderLocalizedString(@"This content is not yet available. Please try again later.", nil),
                      @(SRGBlockingReasonEndDate) : SRGDataProviderLocalizedString(@"For legal reasons, this content was only available for a limited period of time.", nil),
                      @(SRGBlockingReasonEndDate) : SRGDataProviderLocalizedString(@"This content is not available.", nil) };
    });
    return messages[@(blockingReason)];
}
