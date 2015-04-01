//
//  SRGModelObject.h
//  SRGPlayer
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Common (abstract) base class for SRF objects. Provide a common -description method for easy
 * object property display during debugging
 */
@interface SRGILModelObject : NSObject

/*
 * Object identifier.
 * It is automatically set when using the initWithDictionary constructor.
 */
@property(nonatomic, strong, readonly) NSString *identifier;
@property(nonatomic, strong, readonly) NSDate *downloadDate;

- (id)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  This method can be used to switch on or off the support for NSCoding for properties of the object.
 *  It is meant to be overriden by subclasses.
 *
 *  @return Flag indicating whether the encoding of properties is supported (YES) or not (NO).
 */
- (BOOL)supportAutomaticPropertiesCoding;

@end
