//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMedia.h"

@interface SRGChapter : SRGMedia

@property (nonatomic) NSInteger position;
@property (nonatomic) NSTimeInterval markIn;
@property (nonatomic) NSTimeInterval markOut;

@property (nonatomic, copy) NSString *eventInformation;

@end
