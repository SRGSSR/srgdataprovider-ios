//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider.h"

#import "NSBundle+SRGDataProvider.h"
#import "NSURLSession+SRGDataProvider.h"
#import "SRGDataProviderError.h"

#import <Mantle/Mantle.h>

NSString * const SRGBusinessIdentifierRSI = @"rsi";
NSString * const SRGBusinessIdentifierRTR = @"rtr";
NSString * const SRGBusinessIdentifierRTS = @"rts";
NSString * const SRGBusinessIdentifierSRF = @"srf";
NSString * const SRGBusinessIdentifierSWI = @"swi";

static NSString * const SRGTokenServiceURLString = @"http://tp.srgssr.ch/akahd/token";

static SRGDataProvider *s_currentDataProvider;

@interface SRGDataProvider ()

@property (nonatomic) NSURL *serviceURL;
@property (nonatomic, copy) NSString *businessUnitIdentifier;
@property (nonatomic) NSURLSession *session;

@end

@implementation SRGDataProvider

#pragma mark Class methods

+ (SRGDataProvider *)currentDataProvider
{
    return s_currentDataProvider;
}

+ (SRGDataProvider *)setCurrentDataProvider:(SRGDataProvider *)currentDataProvider
{
    SRGDataProvider *previousDataProvider = s_currentDataProvider;
    s_currentDataProvider = currentDataProvider;
    return previousDataProvider;
}

#pragma mark Object lifecycle

- (instancetype)initWithServiceURL:(NSURL *)serviceURL businessUnitIdentifier:(NSString *)businessUnitIdentifier
{
    if (self = [super init]) {
        // According to the standard, the base URL must end with a slash or the last path component will be truncated
        // See http://stackoverflow.com/questions/16582350/nsurl-urlwithstringrelativetourl-is-clipping-relative-url
        if ([serviceURL.absoluteString hasSuffix:@"/"]) {
            self.serviceURL = serviceURL;
        }
        else {
            self.serviceURL = [NSURL URLWithString:[serviceURL.absoluteString stringByAppendingString:@"/"]];
        }
        
        self.businessUnitIdentifier = businessUnitIdentifier;
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    return self;
}

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark Public requests

- (SRGRequest *)editorialVideosWithPage:(SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/soonExpiring.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil page:page];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)soonExpiringVideosWithPage:(SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/editorial.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil page:page];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)videosForDate:(NSDate *)date withPage:(nullable SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    if (!date) {
        date = [NSDate date];
    }
    
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/episodesByDate/%@.json", self.businessUnitIdentifier, dateString];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil page:page];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)trendingVideosWithPage:(SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    return [self trendingVideosWithEditorialLimit:nil episodesOnly:NO page:page completionBlock:completionBlock];
}

- (SRGRequest *)trendingVideosWithEditorialLimit:(NSNumber *)editorialLimit episodesOnly:(BOOL)episodesOnly page:(SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/trending.json", self.businessUnitIdentifier];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    if (editorialLimit) {
        editorialLimit = @(MAX(0, editorialLimit.integerValue));
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"maxCountEditorPicks" value:editorialLimit.stringValue]];
    }
    if (episodesOnly) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:@"onlyEpisodes" value:@"true"]];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:[queryItems copy] page:page];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)videoChannelsWithCompletionBlock:(SRGChannelListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/channelList/tv.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil page:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGChannel class] rootKey:@"channelList" completionBlock:^(NSArray * _Nullable objects, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, nil);
    }];
}

- (SRGRequest *)videoTopicsWithCompletionBlock:(SRGTopicListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/topicList/tv.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil page:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGTopic class] rootKey:@"topicList" completionBlock:^(NSArray * _Nullable objects, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)latestVideosWithTopicUid:(NSString *)topicUid page:(SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    
    if (topicUid) {
        resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByTopic/%@.json", self.businessUnitIdentifier, topicUid];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latest.json", self.businessUnitIdentifier];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil page:page];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)mostPopularVideosWithTopicUid:(NSString *)topicUid page:(SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/mostClicked.json", self.businessUnitIdentifier];
    
    NSArray<NSURLQueryItem *> *queryItems = nil;
    if (topicUid) {
        queryItems = @[ [NSURLQueryItem queryItemWithName:@"topicId" value:topicUid] ];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:queryItems page:page];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)eventsWithCompletionBlock:(SRGEventListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/eventConfigList.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil page:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGEvent class] rootKey:@"eventConfigList" completionBlock:^(NSArray * _Nullable objects, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)latestVideosForEventWithUid:(NSString *)eventUid sectionUid:(NSString *)sectionUid page:(SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = nil;
    
    if (sectionUid) {
        resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByEventId/%@/sectionId/%@.json", self.businessUnitIdentifier, eventUid, sectionUid];
    }
    else {
        resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/latestByEventId/%@.json", self.businessUnitIdentifier, eventUid];
    }
    
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil page:page];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)videoShowsWithCompletionBlock:(SRGShowListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/showList/tv/alphabetical.json", self.businessUnitIdentifier];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil page:nil];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGShow class] rootKey:@"showList" completionBlock:^(NSArray * _Nullable objects, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        completionBlock(objects, error);
    }];
}

- (SRGRequest *)mediaCompositionForVideoWithUid:(NSString *)mediaUid completionBlock:(SRGMediaCompositionCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaComposition/video/%@.json", self.businessUnitIdentifier, mediaUid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil page:nil];
    return [self fetchObjectWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMediaComposition class] completionBlock:completionBlock];
}

- (SRGRequest *)searchVideosMatchingQuery:(NSString *)query withPage:(SRGPage *)page completionBlock:(SRGMediaListCompletionBlock)completionBlock
{
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaList/video/search.json", self.businessUnitIdentifier];
    NSArray<NSURLQueryItem *> *queryItems = @[ [NSURLQueryItem queryItemWithName:@"q" value:query] ];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:queryItems page:page];
    return [self listObjectsWithRequest:[NSURLRequest requestWithURL:URL] modelClass:[SRGMedia class] rootKey:@"mediaList" completionBlock:completionBlock];
}

- (SRGRequest *)likeMediaComposition:(SRGMediaComposition *)mediaComposition withCompletionBlock:(SRGLikeCompletionBlock)completionBlock
{
    SRGChapter *mainChapter = mediaComposition.mainChapter;
    if (!mediaComposition.event || !mainChapter) {
        NSError *error = [NSError errorWithDomain:SRGDataProviderErrorDomain
                                             code:SRGDataProviderErrorCodeInvalidRequest
                                         userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The request is invalid.", nil) }];
        return [self reportError:error withCompletionBlock:^(NSError * _Nullable error) {
            completionBlock(nil, error);
        }];
    }
    
    NSString *mediaTypeString = (mainChapter.mediaType == SRGMediaTypeAudio) ? @"audio" : @"video";
    NSString *resourcePath = [NSString stringWithFormat:@"2.0/%@/mediaStatistic/%@/%@/liked.json", self.businessUnitIdentifier, mediaTypeString, mainChapter.uid];
    NSURL *URL = [self URLForResourcePath:resourcePath withQueryItems:nil page:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *bodyJSONDictionary = @{ @"eventData" : mediaComposition.event };
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyJSONDictionary options:0 error:NULL];
    
    return [self fetchObjectWithRequest:request modelClass:[SRGLike class] completionBlock:completionBlock];
}

- (SRGRequest *)tokenizeURL:(NSURL *)URL withCompletionBlock:(SRGURLCompletionBlock)completionBlock
{
    return [self asynchronouslyTokenizeURL:URL withCompletionBlock:^(NSURL * _Nullable URL, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(URL, error);
        });
    }];
}

#pragma mark Common implementation. Completion blocks are called on the main thread

- (SRGRequest *)listObjectsWithRequest:(NSURLRequest *)request modelClass:(Class)modelClass rootKey:(NSString *)rootKey completionBlock:(void (^)(NSArray * _Nullable objects, SRGPage * _Nullable nextPage, NSError * _Nullable error))completionBlock
{
    return [self asynchronouslyListObjectsWithRequest:request modelClass:modelClass rootKey:rootKey completionBlock:^(NSArray * _Nullable objects, SRGPage * _Nullable nextPage, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(objects, nextPage, error);
        });
    }];
}

- (SRGRequest *)fetchObjectWithRequest:(NSURLRequest *)request modelClass:(Class)modelClass completionBlock:(void (^)(id _Nullable object, NSError * _Nullable error))completionBlock
{
    return [self asynchronouslyFetchObjectWithRequest:request modelClass:modelClass completionBlock:^(id  _Nullable object, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(object, error);
        });
    }];
}

- (SRGRequest *)reportError:(NSError *)error withCompletionBlock:(void (^)(NSError * _Nullable error))completionBlock
{
    return [self.session srg_taskForError:error withCompletionHandler:^(NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(error);
        });
    }];
}

#pragma mark Asynchronous requests and processing. The completion block will be called on a background thread

- (NSURL *)URLForResourcePath:(NSString *)resourcePath withQueryItems:(NSArray<NSURLQueryItem *> *)queryItems page:(SRGPage *)page
{
    NSURL *URL = [NSURL URLWithString:resourcePath relativeToURL:self.serviceURL];
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:URL.absoluteString];
    
    NSMutableArray<NSURLQueryItem *> *fullQueryItems = [NSMutableArray array];
    if (queryItems) {
        [fullQueryItems addObjectsFromArray:queryItems];
    }
    if (page) {
        [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:@"pageSize" value:@(page.size).stringValue]];
        [fullQueryItems addObject:[NSURLQueryItem queryItemWithName:@"pageNumber" value:@(page.number).stringValue]];
    }
    URLComponents.queryItems = fullQueryItems.count != 0 ? [fullQueryItems copy] : nil;
    
    return URLComponents.URL;
}

- (SRGRequest *)asynchronouslyFetchJSONDictionaryWithRequest:(NSURLRequest *)request completionBlock:(void (^)(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(request);
    NSParameterAssert(completionBlock);
    
    return [self.session srg_dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // Don't call completion block for cancelled requests
        if (error) {
            if (![error.domain isEqualToString:NSURLErrorDomain] || error.code != NSURLErrorCancelled) {
                completionBlock(nil, error);
            }
            return;
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
            NSInteger HTTPStatusCode = HTTPURLResponse.statusCode;
            
            // Properly handle HTTP error codes >= 400 as real errors
            if (HTTPStatusCode >= 400) {
                completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                         code:SRGDataProviderErrorHTTP
                                                     userInfo:@{ NSLocalizedDescriptionKey : [NSHTTPURLResponse localizedStringForStatusCode:HTTPStatusCode],
                                                                 NSURLErrorKey : response.URL }]);
                return;
            }
            // Block redirects and return an error with URL information. Currently no redirection is expected for IL services, this
            // means redirection is probably related to a public hotspot with login page (e.g. SBB)
            else if (HTTPStatusCode >= 300) {
                NSMutableDictionary *userInfo = [@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"You are likely connected to a public wifi network with no Internet access", nil),
                                                    NSURLErrorKey : response.URL } mutableCopy];
                
                NSString *redirectionURLString = HTTPURLResponse.allHeaderFields[@"Location"];
                if (redirectionURLString) {
                    NSURL *redirectionURL = [NSURL URLWithString:redirectionURLString];
                    userInfo[SRGDataProviderRedirectionURLKey] = redirectionURL;
                }
                
                completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                         code:SRGDataProviderErrorRedirect
                                                     userInfo:[userInfo copy]]);
                return;
            }
        }
        
        id JSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        if (!JSONDictionary || ![JSONDictionary isKindOfClass:[NSDictionary class]]) {
            completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                     code:SRGDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }]);
            return;
        }
        
        completionBlock(JSONDictionary, nil);
    }];
}

- (SRGRequest *)asynchronouslyListObjectsWithRequest:(NSURLRequest *)request modelClass:(Class)modelClass rootKey:(NSString *)rootKey completionBlock:(void (^)(NSArray * _Nullable objects, SRGPage * _Nullable nextPage, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(request);
    NSParameterAssert(modelClass);
    NSParameterAssert(rootKey);
    NSParameterAssert(completionBlock);
    
    return [self asynchronouslyFetchJSONDictionaryWithRequest:request completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, nil, error);
            return;
        }
        
        NSInteger size = [JSONDictionary[@"pageSize"] integerValue];
        
        // No results, no error, no additional results
        if (size == 0) {
            completionBlock(@[], nil, nil);
            return;
        }
        
        id JSONArray = JSONDictionary[rootKey];
        if (JSONArray && [JSONArray isKindOfClass:[NSArray class]]) {
            NSArray *objects = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:JSONArray error:NULL];
            if (objects) {
                if ([JSONDictionary[@"hasMoreItems"] boolValue]) {
                    NSInteger number = [JSONDictionary[@"pageNumber"] integerValue];
                    completionBlock(objects, [[SRGPage pageWithNumber:number size:size] nextPage], nil);
                }
                else {
                    completionBlock(objects, nil, nil);
                }
                return;
            }
        }
        
        completionBlock(nil, nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                      code:SRGDataProviderErrorCodeInvalidData
                                                  userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }]);
    }];
}

- (SRGRequest *)asynchronouslyFetchObjectWithRequest:(NSURLRequest *)request modelClass:(Class)modelClass completionBlock:(void (^)(id _Nullable object, NSError * _Nullable error))completionBlock
{
    NSParameterAssert(request);
    NSParameterAssert(modelClass);
    NSParameterAssert(completionBlock);
    
    return [self asynchronouslyFetchJSONDictionaryWithRequest:request completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }
        
        id object = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:JSONDictionary error:NULL];
        if (!object) {
            completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                     code:SRGDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The data is invalid.", nil) }]);
            return;
        }
        
        completionBlock(object, nil);
    }];
}

- (SRGRequest *)asynchronouslyTokenizeURL:(NSURL *)URL withCompletionBlock:(SRGURLCompletionBlock)completionBlock
{
    NSParameterAssert(URL);
    NSParameterAssert(completionBlock);
    
    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    NSString *acl = [URLComponents.path.stringByDeletingLastPathComponent stringByAppendingPathComponent:@"*"];
    
    NSURLComponents *tokenServiceURLComponents = [NSURLComponents componentsWithURL:[NSURL URLWithString:SRGTokenServiceURLString] resolvingAgainstBaseURL:NO];
    tokenServiceURLComponents.queryItems = @[ [NSURLQueryItem queryItemWithName:@"acl" value:acl] ];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:tokenServiceURLComponents.URL];
    return [self asynchronouslyFetchJSONDictionaryWithRequest:request completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }
        
        NSString *token = nil;
        
        id tokenDictionary = JSONDictionary[@"token"];
        if ([tokenDictionary isKindOfClass:[NSDictionary class]]) {
            token = [tokenDictionary objectForKey:@"authparams"];
        }
        
        if (!token) {
            completionBlock(nil, [NSError errorWithDomain:SRGDataProviderErrorDomain
                                                     code:SRGDataProviderErrorCodeInvalidData
                                                 userInfo:@{ NSLocalizedDescriptionKey : SRGDataProviderLocalizedString(@"The stream could not be secured.", nil) }]);
            return;
        }
        
        // Use components to properly extract the token as query items
        NSURLComponents *tokenURLComponents = [[NSURLComponents alloc] init];
        tokenURLComponents.query = token;
        
        // Build the tokenized URL, merging token components with existing ones
        NSURLComponents *tokenizedURLComponents = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:NO];
        
        NSMutableArray *queryItems = [tokenizedURLComponents.queryItems mutableCopy] ?: [NSMutableArray array];
        if (tokenURLComponents.queryItems) {
            [queryItems addObjectsFromArray:tokenURLComponents.queryItems];
        }
        tokenizedURLComponents.queryItems = [queryItems copy];
        
        completionBlock(tokenizedURLComponents.URL, nil);
    }];
}

#pragma mark NSURLSessionDelegate protocol

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    // Refuse the redirection and return the redirection response (with the proper HTTP status code)
    completionHandler(nil);
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; serviceURL: %@; businessUnitIdentifier: %@>",
            [self class],
            self,
            self.serviceURL,
            self.businessUnitIdentifier];
}

@end
