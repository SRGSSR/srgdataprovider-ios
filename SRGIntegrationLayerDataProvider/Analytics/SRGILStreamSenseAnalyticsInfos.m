//
//  SRGStreamSenseAnalyticsDataSource.m
//  SRFPlayer
//
//  Created by Cédric Foellmi on 10/07/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILStreamSenseAnalyticsInfos.h"
#import <RTSAnalytics/NSDictionary+RTSAnalytics.h>
#import <RTSAnalytics/NSString+RTSAnalytics.h>

#import "SRGILModel.h"
#import "SRGILMedia+Private.h"


@interface SRGILStreamSenseAnalyticsInfos ()
@property(nonatomic, strong) SRGILMedia *media;
@property(nonatomic, strong) NSURL *playedURL;
@end

@implementation SRGILStreamSenseAnalyticsInfos

- (instancetype)initWithMedia:(SRGILMedia *)media usingURL:(NSURL *)playedURL
{
    NSAssert(media, @"Missing media");
    NSAssert(playedURL, @"Missing played URL");
    
    self = [super init];
    if (self) {
        self.media = media;
        self.playedURL = playedURL;
    }
    return self;
}
- (BOOL)isLiveStream
{
    return self.media.isLiveStream;
}

- (NSDictionary *)playlistMetadataForBusinesUnit:(NSString *)businessUnit
{
    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
    
    NSString *ns_st_pl = [self isLiveStream] ? @"Livestream" : self.media.parentTitle;
    [metadata safeSetValue:ns_st_pl forKey:@"ns_st_pl"];
    
    NSString *srg_unit_c = [businessUnit uppercaseString];
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
    
    NSString *srg_pr_id  = self.media.assetSet.identifier;
    BOOL isHD = ([self.media playlistURLQualityForURL:self.playedURL] == SRGILPlaylistURLQualityHD);
    NSString *srg_mqual  = (isHD) ? @"hd" : @"sd"; // WARNING: FIND A WAY TO CHOOSE BETWEEN HD AND SD
    NSString *srg_mgeobl = self.media.shouldBeGeoblocked || (self.media.isBlocked && self.media.blockingReason == SRGILMediaBlockingReasonGeoblock) ? @"true" : @"false";
    NSString *srg_plid   = self.media.assetSet.assetGroupId;
    
    [metadata safeSetValue:srg_pr_id  forKey:@"srg_pr_id"];
    [metadata safeSetValue:srg_mqual  forKey:@"srg_mqual"];
    [metadata safeSetValue:srg_mgeobl forKey:@"srg_mgeobl"];
    [metadata safeSetValue:srg_plid   forKey:@"srg_plid"];

    NSString *ns_st_ty   = [NSStringFromClass([self.media class]) stringByReplacingOccurrencesOfString:@"SRGIL" withString:@""];
    NSString *ns_st_ep   = (self.media.isLiveStream) ? @"Livestream" : [self.media.title truncateAndAddEllipsisForStatistics];
    NSString *ns_st_pr   = (self.media.isLiveStream) ? self.media.assetSet.title : [NSString stringWithFormat:@"%@ %@ %@",
                                                                                    self.media.parentTitle,
                                                                                    NSLocalizedString(@"STAT_DATE_PREPOSITION", nil),
                                                                                    [euDateFormatter stringFromDate:self.media.assetSet.publishedDate]];
    
    NSString *ns_st_el   = (self.media.isLiveStream) ? @"0" : [NSString stringWithFormat:@"%d", (int)(self.media.fullLengthDuration * 1000.f)];
    NSString *ns_st_dt   = [usDateFormatter stringFromDate:(self.media.assetSet.publishedDate) ?: self.media.creationDate];
    NSString *ns_st_li   = (self.media.isLiveStream) ? @"1" : @"0";

// TODO: Segments
    NSString *ns_st_pn   = @"1"; // [self.mediaDataSource itemOrderPosition] > 0 ? [NSString stringWithFormat:@"%li", (long)[self.mediaDataSource itemOrderPosition]] : @"1";
    NSString *ns_st_tp   = @"1";
    
    [metadata safeSetValue:ns_st_ty forKey:@"ns_st_ty"];
    [metadata safeSetValue:ns_st_ep forKey:@"ns_st_ep"];
    [metadata safeSetValue:ns_st_el forKey:@"ns_st_el"];
    [metadata safeSetValue:ns_st_dt forKey:@"ns_st_dt"];
    [metadata safeSetValue:ns_st_li forKey:@"ns_st_li"];
    [metadata safeSetValue:ns_st_pr forKey:@"ns_st_pr"];
    [metadata safeSetValue:ns_st_pn forKey:@"ns_st_pn"];
    [metadata safeSetValue:ns_st_tp forKey:@"ns_st_tp"];
    
    // Placeholder for values of SMAC-4163:
    [metadata safeSetValue:self.media.analyticsData.srgC1 forKey:@"srg_c1"];
    [metadata safeSetValue:self.media.analyticsData.srgC2 forKey:@"srg_c2"];
    [metadata safeSetValue:self.media.analyticsData.srgC3 forKey:@"srg_c3"];

    // Add common part of the clip (that changes on segment update):
    [metadata addEntriesFromDictionary:[self segmentClipMetadataForMedia:self.media]];

    // Add 'Encoder' value (live only):
    if (self.media.isLiveStream) {
        NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"enc(\\d+)"
                                                                            options:0
                                                                              error:nil];
        
        NSTextCheckingResult *firstMatch = [re firstMatchInString:[self.playedURL path]
                                                          options:0
                                                            range:NSMakeRange(0, [[self.playedURL path] length])];
        
        if (firstMatch.range.location != NSNotFound) {
            NSString *encoderValue = [[self.playedURL path] substringWithRange:[firstMatch rangeAtIndex:1]];
            [metadata setValue:encoderValue forKey:@"srg_enc"];
        }
    }
    
    return [metadata copy];
}

- (NSDictionary *)segmentClipMetadataForMedia:(SRGILMedia *)mediaFullLengthOrSegment
{
    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
    
    NSString *ns_st_ep = (mediaFullLengthOrSegment.isLiveStream) ? @"Livestream" : [mediaFullLengthOrSegment.title truncateAndAddEllipsisForStatistics] ?: @"";
    NSString *ns_st_ci = mediaFullLengthOrSegment.identifier;
    NSString *ns_st_cl = (mediaFullLengthOrSegment.isLiveStream) ? @"0" : [NSString stringWithFormat:@"%d", (int)(mediaFullLengthOrSegment.duration * 1000.f)];
    NSString *ns_st_cn = @"1";

    [metadata safeSetValue:ns_st_ep forKey:@"ns_st_ep"];
    [metadata safeSetValue:ns_st_ci forKey:@"ns_st_ci"];
    [metadata safeSetValue:ns_st_cl forKey:@"ns_st_cl"];
    [metadata safeSetValue:ns_st_cn forKey:@"ns_st_cn"];

    return [metadata copy];
}

@end
