//
//  SRGStreamSenseAnalyticsDataSource.m
//  SRFPlayer
//
//  Created by Cédric Foellmi on 10/07/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILStreamSenseAnalyticsIndividualDataSource.h"
#import <RTSAnalytics/NSDictionary+RTSAnalyticsUtils.h>
#import <RTSAnalytics/NSString+RTSAnalyticsUtils.h>

@interface SRGILStreamSenseAnalyticsIndividualDataSource ()
@property(nonatomic, strong) NSString *identifier;
@end

@implementation SRGILStreamSenseAnalyticsIndividualDataSource

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    NSAssert(identifier, @"Missing identifier");
    self = [super init];
    if (self) {
        self.identifier = identifier;
    }
    return self;
}

- (BOOL)isLiveStream
{
    return YES;
}

- (NSString *)mediaTypeLabel
{
    return @"Video";
//    switch ([self.mediaDataSource mediaType]) {
//        case SRGMediaTypeVideo:
//            return @"Video";
//            
//        case SRGMediaTypeAudio:
//            return @"Audio";
//            
//        default:
//            return @"Unknown";
//    }
}

- (NSDictionary *)playlistMetadata
{
    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
    
    NSString *ns_st_pl = [self isLiveStream] ? @"Livestream" : @"<PUT HERE MEDIA PARENT TITLE>";
    [metadata safeSetValue:ns_st_pl forKey:@"ns_st_pl"];
    
    NSString *srg_unit_c = [@"<PUT HERE BUSINESS IDENTIFIER>" uppercaseString];
    [metadata safeSetValue:srg_unit_c forKey:@"srg_unit_c"];
    
    return [metadata copy];
}


- (NSDictionary *)fullLengthClipMetadata
{
    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];

    static NSDateFormatter *usDateFormatter;
    static NSDateFormatter *euDateFormatter;

    static dispatch_once_t dateFormatterOnceToken;
    dispatch_once(&dateFormatterOnceToken, ^{
        usDateFormatter = [[NSDateFormatter alloc] init];
        [usDateFormatter setDateFormat:@"yyyy-MM-dd"];
        euDateFormatter = [[NSDateFormatter alloc] init];
        [euDateFormatter setDateFormat:@"dd.MM.yyyy"];
    });

    BOOL isLive = [self isLiveStream];
    
    NSString *srg_pr_id  = @"<PUT HERE ASSET IDENTIFIER>"; //[self.mediaDataSource assetIdentifier];
    NSString *ns_st_ty   = [self mediaTypeLabel];
    NSString *srg_mqual  = (YES) ? @"hd" : @"sd"; // WARNING: FIND A WAY TO CHOOSE BETWEEN HD AND SD
    NSString *srg_mgeobl = @"false"; // WARNING : [self.mediaDataSource shouldBeGeoblocked] || ([self.mediaDataSource isBlocked] && [self.mediaDataSource blockingReason] == SRGMediaBlockingReasonGeoblock) ? @"true" : @"false";
    NSString *srg_plid   = @"<PUT HERE ASSET GROUP IDENTIFIER>"; //[self.mediaDataSource assetGroupIdentifier];
    
    NSString *ns_st_ep   = (isLive) ? @"Livestream" : [@"<PUT HERE MEDIA TITLE>" truncateAndAddEllipsisForStatistics];
    
    NSString *ns_st_pr   = (isLive) ? @"<PUT HERE ASSET TITLE>" : [NSString stringWithFormat:@"%@ %@ %@",
                                                                   @"<PUT HERE MEDIA PARENT TITLE>",
                                                                   NSLocalizedString(@"STAT_DATE_PREPOSITION", nil),
                                                                   [euDateFormatter stringFromDate:[NSDate date]]]; // WARNING: Should be ___assetPublishedDate___
    
    NSString *ns_st_el   = @"0"; // (isLive) ? @"0" : [NSString stringWithFormat:@"%d", (int)([self.mediaDataSource fullLengthDuration] * 1000.f)];
    
//    NSString *ns_st_dt   = [usDateFormatter stringFromDate:[self.mediaDataSource assetPublishedDate] ? : [self.mediaDataSource creationDate]];
    NSString *ns_st_li   = (isLive) ? @"1" : @"0";

    NSString *ns_st_pn   = @"1"; // [self.mediaDataSource itemOrderPosition] > 0 ? [NSString stringWithFormat:@"%li", (long)[self.mediaDataSource itemOrderPosition]] : @"1";
    NSString *ns_st_tp   = @"1";

    [metadata safeSetValue:srg_pr_id  forKey:@"srg_pr_id"];
    [metadata safeSetValue:ns_st_ty   forKey:@"ns_st_ty"];
    [metadata safeSetValue:srg_mqual  forKey:@"srg_mqual"];
    [metadata safeSetValue:srg_mgeobl forKey:@"srg_mgeobl"];
    [metadata safeSetValue:srg_plid   forKey:@"srg_plid"];
    [metadata safeSetValue:ns_st_ep   forKey:@"ns_st_ep"];
    [metadata safeSetValue:ns_st_el   forKey:@"ns_st_el"];
//    [metadata safeSetValue:ns_st_dt   forKey:@"ns_st_dt"];
    [metadata safeSetValue:ns_st_li   forKey:@"ns_st_li"];
    [metadata safeSetValue:ns_st_pr   forKey:@"ns_st_pr"];
    [metadata safeSetValue:ns_st_pn   forKey:@"ns_st_pn"];
    [metadata safeSetValue:ns_st_tp   forKey:@"ns_st_tp"];
    
    // Placeholder for values of SMAC-4163:
//    [metadata safeSetValue:self.mediaDataSource.extendedAnalyticsDataC1 forKey:@"srg_c1"];
//    [metadata safeSetValue:self.mediaDataSource.extendedAnalyticsDataC2 forKey:@"srg_c2"];
//    [metadata safeSetValue:self.mediaDataSource.extendedAnalyticsDataC1 forKey:@"srg_c3"];

    // Add common part of the clip (that changes on segment update):
    [metadata addEntriesFromDictionary:[self segmentClipMetadata]];

    // Add 'Encoder' value (live only):
    if (isLive) {
        NSURL *URL = [NSURL URLWithString:@"toto://tata.com/stream"];//  [self.mediaDataSource sourceURL:&isHD];
        NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"enc(\\d+)"
                                                                            options:0
                                                                              error:nil];
        
        NSTextCheckingResult *firstMatch = [re firstMatchInString:[URL path]
                                                          options:0
                                                            range:NSMakeRange(0, [[URL path] length])];
        
        if (firstMatch.range.location != NSNotFound) {
            NSString *encoderValue = [[URL path] substringWithRange:[firstMatch rangeAtIndex:1]];
            [metadata setValue:encoderValue forKey:@"srg_enc"];
        }
    }
    
    return [metadata copy];
}

- (NSDictionary *)segmentClipMetadata
{
    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
    
    NSString *ns_st_ep = @"Livestream"; // (isLive) ? @"Livestream" : [[self.mediaDataSource title ]truncateAndAddEllipsisForStatistics]? : @"";
    NSString *ns_st_ci = self.identifier;
    NSString *ns_st_cl = @"0"; // ([self isLiveStream]) ? @"0" : [NSString stringWithFormat:@"%d", (int)([self.mediaDataSource duration] * 1000.f)];
    NSString *ns_st_cn = @"1";

    [metadata safeSetValue:ns_st_ep forKey:@"ns_st_ep"];
    [metadata safeSetValue:ns_st_ci forKey:@"ns_st_ci"];
    [metadata safeSetValue:ns_st_cl forKey:@"ns_st_cl"];
    [metadata safeSetValue:ns_st_cn forKey:@"ns_st_cn"];

    return [metadata copy];
}

//- (NSDictionary *)segmentMetadataWithPlaybackEventUserInfo:(NSDictionary *)userInfo wasSegmentSelected:(BOOL)segmentSelected
//{
//    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
//    [metadata addEntriesFromDictionary:[self fullLengthClipMetadata]];
//    
//    int episodeIndex = [[userInfo valueForKey:SRGMediaPlaybackEventEpisodeIndexKey] intValue];
//    NSInteger ns_st_pn = MAX(1, episodeIndex + 1); // Zero is not allowable...
//
//    DDLogDebug(@"Starting segment: %li / %li", (long)ns_st_pn, (long)[self.mediaDataSource countOfSegments]);
//
//    NSArray *episodeDataSources = [self.mediaDataSource episodesDataSources];
//
//    if (segmentSelected && ns_st_pn < [episodeDataSources count] + 1) {
//        // Change to segment dataSource:
//        SRGILMediaPlayerDataSource *segmentDataSource = episodeDataSources[episodeIndex];
//        SRGILStreamSenseAnalyticsIndividualDataSource *segmentStreamsenseDataSource = [SRGILStreamSenseAnalyticsIndividualDataSource dataSource:segmentDataSource];
//        [metadata addEntriesFromDictionary:[segmentStreamsenseDataSource segmentClipMetadata]];
//    }
//    
//    return [metadata copy];
//}

@end
