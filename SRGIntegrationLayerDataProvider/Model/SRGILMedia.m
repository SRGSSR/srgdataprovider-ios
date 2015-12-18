//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILModelConstants.h"

#import "SRGILMedia.h"

#import "SRGILPlaylist.h"
#import "SRGILDownload.h"

#import "SRGILImage.h"
#import "SRGILAsset.h"
#import "SRGILAssetSet.h"
#import "SRGILAssetMetadata.h"
#import "SRGILSocialCounts.h"


@interface SRGILMedia () {
    NSMutableDictionary *_cachedSegmentationFlags;
    NSArray *_cachedSegments;
    NSMutableDictionary *_cachedURLs;
    BOOL _fullLength;
    NSInteger _markInMiliseconds;
    NSInteger _markOutMiliseconds;
    NSInteger _durationMiliseconds;
}
@property (nonatomic, weak) SRGILMedia *parent;
@property (nonatomic, assign, getter=isFullLength) BOOL fullLength;
@end

@implementation SRGILMedia

- (SRGILMediaType)type
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
        _fullLength = [[dictionary objectForKey:@"fullLength"] boolValue];
        
        _markInMiliseconds = [[dictionary objectForKey:@"markIn"] integerValue];
        _markOutMiliseconds = [[dictionary objectForKey:@"markOut"] integerValue];
        
        if ([dictionary objectForKey:@"duration"]) {
            _durationMiliseconds = [[dictionary objectForKey:@"duration"] integerValue];
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
        _assetSetSubType = SRGILAssetSubSetTypeForString([dictionary objectForKey:@"assetSubSetId"]);
        
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
        
        NSArray *downloadsDictionaries = [dictionary valueForKeyPath:@"Downloads.Download"];
        [tmp removeAllObjects];
        
        for (NSDictionary *downloadDict in downloadsDictionaries) {
            SRGILDownload *download = [[SRGILDownload alloc] initWithDictionary:downloadDict];
            if (download) {
                [tmp addObject:download];
            }
        }
        _downloads = [NSArray arrayWithArray:tmp];
        
        NSString *positionKey = [dictionary objectForKey:@"editorialPosition"] ? @"editorialPosition" : @"position";
        _orderPosition = [[dictionary objectForKey:positionKey] integerValue];
        
        _isLivestreamPlaylist = [[[dictionary valueForKey:@"Playlists"] objectForKey:@"@availability"] isEqualToString:@"LIVE"];
        _displayable = [dictionary valueForKey:@"displayable"] ? [[dictionary valueForKey:@"displayable"] boolValue] : YES;
        
        _socialCounts = [[SRGILSocialCounts alloc] initWithDictionary:[dictionary objectForKey:@"SocialCounts"]];
        
        if ([dictionary objectForKey:@"AnalyticsData"]) {
            _analyticsData = [[SRGILAnalyticsExtendedData alloc] initWithDictionary:[dictionary objectForKey:@"AnalyticsData"]];
        }
        
        _cachedURLs = [[NSMutableDictionary alloc] init];
        [self.playlists enumerateObjectsUsingBlock:^(SRGILPlaylist *pl, NSUInteger idx, BOOL *stop) {
            for (SRGILPlaylistURLQuality quality = SRGILPlaylistURLQualityEnumBegin; quality < SRGILPlaylistURLQualityEnumEnd; quality++) {
                NSURL *result = [pl URLForQuality:quality];
                if (result) {
                    NSNumber *key = [self URLKeyForPlaylistWithProtocol:pl.protocol withQuality:quality];
                    _cachedURLs[key] = result;
                    _cachedSegmentationFlags[result] = @(pl.segmentation);
                }
            }
        }];
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
    return self.assetSetSubType == SRGILAssetSubSetTypeLivestream
    || self.assetSet.subtype == SRGILAssetSubSetTypeLivestream
    || self.isLivestreamPlaylist;
}


- (BOOL)isFullLength
{
    return _fullLength;
}

- (void)setFullLength:(BOOL)flag
{
    _fullLength = flag;
}

- (NSTimeInterval)markIn
{
    return _markInMiliseconds / 1000.0;
}

- (NSInteger)markInInMillisecond
{
    return _markInMiliseconds;
}

- (NSTimeInterval)markOut
{
    return _markOutMiliseconds / 1000.0;
}

- (NSInteger)markOutInMillisecond
{
    return _markOutMiliseconds;
}

- (NSTimeInterval)duration
{
    return self.durationInMillisecond / 1000.0;
}

- (NSInteger)durationInMillisecond
{
    NSInteger markInOutDuration = (_markOutMiliseconds - _markInMiliseconds);
    if (markInOutDuration == 0) {
        return _durationMiliseconds;
    }
    else {
        return markInOutDuration;
    }
}

- (NSTimeInterval)fullLengthDuration
{
    return self.fullLengthDurationInMillisecond / 1000.0;
}

- (NSInteger)fullLengthDurationInMillisecond
{
    NSInteger defaultDuration = self.durationInMillisecond;
    SRGILAsset *asset = (SRGILAsset *)[self.assetSet.assets firstObject];
    if (!self.isFullLength && asset && asset.fullLengthMedia) {
        defaultDuration = asset.fullLengthMedia.durationInMillisecond;
    }
    return defaultDuration;
}

- (NSArray *)segments
{
    if (!_cachedSegments) {
        _cachedSegments = [(SRGILAsset *)[self.assetSet.assets firstObject] mediaSegments]; // should return the same thing as -medias;
        [_cachedSegments makeObjectsPerformSelector:@selector(setParent:) withObject:self];
    }
    return _cachedSegments;
}

- (NSComparisonResult)compareMarkInTimes:(SRGILVideo *)other
{
    NSAssert(other, @"Missing other instance of SRGILVideo");
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

- (NSNumber *)URLKeyForPlaylistWithProtocol:(enum SRGILPlaylistProtocol)playlistProtocol withQuality:(SRGILPlaylistURLQuality)quality
{
    return @(100*playlistProtocol + quality);
}

- (NSURL *)defaultContentURL
{
    return nil; // Must be overriden
}

- (NSURL *)contentURLForPlaylistWithProtocol:(enum SRGILPlaylistProtocol)playlistProtocol withQuality:(SRGILPlaylistURLQuality)quality
{
    NSNumber *key = [self URLKeyForPlaylistWithProtocol:playlistProtocol withQuality:quality];
    return [_cachedURLs objectForKey:key];
}

- (SRGILPlaylistProtocol)playlistProtocolForURL:(NSURL *)URL
{
    if (!URL) {
        return SRGILPlaylistProtocolUnknown;
    }
    
    for (SRGILPlaylist *pl in self.playlists) {
        for (SRGILPlaylistURLQuality quality = SRGILPlaylistURLQualityEnumBegin; quality < SRGILPlaylistURLQualityEnumEnd; quality ++) {
            if ([URL isEqual:[pl URLForQuality:quality]]) {
                return pl.protocol;
            }
        }
    }
    
    return SRGILPlaylistProtocolUnknown;
}

- (SRGILPlaylistURLQuality)playlistURLQualityForURL:(NSURL *)URL
{
    if (!URL) {
        return SRGILPlaylistURLQualityUnknown;
    }
    
    for (SRGILPlaylist *pl in self.playlists) {
        for (SRGILPlaylistURLQuality quality = SRGILPlaylistURLQualityEnumBegin; quality < SRGILPlaylistURLQualityEnumEnd; quality ++) {
            if ([URL isEqual:[pl URLForQuality:quality]]) {
                return quality;
            }
        }
    }
    
    return SRGILPlaylistURLQualityUnknown;
}

- (SRGILPlaylistSegmentation)segmentationForURL:(NSURL *)URL
{
    if ([_cachedSegmentationFlags objectForKey:URL]) {
        return (SRGILPlaylistSegmentation)[[_cachedSegmentationFlags objectForKey:URL] integerValue];
    }
    return SRGILPlaylistSegmentationUnknown;
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
