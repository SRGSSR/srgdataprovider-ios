//
//  SRGILShowMetadata.m
//  Pods
//
//  Created by Cédric Foellmi on 06/05/15.
//
//

#import "SRGILShowMetadata.h"

@implementation SRGILShowMetadata

+ (SRGILShowMetadata *)showMetadataForShow:(SRGILShow *)show
{
    if (!show) {
        return nil;
    }
    
    SRGILShowMetadata *md = [[SRGILShowMetadata alloc] init];
    
    md.identifier = [show identifier];
    md.title = [show title];
    md.imageURLString = [[[show.image imageRepresentationForUsage:SRGILMediaImageUsageWeb] URL] description];

    md.isFavorite = NO;
    
    return md;
}

@end
