//
//  SRGILShowMetadata.m
//  Pods
//
//  Created by Cédric Foellmi on 06/05/15.
//
//

#import "SRGILShowMetadata.h"

@interface SRGILShowMetadata ()
@property(nonatomic, strong) NSString *showDescription;
@end

@implementation SRGILShowMetadata

+ (SRGILShowMetadata *)showMetadataForShow:(SRGILShow *)show
{
    if (!show) {
        return nil;
    }
    
    SRGILShowMetadata *md = [[SRGILShowMetadata alloc] init];
    
    md.identifier = show.identifier;
    md.title = show.title;
    md.imageURLString = [[[show.image imageRepresentationForUsage:SRGILMediaImageUsageWeb] URL] description];
    md.showDescription = show.showDescription;
    
    md.isFavorite = NO;
    
    return md;
}

- (instancetype)initWithContainer:(id<SRGShowMetadataContainer>)container
{
    self = [super initWithContainer:container];
    if (self) {
        self.showDescription = [container showDescription];
    }
    return self;
}

@end
