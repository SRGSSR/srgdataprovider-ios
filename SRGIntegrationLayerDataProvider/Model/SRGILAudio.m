//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGILAudio.h"

@implementation SRGILAudio

- (SRGILMediaType)type
{
    return SRGILMediaTypeAudio;
}

- (NSURL *)contentURL
{
    return self.MQHLSURL ?: self.MQHTTPURL;
}

@end
