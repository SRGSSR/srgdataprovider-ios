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
        
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            Class itemClass = NSClassFromString([@"SRGIL" stringByAppendingString:key]);
            
            if (itemClass) {
                if ([obj isKindOfClass:[NSArray class]]) {
                    
                    NSMutableArray *tmpSegments = [NSMutableArray array];
                    NSMutableArray *tmpChildren = [NSMutableArray array];
                    
                    [obj enumerateObjectsUsingBlock:^(NSDictionary *rawSegment, NSUInteger idx, BOOL *stop) {
                        id item = [[itemClass alloc] initWithDictionary:rawSegment];
                        
                        if ([item isKindOfClass:[SRGILMedia class]]) {
                            if (!_fullLengthMedia && [(SRGILMedia *)item isFullLength]) {
                                _fullLengthMedia = item;
                            }
                            else {
                                [tmpSegments addObject:item];
                            }
                        }
                        else {
                            [tmpChildren addObject:item];
                        }
                    }];
                    
                    if (!_fullLengthMedia && tmpSegments.count == 1) {
                        DDLogWarn(@"Found 1 media segment not being a full length and no full length media. Swapping and correcting fullLength value.");
                        _fullLengthMedia = tmpSegments.firstObject;
                        _fullLengthMedia.fullLengthNumber = @(YES);
                        [tmpSegments removeAllObjects];
                    }
                    
                    if (tmpSegments.count > 0) {
                        _mediaSegments = [tmpSegments sortedArrayUsingSelector:@selector(compareMarkInTimes:)];
                    }

                    if (tmpChildren.count > 0) {
                        _otherChildren = [tmpChildren copy];
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
    }
    return self;
}

- (void)reloadWithFullLengthMedia:(SRGILMedia *)media
{
    _fullLengthMedia = media;
    _mediaSegments = media.segments;
}

@end
