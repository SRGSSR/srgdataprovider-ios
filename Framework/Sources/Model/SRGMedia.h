//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SRGMediaType) {
    SRGMediaTypeVideo,
    SRGMediaTypeAudio
};

typedef NS_ENUM(NSInteger, SRGType) {
    SRGTypeEpisode
};

typedef NS_ENUM(NSInteger, SRGCategory) {
    SRGCategoryEditor,
    SRGCategoryTrending
};

@interface SRGMedia : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *URN;
@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lead;
@property (nonatomic, copy) NSString *summary;

@property (nonatomic) NSURL *imageURL;
@property (nonatomic, copy) NSString *imageTitle;

@property (nonatomic) SRGType type;
@property (nonatomic) SRGCategory category;

@property (nonatomic) NSDate *date;
@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) NSURL *podcastStandardDefinitionURL;
@property (nonatomic) NSURL *podcastHighDefinitionURL;

@end

NS_ASSUME_NONNULL_END
