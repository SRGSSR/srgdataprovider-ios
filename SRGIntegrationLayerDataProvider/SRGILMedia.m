//
//  SRGVideo.m
//  SRGPlayer
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILModelConstants.h"

#import "SRGILMedia.h"
#import "SRGILMedia+Private.h"

#import "SRGILPlaylist.h"
#import "SRGILImage.h"
#import "SRGILAsset.h"
#import "SRGILAssetSet.h"
#import "SRGILAssetMetadata.h"
#import "SRGILSocialCounts.h"


@interface SRGILMedia () {
    NSMutableDictionary *_cachedSegmentationFlags;
}
@end

@implementation SRGILMedia

+ (SRGILMediaType)type
{
    return SRGILMediaTypeUndefined;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _cachedSegmentationFlags = [[NSMutableDictionary alloc] init];
        
        static NSDateFormatter *dateFormatter;
        static dispatch_once_t dateFormatterOnceToken;
        dispatch_once(&dateFormatterOnceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        });

        _creationDate = [dateFormatter dateFromString:(NSString *)[dictionary objectForKey:@"createdDate"]];
        _fullLengthNumber = [dictionary objectForKey:@"fullLength"];
        
        // Immediately makes seconds, to avoid tweaking later on.
        _markInNumber = @([[dictionary objectForKey:@"markIn"] doubleValue] / 1000.0);
        _markOutNumber = @([[dictionary objectForKey:@"markOut"] doubleValue] / 1000.0);

        if ([dictionary objectForKey:@"duration"]) {
            _assetDuration = @([[dictionary objectForKey:@"duration"] doubleValue] / 1000.0);
        }

        NSArray *assetMetadataDictionaries = [dictionary valueForKeyPath:@"AssetMetadatas.AssetMetadata"];
        NSMutableArray *tmp = [NSMutableArray array];
        for (NSDictionary *assetMetadataDict in assetMetadataDictionaries) {
            SRGILAssetMetadata *assetMetaData = [[SRGILAssetMetadata alloc] initWithDictionary:assetMetadataDict];
            if (assetMetaData) {
                [tmp addObject:assetMetaData];
            }
        }
        _assetMetadatas = [NSArray arrayWithArray:tmp];

        _assetSet = [[SRGILAssetSet alloc] initWithDictionary:[dictionary objectForKey:@"AssetSet"]];
        _assetSetSubType = assetSubSetTypeForString([dictionary objectForKey:@"assetSubSetId"]);
        
        _image = [[SRGILImage alloc] initWithDictionary:[dictionary objectForKey:@"Image"]];
        _blockingReason = SRGILMediaBlockingReasonForKey([dictionary objectForKey:@"block"]); // it handles missing key.
        _shouldBeGeoblocked = ([[dictionary objectForKey:@"staticGeoBlock"] boolValue]);
        
        NSArray *playlistsDictionaries = [dictionary valueForKeyPath:@"Playlists.Playlist"];
        [tmp removeAllObjects];
        
        for (NSDictionary *playlistsDict in playlistsDictionaries) {
            SRGILPlaylist *playlist = [[SRGILPlaylist alloc] initWithDictionary:playlistsDict];
            if (playlist) {
                [tmp addObject:playlist];
            }
        }
        _playlists = [NSArray arrayWithArray:tmp];
        
        NSString *positionKey = [dictionary objectForKey:@"editorialPosition"] ? @"editorialPosition" : @"position";
        _orderPosition = [[dictionary objectForKey:positionKey] integerValue];
        
        _isLivestreamPlaylist = [[[dictionary valueForKey:@"Playlists"] objectForKey:@"@availability"] isEqualToString:@"LIVE"];
        _displayable = [dictionary valueForKey:@"displayable"] ? [[dictionary valueForKey:@"displayable"] boolValue] : YES;
        
        _socialCounts = [[SRGILSocialCounts alloc] initWithDictionary:[dictionary objectForKey:@"SocialCounts"]];
        
        if ([dictionary objectForKey:@"AnalyticsData"]) {
            _analyticsData = [[SRGILAnalyticsExtendedData alloc] initWithDictionary:[dictionary objectForKey:@"AnalyticsData"]];
        }

    }
    return self;
}

- (NSString *)description
{
    NSMutableString *s = [[NSMutableString alloc] init];
    [s appendFormat:@"<%@: %.1f|%.1f|%.1f", NSStringFromClass([self class]), self.markIn, self.duration, self.markOut];
    if ([self.segments count]) {
        for (SRGILMedia *media in self.segments) {
            [s appendFormat:@"\n - %@", [media description]];
        }
    }
    [s appendString:@">"];
    return [s copy];
}

- (NSString *)title
{
    if ([self.assetMetadatas count] > 0) {
        SRGILAssetMetadata *firstAssetMetadata = [self.assetMetadatas firstObject];
        return firstAssetMetadata.title;
    }
    return nil;
}

- (NSString *)parentTitle
{
    return self.assetSet.show.title ? : self.assetSet.rubric.title;
}

- (BOOL)isLiveStream
{
    // TODO: Still not have a definitive answer on the subject
    return self.assetSetSubType == SRGAssetSubSetTypeLivestream
    || self.assetSet.subtype == SRGAssetSubSetTypeLivestream
    || self.isLivestreamPlaylist;
}


- (BOOL)isFullLength
{
    return [self.fullLengthNumber boolValue];
}

- (NSTimeInterval)markIn
{
    return [self.markInNumber doubleValue];
}

- (NSTimeInterval)markOut
{
    return [self.markOutNumber doubleValue];
}

- (NSTimeInterval)duration
{
    NSTimeInterval markInOutDuration = self.markOut - self.markIn;
    if (markInOutDuration == 0) {
        return [self.assetDuration doubleValue];
    }
    else {
        return markInOutDuration;
    }
}

- (NSTimeInterval)fullLengthDuration
{
    NSTimeInterval defaultDuration = [self duration];
    SRGILAsset *asset = (SRGILAsset *)self.assetSet.assets[0];
    if (!self.isFullLength && asset && asset.fullLengthMedia) {
        defaultDuration = asset.fullLengthMedia.duration;
    }
    return defaultDuration;
}

- (NSArray *)segments
{
    return [(SRGILAsset *)[self.assetSet.assets firstObject] mediaSegments];
}

- (NSComparisonResult)compareMarkInTimes:(SRGILVideo *)other
{
    NSAssert(other, @"Missing other instance of SRGVideo");
    if (other.markIn > self.markIn) {
        return NSOrderedAscending;
    }
    else if (other.markIn < self.markIn) {
        return NSOrderedDescending;
    }
    else {
        return NSOrderedSame;
    }
}

- (NSURL *)HDHLSURL
{
    return [self URLForPlaylistWithProtocol:SRGPlaylistProtocolHLS withQuality:SRGPlaylistURLQualityHD];
}

- (NSURL *)SDHLSURL
{
    return [self URLForPlaylistWithProtocol:SRGPlaylistProtocolHLS withQuality:SRGPlaylistURLQualitySD];
}

- (NSURL *)MQHLSURL
{
    return [self URLForPlaylistWithProtocol:SRGPlaylistProtocolHLS withQuality:SRGPlaylistURLQualityMQ];
}

- (NSURL *)MQHTTPURL
{
    return [self URLForPlaylistWithProtocol:SRGPlaylistProtocolHTTP withQuality:SRGPlaylistURLQualityMQ];
}

- (NSURL *)URLForPlaylistWithProtocol:(enum SRGPlaylistProtocol)playlistProtocol withQuality:(SRGPlaylistURLQuality)quality {
    __block NSURL *result = nil;

    [self.playlists enumerateObjectsUsingBlock:^(SRGILPlaylist *pl, NSUInteger idx, BOOL *stop) {
        if (pl.protocol == playlistProtocol) {
            result = [pl URLForQuality:quality];
            if (result) {
                [_cachedSegmentationFlags setObject:@(pl.segmentation) forKey:(result)];
                *stop = YES;
            }
        }
    }];

    return result;
}

- (SRGPlaylistSegmentation)segmentationForURL:(NSURL *)URL
{
    if ([_cachedSegmentationFlags objectForKey:URL]) {
        return (SRGPlaylistSegmentation)[[_cachedSegmentationFlags objectForKey:URL] integerValue];
    }
    return SRGPlaylistSegmentationUnknown;
}

- (BOOL)isBlocked
{
    return (_blockingReason != SRGILMediaBlockingReasonNone);
}

- (NSInteger)viewCount
{
    return (self.socialCounts) ? self.socialCounts.srgView : NSNotFound;
}

@end
