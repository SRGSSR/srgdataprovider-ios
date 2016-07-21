//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGRelatedContent.h"
#import "SRGResource.h"
#import "SRGSubtitle.h"
#import "SRGTypes.h"

#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRGChapter : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *uid;

@property (nonatomic, readonly, copy) NSString *URN;
@property (nonatomic, readonly, copy) NSString *vendor;
@property (nonatomic, readonly) SRGMediaType mediaType;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *lead;
@property (nonatomic, readonly, copy) NSString *summary;

@property (nonatomic, readonly, copy) NSString *imageTitle;

@property (nonatomic, readonly) SRGContentType contentType;
@property (nonatomic, readonly) SRGSource source;

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSTimeInterval duration;

@property (nonatomic, readonly) NSURL *podcastStandardDefinitionURL;
@property (nonatomic, readonly) NSURL *podcastHighDefinitionURL;

@property (nonatomic, readonly) NSInteger position;
@property (nonatomic, readonly) NSTimeInterval markIn;
@property (nonatomic, readonly) NSTimeInterval markOut;

@property (nonatomic, readonly) NSArray<SRGResource *> *resources;
@property (nonatomic, readonly) NSArray<SRGRelatedContent *> *relatedContents;
@property (nonatomic, readonly) NSArray<SRGSubtitle *> *subtitles;

@end

NS_ASSUME_NONNULL_END
