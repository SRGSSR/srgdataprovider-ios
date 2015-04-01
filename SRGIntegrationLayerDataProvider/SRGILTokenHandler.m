//
//  SRGTokenHandler.m
//  SRFPlayer
//
//  Created by Frédéric VERGEZ on 07/03/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "SRGILTokenHandler.h"
#import "SRGILErrors.h"

// Keep the trailing slash
//static NSString * const SRGTokenHandlerBaseURLString = @"http://www.srf.ch/player/token?acl=/";
static NSString * const SRGTokenHandlerBaseURLString = @"http://tp.srgssr.ch/token/akahd.json.xml?stream=/";

@implementation SRGILTokenHandler

+ (instancetype)sharedHandler
{
    static SRGILTokenHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] tokenHandlerCustomInit];
    });
    return sharedInstance;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)tokenHandlerCustomInit
{
    return [super init];
}

- (void)requestTokenForURL:(NSURL *)url
 appendLogicalSegmentation:(NSString *)segmentation
           completionBlock:(SRGILTokenRequestCompletionBlock)completionBlock;
{
    NSAssert(url, @"One needs an URL here.");
        
    [[NSOperationQueue new] addOperationWithBlock:^{
        NSError *error = nil;
        NSString *JSONString = [NSString stringWithContentsOfURL:[self tokenRequestURLForURL:url]
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
        
        if (error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionBlock(nil, error);
            }];
            return;
        }
        
        NSError *deserializationError = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:0
                                                               error:&deserializationError];

        if (deserializationError) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionBlock(nil, deserializationError);
            }];
            return;
        }
        
        if (![[JSON objectForKey:@"token"] objectForKey:@"authparams"]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //TODO Add this localized string somewhere
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"MISSING_TOKEN_AUTHPARAMS_ERROR_DESCRIPTION", nil)};
                completionBlock(nil, [NSError errorWithDomain:SRGILErrorDomain code:SRGILErrorCodeInvalidData userInfo:userInfo]);
            }];
            return;
        }

        NSMutableString *finalURLString = [[url absoluteString] mutableCopy];
        [finalURLString appendString:@"?"];
        [finalURLString appendString:[JSON[@"token"] objectForKey:@"authparams"]];

        if ([segmentation length] > 0) {
            if (![segmentation hasPrefix:@"&"]) {
                [finalURLString appendString:@"&"];
            }
            [finalURLString appendString:segmentation];
        }
       
        NSLog(@"[Debug] Final Tokenized URL: %@", finalURLString);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionBlock(!!error ? nil : [NSURL URLWithString:finalURLString], error);
        }];
    }];
}

- (NSURL *)tokenRequestURLForURL:(NSURL *)url
{
    NSAssert(url, @"One needs an URL here.");

    NSMutableArray *urlPaths = [NSMutableArray arrayWithArray:[url pathComponents]];
    
    [urlPaths removeObjectAtIndex:0];
    [urlPaths removeLastObject];
    [urlPaths addObject:@"*"];
    
    return [NSURL URLWithString:[SRGTokenHandlerBaseURLString stringByAppendingString:[urlPaths componentsJoinedByString:@"/"]]];
}

// Obsolete. But might be useful again in the future?
- (BOOL)canReadURL:(NSURL *)url
{
    NSAssert(url, @"Needs an URL to test");
    NSAssert(![NSThread isMainThread], @"Must not be run on the main thread");
    
    NSError *error;
    [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error] ;
    return (error == nil);
}

@end
