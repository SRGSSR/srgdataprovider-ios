//
//  SRGAssetSet.m
//  SRFPlayer
//
//  Created by Samuel Défago on 12/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILAssetSet.h"
#import "SRGILAsset.h"

SRGAssetSubSetType assetSubSetTypeForString(NSString *subtypeString)
{
    SRGAssetSubSetType result = SRGAssetSubSetTypeUnknown;    
    if (subtypeString) {
        if ([@"EPISODE" isEqualToString:subtypeString]) {
            return SRGAssetSubSetTypeEpisode;
        }
        
        if ([@"TRAILER" isEqualToString:subtypeString]) {
            return SRGAssetSubSetTypeTrailer;
        }
        
        if ([@"LIVESTREAM" isEqualToString:subtypeString]) {
            return SRGAssetSubSetTypeLivestream;
        }
    }
    
    return result;
}

@implementation SRGILAssetSet

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _show = [[SRGILShow alloc] initWithDictionary:[dictionary objectForKey:@"Show"]];
        _rubric = [[SRGILRubric alloc] initWithDictionary:[dictionary objectForKey:@"Rubric"]];
        _subtype = assetSubSetTypeForString([dictionary objectForKey:@"assetSubSetId"]);
        
        NSString *publishedDateString = (NSString *)[dictionary objectForKey:@"publishedDate"];
        static NSDateFormatter *dateFormatter;
        static dispatch_once_t dateFormatterOnceToken;
        dispatch_once(&dateFormatterOnceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        });
        _publishedDate = [dateFormatter dateFromString:publishedDateString];
        
        _assetGroupId = [dictionary objectForKey:@"assetGroupId"];
        _title = [dictionary objectForKey:@"title"];
        
        id rawAssetsDictionaries = [dictionary objectForKey:@"Assets"];
        if ([rawAssetsDictionaries isKindOfClass:[NSDictionary class]]) {
            rawAssetsDictionaries = @[rawAssetsDictionaries];
        }
        
        NSMutableArray *tmp = [NSMutableArray array];
        for (NSDictionary *rawAssetDict in rawAssetsDictionaries) {
            SRGILAsset *asset = [[SRGILAsset alloc] initWithDictionary:rawAssetDict];
            if (asset) {
                [tmp addObject:asset];
            }
        }
        _assets = [NSArray arrayWithArray:tmp];
    }
    return self;
}

@end
