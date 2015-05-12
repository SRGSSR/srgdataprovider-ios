//
//  SRGILShowMetadata.h
//  Pods
//
//  Created by Cédric Foellmi on 06/05/15.
//
//

#import <Foundation/Foundation.h>
#import <RTSOfflineMediaStorage/RTSOfflineMediaStorage.h>
#import "SRGILBaseMetadata.h"
#import "SRGILShow.h"

@interface SRGILShowMetadata : SRGILBaseMetadata <RTSShowMetadataContainer>

+ (SRGILShowMetadata *)showMetadataForShow:(SRGILShow *)show;

@end
