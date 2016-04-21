//
//  SRGILVideo2.h
//  SRGIntegrationLayerDataProvider
//
//  Created by Pierre-Yves Bertholon on 18/04/16.
//  Copyright © 2016 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILModelConstants.h"

/**
 * SRGILVideo2 is the new object for API 2.0 of the SRG Player framework.
 */
@interface SRGILVideo2 : NSObject

/**
 * The media urn (identifier)
 */
@property (nonatomic, readonly, strong) NSString *urn;

/**
 * The media type
 */
@property (nonatomic, readonly, assign) SRGILAssetSubSetType type;

/**
 * The media date
 */
@property (nonatomic, readonly, strong) NSDate *date;

/**
 * The media title
 */
@property (nonatomic, readonly, strong) NSString *title;

/**
 * The media imageTitle
 */
@property (nonatomic, readonly, strong) NSString *imageTitle;

/**
 * The media imageUrl
 */
@property (nonatomic, readonly, strong) NSURL *imageUrl;

/**
 * The media duration
 */
@property (nonatomic, readonly, assign) NSInteger duration;

/**
 * The media episodeId
 */
@property (nonatomic, readonly, assign) NSInteger episodeId;

/**
 * The media date
 */
@property (nonatomic, readonly, strong) NSString *episodeTitle;

/**
 * The media date
 */
@property (nonatomic, readonly, assign) NSInteger showId;

/**
 * The media date
 */
@property (nonatomic, readonly, strong) NSString *showTitle;

/**
 * The media livestream state (scheduled live or live)
 */
@property (nonatomic, readonly, assign) BOOL isLiveStream;


- (id)initWithDictionary:(NSDictionary *)dictionary;

//"urn" : "urn:rts:video:7589156",
//"type" : "SCHEDULED_LIVESTREAM",
//"date" : "2016-04-18T11:20:00+02:00",
//"title" : "Scènes de ménages",
//"imageTitle" : "Scènes de ménages",
//"imageUrl" : "http://www.rts.ch/2014/10/27/10/15/6200252.image",
//"duration" : 2717000,
//"episodeId" : "7589155",
//"episodeTitle" : "Scènes de ménages",
//"showId" : "4082584",
//"showTitle" : "Scènes de ménages"

@end
