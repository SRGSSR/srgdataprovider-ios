//
//  SRGAsset.m
//  SRFPlayer
//
//  Created by Cédric Foellmi on 28/08/2014.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILAsset.h"
#import "SRGILMedia.h"
#import "SRGILVideo.h"

@implementation SRGILAsset

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _title = [dictionary objectForKey:@"title"];
        
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            Class itemClass = NSClassFromString([@"SRG" stringByAppendingString:key]);
            
            if (itemClass && [obj isKindOfClass:[NSArray class]]) {
                NSMutableArray *tmpSegments = [NSMutableArray array];

                [obj enumerateObjectsUsingBlock:^(NSDictionary *rawSegment, NSUInteger idx, BOOL *stop) {
                    id item = [[itemClass alloc] initWithDictionary:rawSegment];
                    if ([item isKindOfClass:[SRGILMedia class]]) {
                        if ([(SRGILMedia *)item isFullLength]) {
                            _fullLengthMedia = item;
                        }
                        else {
                            // Skip full length videos
                            [tmpSegments addObject:item];
                        }
                    }
                    else {
                        // Handle that case. Good luck for next developer....
                    }
                }];
                
                NSAssert([itemClass instancesRespondToSelector:@selector(compareMarkInTimes:)], @"Missing method!");
                if ([tmpSegments count] > 0) {
                    _mediaSegments = [tmpSegments sortedArrayUsingSelector:@selector(compareMarkInTimes:)];
                }
                
            }
        }];
    }
    return self;
}

- (void)reloadWithFullLengthMedia:(SRGILMedia *)media
{
    _fullLengthMedia = media;
    _mediaSegments = media.segments;
}

@end
