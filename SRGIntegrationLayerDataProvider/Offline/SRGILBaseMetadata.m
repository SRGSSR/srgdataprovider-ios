//
//  SRGILBaseMetadata.m
//  Pods
//
//  Created by Cédric Foellmi on 06/05/15.
//
//

#import "SRGILBaseMetadata.h"


@implementation SRGILBaseMetadata

+ (instancetype)metadataForContainer:(id<SRGBaseMetadataContainer>)container
{
    return [[[self class] alloc] initWithContainer:container];
}

- (instancetype)initWithContainer:(id<SRGBaseMetadataContainer>)container
{
    if (!container) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.identifier = [container identifier];
        self.title = [container title];
        self.imageURLString = [container imageURLString];
        self.isFavorite = [container isFavorite];

        self.audioChannelID = ([[container audioChannelID] length]) ? [container audioChannelID] : nil;
    }
    return self;
}

@end
