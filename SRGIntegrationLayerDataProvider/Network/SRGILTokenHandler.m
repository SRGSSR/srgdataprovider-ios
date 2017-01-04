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
        NSError *deserializationError = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
        NSString *tokenParameterString = [[JSON objectForKey:@"token"] objectForKey:@"authparams"];
        
        NSURL *finalURL = nil;
        
        if (tokenParameterString) {
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
            
            finalURL = URLComponents.URL;
            DDLogDebug(@"Final Tokenized URL: %@", finalURL);
        }
        
        if (!finalURL) {
            finalURL = url;
            DDLogDebug(@"Final URL without token: %@ - error: %@", finalURL, error ?: deserializationError ?: nil);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock ? completionBlock(finalURL, error ?: deserializationError ?: nil) : nil;
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
