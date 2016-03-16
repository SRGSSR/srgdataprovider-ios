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
static NSString *const SRGILTokenHandlerBaseURLString = @"http://tp.srgssr.ch/akahd/token?acl=/";

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
           completionBlock:(SRGILTokenRequestCompletionBlock)completionBlock;
{
    NSParameterAssert(url);
    
    DDLogDebug(@"Requesting token for URL: %@", url);

    [[NSOperationQueue new] addOperationWithBlock:^{
        NSError *error = nil;
        NSString *JSONString = [NSString stringWithContentsOfURL:[self tokenRequestURLForURL:url]
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
        
        if (error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionBlock ? completionBlock(nil, error) : nil;
            }];
            return;
        }
        
        NSError *deserializationError = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:0
                                                               error:&deserializationError];

        if (deserializationError) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionBlock ? completionBlock(nil, deserializationError) : nil;
            }];
            return;
        }
        
        NSString *tokenParameterString = [[JSON objectForKey:@"token"] objectForKey:@"authparams"];
        if (!tokenParameterString) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionBlock ? completionBlock(nil, [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                                                           code:SRGILDataProviderErrorCodeInvalidData
                                                                       userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The media cannot be played.", nil) }]) : nil;
            }];
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
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (error) {
                completionBlock ? completionBlock(nil, error) : nil;
                return;
            }
            
            completionBlock ? completionBlock(finalURL, nil) : nil;
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
    
    return [NSURL URLWithString:[SRGILTokenHandlerBaseURLString stringByAppendingString:[urlPaths componentsJoinedByString:@"/"]]];
}


@end
