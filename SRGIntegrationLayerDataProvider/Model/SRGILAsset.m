//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

#import "SRGILAsset.h"
#import "SRGILMedia.h"
#import "SRGILVideo.h"

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

@implementation SRGILAsset

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _title = [dictionary objectForKey:@"title"];
        
        NSMutableArray *medias = [NSMutableArray array];
        NSMutableArray *otherChildren = [NSMutableArray array];
        
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            Class itemClass = NSClassFromString([@"SRGIL" stringByAppendingString:key]);
            
            if (itemClass) {
                if ([obj isKindOfClass:[NSArray class]]) {
                    
                    NSMutableArray *tmpSegments = [NSMutableArray array];
                    NSMutableArray *tmpChildren = [NSMutableArray array];
                    
                    [obj enumerateObjectsUsingBlock:^(NSDictionary *rawSegment, NSUInteger idx, BOOL *stop) {
                        id item = [[itemClass alloc] initWithDictionary:rawSegment];
                        
                        if ([item isKindOfClass:[SRGILMedia class]]) {
                            [tmpSegments addObject:item];
                        }
                        else {
                            [tmpChildren addObject:item];
                        }
                    }];
                    
                    if (tmpSegments.count > 0) {
                        [medias addObjectsFromArray:[tmpSegments sortedArrayUsingSelector:@selector(compareMarkInTimes:)]];
                    }

                    if (tmpChildren.count > 0) {
                        [otherChildren addObjectsFromArray:tmpChildren];
                    }
                }
                else {
                    DDLogError(@"Expecting an array of media, not %@. Ignoring.", NSStringFromClass([obj class]));
                }
            }
            else {
                DDLogError(@"Unknown class %@ found inside asset. Ignored.", key);
            }
        }];
        
        _medias = [medias copy];
        _otherChildren = [otherChildren copy];
    }
    return self;
}

- (SRGILMedia *)fullLengthMedia
{
    return [[_medias filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SRGILMedia *media, NSDictionary<NSString *,id> * _Nullable bindings) {
        return media.isFullLength;
    }]] firstObject];
}

- (NSArray *)mediaSegments
{
    return [_medias filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SRGILMedia *media, NSDictionary<NSString *,id> * _Nullable bindings) {
        return !media.isFullLength;
    }]];
}

@end
