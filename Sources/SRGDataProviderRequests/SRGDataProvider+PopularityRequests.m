//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+PopularityRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

@implementation SRGDataProvider (PopularityRequests)

- (NSURLRequest *)requestIncreaseSocialCountForType:(SRGSocialCountType)type
                                                URN:(NSString *)URN
                                              event:(NSString *)event
{
    static dispatch_once_t s_onceToken;
    static NSDictionary<NSNumber *, NSString *> *s_endpoints;
    dispatch_once(&s_onceToken, ^{
        s_endpoints = @{ @(SRGSocialCountTypeSRGView) : @"clicked",
                         @(SRGSocialCountTypeSRGLike) : @"liked",
                         @(SRGSocialCountTypeFacebookShare) : @"shared/facebook",
                         @(SRGSocialCountTypeTwitterShare) : @"shared/twitter",
                         @(SRGSocialCountTypeGooglePlusShare) : @"shared/google",
                         @(SRGSocialCountTypeWhatsAppShare) : @"shared/whatsapp" };
    });
    NSString *endpoint = s_endpoints[@(type)];
    NSAssert(endpoint, @"A supported social count type must be provided");
    
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/mediaStatistic/byUrn/%@/%@", URN, endpoint];
    NSMutableURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil].mutableCopy;
    URLRequest.HTTPMethod = @"POST";
    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    URLRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{ @"eventData" : event } options:0 error:NULL];
    return URLRequest.copy;
}

- (NSURLRequest *)requestIncreaseSearchResultsViewCountForShow:(SRGShow *)show
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/showStatistic/byUrn/%@/searchResultClicked", show.URN];
    NSMutableURLRequest *URLRequest = [self URLRequestForResourcePath:resourcePath withQueryItems:nil].mutableCopy;
    URLRequest.HTTPMethod = @"POST";
    return URLRequest.copy;
}

@end
