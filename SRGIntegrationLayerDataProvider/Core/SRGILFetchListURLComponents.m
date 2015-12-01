//
//  SRGILFetchPath.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 01/12/15.
//  Copyright © 2015 SRG. All rights reserved.
//

#import "SRGILFetchListURLComponents.h"
#import "SRGILErrors.h"
#import "NSBundle+SRGILDataProvider.h"

@interface SRGILFetchListURLComponents ()
@end

@implementation SRGILFetchListURLComponents

+ (nullable SRGILFetchListURLComponents *)URLComponentsForFetchListIndex:(SRGILFetchListIndex)index
                                                          withIdentifier:(nullable NSString *)identifier
                                                                   error:(NSError * __nullable __autoreleasing * __nullable)error;
{
    SRGILFetchListURLComponents *fetchPath = [[SRGILFetchListURLComponents alloc] init];
    fetchPath.index = index;
    
    switch (index) {
            // --- Videos ---
            
        case SRGILFetchListVideoLiveStreams:
            fetchPath.path = @"video/livestream.json";
            break;
            
        case SRGILFetchListVideoEditorialPicks: {
            fetchPath.path = @"video/editorialPlayerPicks.json";
            fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            break;
            
        case SRGILFetchListVideoEditorialLatest:
            fetchPath.path = @"video/editorialPlayerLatest.json";
            fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            break;
            
        case SRGILFetchListVideoMostClicked:
            fetchPath.path = @"video/mostClicked.json";
            fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"],
                                     [NSURLQueryItem queryItemWithName:@"period" value:@"24"]];
            break;
            
        case SRGILFetchListVideoSearch:
            fetchPath.path = @"video/search.json";
            fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"q" value:@"."],
                                     [NSURLQueryItem queryItemWithName:@"pageSize" value:@"24"]];
            break;
            
            
            // --- Video Shows ---
            
        case SRGILFetchListVideoShowsAlphabetical:
            fetchPath.path = @"tv/assetGroup/editorialPlayerAlphabetical.json";
            break;
            
        case SRGILFetchListVideoEpisodesByDate: {
            fetchPath.path = @"video/episodesByDate.json";
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *dateComponents = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[MSDate date]];
            NSString *dateString = [NSString stringWithFormat:@"%4li-%02li-%02li", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
            fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"day" value:dateString]];
        }
            break;
            
        case SRGILFetchListVideoShowsSearch:
            fetchPath.path = @"tv/assetGroup/search.json";
            fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"q" value:@"."],
                                     [NSURLQueryItem queryItemWithName:@"pageSize" value:@"24"]];
            break;
            
            // --- Audio & Video Show Detail ---
            
        case SRGILFetchListVideoShowDetail:
        case SRGILFetchListAudioShowDetail: {
            if (identifier.length > 0) {
                fetchPath.path = [NSString stringWithFormat:@"assetSet/listByAssetGroup/%@.json", identifier];
                fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            }
        }
            break;
            
            
            // --- Audios ---
            
        case SRGILFetchListAudioLiveStreams: {
            if (identifier.length > 0) {
                fetchPath.path = [NSString stringWithFormat:@"audio/play/%@.json", identifier];
                fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            }
        }
            break;
            
        case SRGILFetchListAudioEditorialLatest: {
            if (identifier.length > 0) {
                fetchPath.path = [NSString stringWithFormat:@"audio/editorialPlayerLatestByChannel/%@.json", identifier];
                fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            }
        }
            break;
            
        case SRGILFetchListAudioEpisodesLatest: {
            if (identifier.length > 0) {
                fetchPath.path = [NSString stringWithFormat:@"audio/latestEpisodesByChannel/%@.json", identifier];
                fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            }
        }
            break;
            
        case SRGILFetchListAudioMostClicked: {
            if (identifier.length > 0) {
                fetchPath.path = [NSString stringWithFormat:@"audio/mostClickedByChannel/%@.json", identifier];
                fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            }
        }
            break;
            
        case SRGILFetchListAudioSearch: {
            fetchPath.path = @"audio/search.json";
            fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"q" value:@"."],
                                     [NSURLQueryItem queryItemWithName:@"pageSize" value:@"24"]];
        }
            break;
            
            
            // --- Audio Shows ---
            
        case SRGILFetchListAudioShowsAlphabetical: {
            if (identifier.length > 0) {
                fetchPath.path = [NSString stringWithFormat:@"radio/assetGroup/editorialPlayerAlphabeticalByChannel/%@.json", identifier];
            }
        }
            break;
            
            
        case SRGILFetchListAudioShowsSearch:
            fetchPath.path = @"radio/assetGroup/search.json";
            fetchPath.queryItems = @[[NSURLQueryItem queryItemWithName:@"q" value:@"."],
                                     [NSURLQueryItem queryItemWithName:@"pageSize" value:@"24"]];
            break;
            
        default:
            break;
        }
    }
    
    if (identifier.length == 0 && !fetchPath.path) {
        NSString *format = SRGILDataProviderLocalizedString(@"An identifier is required for fetch index: %ld. Found nil or empty.", nil);
        NSString *msg = [NSString stringWithFormat:format, index];
        *error = SRGILCreateUserFacingError(msg, nil, SRGILDataProviderErrorCodeMissingURLIdentifier);
        return nil;
    }
            
    return fetchPath;
}

- (void)updateQueryArgumentsWithPageSize:(NSString *)newPageSize
{
    
}

- (void)updateQueryArgumentsWithDate:(NSDate *)date
{
    
}

@end
