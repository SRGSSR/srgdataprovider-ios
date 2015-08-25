//
//  SRGILDownload.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 25/08/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILDownload.h"

@interface SRGILDownload()

@property(nonatomic) SRGILDownloadProtocol protocol;
@property(nonatomic) NSDictionary *URLs;

@end


@implementation SRGILDownload

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        _protocol = SRGILDownloadProtocolForString([dictionary objectForKey:@"@protocol"]);
        
        NSArray *rawURLs = [dictionary objectForKey:@"url"];
        NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
        for (NSDictionary *rawURLDict in rawURLs) {
            NSNumber *key = @(SRGILDownloadURLQualityForString([rawURLDict objectForKey:@"@quality"]));
            NSURL *value = [NSURL URLWithString:[rawURLDict objectForKey:@"text"]];
            if (key && value) {
                tmp[key] = value;
            }
        }
        _URLs = [NSDictionary dictionaryWithDictionary:tmp];
    }
    
    return self;
}

- (NSURL *)URLForQuality:(SRGILDownloadURLQuality)quality
{
    return [_URLs objectForKey:@(quality)];
}


@end
