//
//  SRGILMediaMetadata.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 23/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILMediaMetadata.h"

#import "SRGILModel.h"
#import "SRGILMedia+Private.h"

@interface SRGILMedia (Utils)
- (NSURL *)thumbnailURL;
@end

@implementation SRGILMedia (Utils)

- (NSURL *)thumbnailURL
{
    if ([self type] == SRGILMediaTypeAudio) {
        SRGILAudio *audio = (SRGILAudio *)self;
        NSURL *URL = [audio.image imageRepresentationForUsage:SRGILMediaImageUsageShowEpisode].URL;
        if (!URL) {
            URL = [audio.assetSet.show.image imageRepresentationForUsage:SRGILMediaImageUsageWeb].URL;
        }
        return URL;
    }
    else if ([self type] == SRGILMediaTypeVideo) {
        SRGILVideo *video = (SRGILVideo *)self;
        SRGILImage *image = nil;
        if (self.isLiveStream) {
            image = (video.assetSet.show.primaryChannel.image) ?: video.assetSet.rubric.primaryChannel.image;
        }
        else {
            image = ([video isFullLength] && video.assetSet.show.image) ? video.assetSet.show.image : video.image;
        }
        
        SRGILImageRepresentation *imgRep = [image imageRepresentationForVideoCell];
        return imgRep.URL;
    }
    return nil;
}

@end

@interface SRGILMediaMetadata ()
@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *parentTitle;
@property(nonatomic, strong) NSString *mediaDescription;
@property(nonatomic, strong) NSString *imageURLString;
@property(nonatomic, strong) NSString *radioShortName;

@property(nonatomic, strong) NSDate *publicationDate;
@property(nonatomic, strong) NSDate *expirationDate;
@property(nonatomic, strong) NSDate *favoriteChangeDate;

@property(nonatomic, assign) long durationInMs;
@property(nonatomic, assign) int viewCount;
@property(nonatomic, assign) BOOL isDownloadable;
@property(nonatomic, assign) BOOL isFavorite;
@end

@implementation SRGILMediaMetadata

+ (SRGILMediaMetadata *)mediaMetadataForMedia:(SRGILMedia *)media
{
    if (!media) {
        return nil;
    }
    
    SRGILMediaMetadata *md = [[SRGILMediaMetadata alloc] init];
    
    md.identifier = [media identifier];
    md.title = [media title];
    md.parentTitle = [media parentTitle];
    md.mediaDescription = [media mediaDescription];
    md.imageURLString = [[media contentURL] path];
    
    md.publicationDate = media.assetSet.publishedDate;
    
    md.durationInMs = media.duration * 1000.0;
    md.viewCount = (int)[media viewCount];
    md.isDownloadable = NO;
    md.isFavorite = NO;
    
    return md;
}

+ (SRGILMediaMetadata *)mediaMetadataForContainer:(id<RTSMediaMetadataContainer>)container
{
    if (!container) {
        return nil;
    }
    
    SRGILMediaMetadata *md = [[SRGILMediaMetadata alloc] init];
    
    md.identifier = [container identifier];
    md.title = [container title];
    md.parentTitle = [container parentTitle];
    md.mediaDescription = [container mediaDescription];
    md.imageURLString = [container imageURLString];
    
    md.publicationDate = [container publicationDate];
    
    md.durationInMs = [container durationInMs];
    md.viewCount = [container viewCount];
    md.isDownloadable = [container isDownloadable];
    md.isFavorite = [container isFavorite];
    
    return md;
}

@end
