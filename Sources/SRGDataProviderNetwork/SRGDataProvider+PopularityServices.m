//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+PopularityServices.h"

#import "SRGDataProvider+Network.h"

@import SRGDataProviderRequests;

@implementation SRGDataProvider (PopularityServices)

- (SRGRequest *)increaseSocialCountForType:(SRGSocialCountType)type
                                       URN:(NSString *)URN
                                     event:(NSString *)event
                       withCompletionBlock:(SRGSocialCountOverviewCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestIncreaseSocialCountForType:type URN:URN event:event];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGSocialCountOverview.class completionBlock:completionBlock];
}

- (SRGRequest *)increaseSearchResultsViewCountForShow:(SRGShow *)show
                                  withCompletionBlock:(SRGShowStatisticsOverviewCompletionBlock)completionBlock
{
    NSURLRequest *URLRequest = [self requestIncreaseSearchResultsViewCountForShow:show];
    return [self fetchObjectWithURLRequest:URLRequest modelClass:SRGShowStatisticsOverview.class completionBlock:completionBlock];
}

@end
