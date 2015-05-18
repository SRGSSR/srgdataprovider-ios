//
//  RTSShowMetadata.h
//  Pods
//
//  Created by Cédric Foellmi on 06/05/15.
//
//

#import <Realm/Realm.h>
#import "RTSBaseMetadata.h"
#import "RTSMediaMetadatasProtocols.h"

@interface RTSShowMetadata : RTSBaseMetadata <RTSShowMetadataContainer>
@end

RLM_ARRAY_TYPE(RTSShowMetadata)
