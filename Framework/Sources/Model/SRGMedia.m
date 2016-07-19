//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMedia.h"

@interface SRGMedia ()

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

@property (nonatomic) NSArray<SRGSocialCount *> *socialCounts;

@end

@implementation SRGMedia

#pragma mark MTLJSONSerializing protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"uid" : @"id",
              @"URN" : @"urn",
              @"mediaType" : @"mediaType",
              @"title" : @"title",
              @"lead" : @"lead",
              @"summary" : @"description",
              @"imageURL" : @"imageUrl",
              @"imageTitle" : @"imageTitle",
              @"type" : @"type",
              @"category" : @"assignedBy",
              @"date" : @"date",
              @"duration" : @"duration",
              @"podcastStandardDefinitionURL" : @"podcastSdUrl",
              @"podcastHighDefinitionURL" : @"podcastHdUrl",
              @"socialCounts" : @"socialCountList" };
}

#pragma mark Transformers

+ (NSValueTransformer *)mediaTypeJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"VIDEO": @(SRGMediaTypeVideo),
                                                                            @"AUDIO": @(SRGMediaTypeAudio) }];
}

+ (NSValueTransformer *)imageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)typeJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"EPISODE": @(SRGTypeEpisode) }];
}

+ (NSValueTransformer *)categoryJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"EDITOR": @(SRGCategoryEditor),
                                                                            @"TRENDING" : @(SRGCategoryTrending) }];
}

+ (NSValueTransformer *)dateJSONTransformer
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    });
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)podcastStandardDefinitionURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)podcastHighDefinitionURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)socialCountsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SRGSocialCount class]];
}

@end
