//
//  SRGILMediaMetadata.m
//  SRGIntegrationLayerDataProvider
//
//  Created by Cédric Foellmi on 23/04/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SRGILModelConstants.h"
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
@property(nonatomic, strong) NSString *parentTitle;
@property(nonatomic, strong) NSString *mediaDescription;

@property(nonatomic, strong) NSDate *publicationDate;

@property(nonatomic, assign) SRGILMediaType type;
@property(nonatomic, assign) long durationInMs;
@property(nonatomic, assign) int viewCount;
@property(nonatomic, assign) BOOL isDownloadable;
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
    md.imageURLString = [media.thumbnailURL description];

    md.publicationDate = media.assetSet.publishedDate;
    
    md.durationInMs = media.duration * 1000.0;
    md.viewCount = (int)[media viewCount];
    md.isDownloadable = NO;
    md.isFavorite = NO;
    md.type = media.type;

    return md;
}

- (instancetype)initWithContainer:(id<RTSMediaMetadataContainer>)container
{
    self = [super initWithContainer:container];
    if (self) {
        self.parentTitle = [container parentTitle];
        self.mediaDescription = [container mediaDescription];

        self.publicationDate = [container publicationDate];
        
        self.durationInMs = [container durationInMs];
        self.viewCount = [container viewCount];
        self.isDownloadable = [container isDownloadable];
        
        self.type = [container type];
    }
    return self;
}

@end
