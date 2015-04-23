//
//  SRGILImage.h.m
//  SRFPlayer
//
//  Created by Samuel Défago on 07/02/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import "SRGILImage.h"

@interface SRGILImage ()
@property (nonatomic) NSArray *imageRepresentations;
@end

@implementation SRGILImage

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        NSArray *imageRepDictionaries = [dictionary valueForKeyPath:@"ImageRepresentations.ImageRepresentation"];
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        for (NSDictionary *imageRepDict in imageRepDictionaries) {
            SRGILImageRepresentation *imgRep = [[SRGILImageRepresentation alloc] initWithDictionary:imageRepDict];
            if (imgRep) {
                [tmp addObject:imgRep];
            }
        }
        _imageRepresentations = [NSArray arrayWithArray:tmp];
    }
    
    return self;
}

- (SRGILImageRepresentation *)imageRepresentationForUsage:(SRGILMediaImageUsage)usage
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        SRGILImageRepresentation *rep = (SRGILImageRepresentation *)evaluatedObject;
        return rep.usage == usage;
    }];
    
    NSArray *results = [_imageRepresentations filteredArrayUsingPredicate:predicate];
    
    return [results lastObject];
}

// Don't use 'usage' key, as it is not consistent between BUs...
- (SRGILImageRepresentation *)imageRepresentationForVideoCell
{
    return [_imageRepresentations lastObject];
}

@end
