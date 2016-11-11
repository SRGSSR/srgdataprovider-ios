//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

#import "SRGILTokenHandler.h"
#import "SRGILDataProviderConstants.h"
#import "NSBundle+SRGILDataProvider.h"

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

// Keep the trailing slash
static NSString *const SRGILTokenHandlerBaseURLString = @"https://tp.srgssr.ch/akahd/token?acl=/";

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

- (NSURLSessionTask *)requestTokenForURL:(NSURL *)url
                         completionBlock:(SRGILTokenRequestCompletionBlock)completionBlock
{
    NSParameterAssert(url);
    
    DDLogDebug(@"Requesting token for URL: %@", url);
    
    NSURLSessionTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithURL:[self tokenRequestURLForURL:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock ? completionBlock(nil, error) : nil;
            });
            return;
        }
        
        void (^reportPlaybackError)(void) = ^{
            NSError *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                 code:SRGILDataProviderErrorCodeInvalidData
                                             userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The media cannot be played.", nil) }];
            completionBlock ? completionBlock(nil, error) : nil;
        };
        
        NSError *deserializationError = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
        if (deserializationError || ![JSON isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                reportPlaybackError();
            });
            return;
        }
        
        NSString *tokenParameterString = [[JSON objectForKey:@"token"] objectForKey:@"authparams"];
        if (!tokenParameterString) {
            dispatch_async(dispatch_get_main_queue(), ^{
                reportPlaybackError();
            });
            return;
        }
        
        // The value we receive is a parameter string. Build query components from it
        NSURLComponents *tokenURLComponents = [[NSURLComponents alloc] init];
        tokenURLComponents.query = tokenParameterString;
        
        NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
        
        // Merge with existing components, if any
        NSMutableArray *queryItems = URLComponents.queryItems ? [URLComponents.queryItems mutableCopy] : [NSMutableArray array];
        if (tokenURLComponents.queryItems) {
            [queryItems addObjectsFromArray:tokenURLComponents.queryItems];
        }
        URLComponents.queryItems = [queryItems copy];
        
        NSURL *finalURL = URLComponents.URL;
        DDLogDebug(@"Final Tokenized URL: %@", finalURL);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock ? completionBlock(finalURL, nil) : nil;
        });
    }];
    [sessionTask resume];
    return sessionTask;
}

- (NSURL *)tokenRequestURLForURL:(NSURL *)url
{
    NSAssert(url, @"One needs an URL here.");

    NSMutableArray *urlPaths = [NSMutableArray arrayWithArray:[url pathComponents]];
    
    [urlPaths removeObjectAtIndex:0];
    [urlPaths removeLastObject];
    [urlPaths addObject:@"*"];
    
    return [NSURL URLWithString:[SRGILTokenHandlerBaseURLString stringByAppendingString:[urlPaths componentsJoinedByString:@"/"]]];
}


@end
