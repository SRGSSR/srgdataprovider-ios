//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGMediaURN.h"
#import "SRGJSONTransformers.h"

@interface SRGMediaURN ()

@property (nonatomic) NSString *uid;
@property (nonatomic) SRGMediaType mediaType;
@property (nonatomic) SRGVendor vendor;
@property (nonatomic) NSString *URN;

@end

@implementation SRGMediaURN

- (instancetype)initWithURN:(NSString *)URN {
    
    NSArray<NSString *> *components = [URN componentsSeparatedByString:@":"];
    
    if ([components containsObject:@"ais"]) {
        NSMutableArray *mutableComponents = components.mutableCopy;
        [mutableComponents removeObject:@"ais"];
        components = mutableComponents.copy;
    }
    
    if (components.count != 4) {
        return nil;
    }
    
    if (! [components.firstObject isEqualToString:@"urn"]) {
        return nil;
    }
    
    if (self = [super init]) {
        self.uid = components[3];
        
        NSNumber *mediaType = [SRGMediaTypeJSONTransformer() transformedValue:components[2].uppercaseString];
        self.mediaType = mediaType.integerValue;
        
        NSNumber *vendor = [SRGVendorJSONTransformer() transformedValue:components[1].uppercaseString];
        self.vendor = vendor.integerValue;
        
        self.URN = URN;
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithURN:@""];
    return self;
}

@end
