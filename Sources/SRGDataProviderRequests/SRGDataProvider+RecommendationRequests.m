//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider+RecommendationRequests.h"

#import "SRGDataProvider+RequestBuilders.h"

@implementation SRGDataProvider (RecommendationRequests)

- (NSURLRequest *)requestRecommendedMediasForURN:(NSString *)URN
                                          userId:(NSString *)userId
{
    NSString *resourcePath = nil;
    if (userId) {
        resourcePath = [NSString stringWithFormat:@"2.0/mediaList/recommendedByUserId/byUrn/%@/%@", URN, userId];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"2.0/mediaList/recommended/byUrn/%@", URN];
    }
    
    return [self URLRequestForResourcePath:resourcePath withQueryItems:nil];
}

@end
