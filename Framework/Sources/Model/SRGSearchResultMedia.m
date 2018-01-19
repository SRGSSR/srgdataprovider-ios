//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGSearchResultMedia.h"

#import "NSURL+SRGDataProvider.h"
#import "SRGJSONTransformers.h"
#import "SRGSearchResult+Private.h"

#import <libextobjc/libextobjc.h>

@interface SRGSearchResultMedia ()

@property (nonatomic) NSDate *date;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) SRGPresentation presentation;
@property (nonatomic, copy) NSString *episodeUid;
@property (nonatomic, copy) NSString *episodeTitle;
@property (nonatomic, copy) NSString *showUid;
@property (nonatomic, copy) NSString *showTitle;
@property (nonatomic, copy) NSString *channelUid;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic) SRGMediaURN *URN;
@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic) SRGVendor vendor;

@end

@implementation SRGSearchResultMedia

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    static NSDictionary *s_mapping;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        NSMutableDictionary *mapping = [[super JSONKeyPathsByPropertyKey] mutableCopy];
        [mapping addEntriesFromDictionary:@{ @keypath(SRGSearchResultMedia.new, date) : @"date",
                                             @keypath(SRGSearchResultMedia.new, duration) : @"duration",
                                             @keypath(SRGSearchResultMedia.new, presentation) : @"presentation",
                                             @keypath(SRGSearchResultMedia.new, episodeUid) : @"episode.id",
                                             @keypath(SRGSearchResultMedia.new, episodeTitle) : @"episode.title",
                                             @keypath(SRGSearchResultMedia.new, showUid) : @"show.id",
                                             @keypath(SRGSearchResultMedia.new, showTitle) : @"show.title",
                                             @keypath(SRGSearchResultMedia.new, channelUid) : @"channelId",
                                              
                                             @keypath(SRGSearchResultMedia.new, uid) : @"id",
                                             @keypath(SRGSearchResultMedia.new, URN) : @"urn",
                                             @keypath(SRGSearchResultMedia.new, mediaType) : @"mediaType",
                                             @keypath(SRGSearchResultMedia.new, vendor) : @"vendor" }];
        s_mapping = [mapping copy];
    });
    return s_mapping;
}

#pragma mark Transformers

+ (NSValueTransformer *)dateJSONTransformer
{
    return SRGISO8601DateJSONTransformer();
}

+ (NSValueTransformer *)URNJSONTransformer
{
    return SRGMediaURNJSONTransformer();
}

+ (NSValueTransformer *)mediaTypeJSONTransformer
{
    return SRGMediaTypeJSONTransformer();
}

+ (NSValueTransformer *)vendorJSONTransformer
{
    return SRGVendorJSONTransformer();
}

+ (NSValueTransformer *)presentationJSONTransformer
{
    return SRGPresentationJSONTransformer();
}

#pragma mark Overrides

// TODO: This override is only required because of uid-based image URL overriding. Drop when image overriding is not
//       required anymore.
- (NSURL *)imageURLForDimension:(SRGImageDimension)dimension withValue:(CGFloat)value type:(SRGImageType)type
{
    return [self.imageURL srg_URLForDimension:dimension withValue:value uid:self.uid type:type];
}

#pragma mark Equality

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SRGSearchResultMedia *otherSearchResultMedia = object;
    return [self.URN isEqual:otherSearchResultMedia.URN];
}

- (NSUInteger)hash
{
    return self.URN.hash;
}

@end
