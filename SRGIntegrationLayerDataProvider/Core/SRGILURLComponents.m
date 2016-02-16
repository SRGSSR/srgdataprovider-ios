//
//  SRGILFetchPath.m
//  SRGIntegrationLayerDataProvider
//  Copyright © 2015 SRG. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

#import "SRGILURLComponents.h"
#import "SRGILURLComponents+Private.h"

#import "NSBundle+SRGILDataProvider.h"

#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelDebug;
#else
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#endif

NSURLQueryItem *NSURLQueryItemForName(NSString *name, NSDate *date, BOOL withTime);
NSURLQueryItem *NSURLQueryItemForName(NSString *name, NSDate *date, BOOL withTime)
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorianCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    NSString *dateString = [NSString stringWithFormat:@"%4li-%02li-%02li",
                            (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day];
    
    if (withTime) {
        NSString *timeString = [NSString stringWithFormat:@"T%02li:%02li:%02li",
                                (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
        
        dateString = [dateString stringByAppendingString:timeString];
    }
    return [NSURLQueryItem queryItemWithName:name value:dateString];
}


@interface SRGILURLComponents ()
@property(nonatomic, strong) NSURLComponents *wrapped;
@property(nonatomic, assign) SRGILFetchListIndex index;
@property(nonatomic, copy) NSString *identifier;
@end

@implementation SRGILURLComponents

+ (nullable SRGILURLComponents *)componentsForFetchListIndex:(SRGILFetchListIndex)index
                                              withIdentifier:(nullable NSString *)identifier
                                                       error:(NSError * __nullable __autoreleasing * __nullable)error;
{
    if (index < SRGILFetchListEnumBegin || index >= SRGILFetchListEnumEnd) {
        if (error) {
            *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                         code:SRGILDataProviderErrorCodeInvalidRequest
                                     userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The request is invalid.", nil) }];
        }
        return nil;
    }
    
    SRGILURLComponents *components = [[SRGILURLComponents alloc] init];
    components.index = index;
    components.identifier = identifier;
    
    switch (index) {
            // --- Videos ---
            
        case SRGILFetchListVideoTrendingPicks: {
            components.path = @"/video/trendingPicks.json";
            components.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"10"],
                                      [NSURLQueryItem queryItemWithName:@"onlyEpisodes" value:@"true"]];
            break;
        }
            
        case SRGILFetchListVideoLiveStreams: {
            components.path = @"/video/livestream.json";
            break;
        }
            
        case SRGILFetchListVideoEditorialPicks: {
            components.path = @"/video/editorialPlayerPicks.json";
            components.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            break;
        }
            
        case SRGILFetchListVideoMostClicked: {
            components.path = @"/video/mostClicked.json";
            NSMutableArray *queryItems = [NSMutableArray array];
            [queryItems addObject:[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            [queryItems addObject:[NSURLQueryItem queryItemWithName:@"period" value:@"24"]];
            if (identifier.length > 0) {
                [queryItems addObject:[NSURLQueryItem queryItemWithName:@"topic" value:identifier]];
            }
            components.queryItems = [queryItems copy];
            break;
        }
            
        case SRGILFetchListVideoMostRecent: { // Just specify NO topic!
            components.path = @"/video/editorialPlayerLatest.json";
            components.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            break;
        }
            
        case SRGILFetchListVideoEpisodesByDate: {
            components.path = @"/video/episodesByDate.json";
            components.queryItems = @[NSURLQueryItemForName(@"day", [NSDate date], NO)];
            break;
        }
            
        case SRGILFetchListVideoTopics: {
            components.path = @"/tv/topic.json";
            break;
        }

        case SRGILFetchListVideoMostRecentByTopic: {
            if (identifier.length > 0) {
                components.path = [NSString stringWithFormat:@"/video/editorialPlayerLatestByTopic/%@.json", identifier];
                components.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            }
            break;
        }
            
        case SRGILFetchListVideoSearch: {
            components.path = @"/video/search.json";
            components.queryItems = @[[NSURLQueryItem queryItemWithName:@"q" value:SRGILFetchListURLComponentsEmptySearchQueryString],
                                     [NSURLQueryItem queryItemWithName:@"pageSize" value:@"24"]];
            break;
        }
            
            // --- Video Shows ---
            
        case SRGILFetchListVideoShowsAlphabetical: {
            components.path = @"/tv/assetGroup/editorialPlayerAlphabetical.json";
            break;
        }
            
        case SRGILFetchListVideoShowsSearch: {
            components.path = @"/tv/assetGroup/search.json";
            components.queryItems = @[[NSURLQueryItem queryItemWithName:@"q" value:SRGILFetchListURLComponentsEmptySearchQueryString],
                                     [NSURLQueryItem queryItemWithName:@"pageSize" value:@"24"]];
            break;
        }
            
            // --- Audio & Video Show Detail ---
            
        case SRGILFetchListVideoShowDetail:
        case SRGILFetchListAudioShowDetail: {
            if (identifier.length > 0) {
                components.path = [NSString stringWithFormat:@"/assetSet/listByAssetGroup/%@.json", identifier];
                components.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            }
            break;
        }
            
            // --- Audios ---
            
        case SRGILFetchListAudioLiveStreams: {
            if (identifier.length > 0) {
                components.path = [NSString stringWithFormat:@"/audio/play/%@.json", identifier];
            }
            break;
        }
            
        case SRGILFetchListAudioEditorialLatest: {
            if (identifier.length > 0) {
                components.path = [NSString stringWithFormat:@"/audio/editorialPlayerLatestByChannel/%@.json", identifier];
                components.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            }
            break;
        }
            
        case SRGILFetchListAudioMostClicked: {
            if (identifier.length > 0) {
                components.path = [NSString stringWithFormat:@"/audio/mostClickedByChannel/%@.json", identifier];
                components.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            }
            break;
        }
            
        case SRGILFetchListAudioMostRecent: {
            if (identifier.length > 0) {
                components.path = [NSString stringWithFormat:@"/audio/latestEpisodesByChannel/%@.json", identifier];
                components.queryItems = @[[NSURLQueryItem queryItemWithName:@"pageSize" value:@"20"]];
            }
            break;
        }
            
        case SRGILFetchListAudioSearch: {
            components.path = @"/audio/search.json";
            components.queryItems = @[[NSURLQueryItem queryItemWithName:@"q" value:SRGILFetchListURLComponentsEmptySearchQueryString],
                                     [NSURLQueryItem queryItemWithName:@"pageSize" value:@"24"]];
            break;
        }
            
            // --- Audio Shows ---
            
        case SRGILFetchListAudioShowsAlphabetical: {
            if (identifier.length > 0) {
                components.path = [NSString stringWithFormat:@"/radio/assetGroup/editorialPlayerAlphabeticalByChannel/%@.json", identifier];
            }
            break;
        }
            
        case SRGILFetchListAudioShowsSearch: {
            components.path = @"/radio/assetGroup/search.json";
            components.queryItems = @[[NSURLQueryItem queryItemWithName:@"q" value:SRGILFetchListURLComponentsEmptySearchQueryString],
                                     [NSURLQueryItem queryItemWithName:@"pageSize" value:@"24"]];
            break;
        }
            
            // -- Songlog --
            
        case SRGILFetchListSonglogPlaying: {
            if (identifier.length > 0) {
                components.path = [NSString stringWithFormat:@"/songlog/playingByChannel/%@.json", identifier];
            }
            break;
        }
            
        case SRGILFetchListSonglogLatest: {
            if (identifier.length > 0) {
                components.path = [NSString stringWithFormat:@"/songlog/latestByChannel/%@.json", identifier];
                
                NSDate *now = [NSDate date];
                NSDate *yesterday = [now dateByAddingTimeInterval:-86400.0];
                
                components.queryItems = @[NSURLQueryItemForName(@"fromDate", yesterday, YES),
                                          NSURLQueryItemForName(@"toDate", now, YES),
                                          [NSURLQueryItem queryItemWithName:@"pageSize" value:@"10"],
                                          [NSURLQueryItem queryItemWithName:@"pageNumber" value:@"1"]];
            }
            break;
        }

        default:
            break;
    }

    if (!components.path) {
        if (error) {
            *error = [NSError errorWithDomain:SRGILDataProviderErrorDomain
                                         code:SRGILDataProviderErrorCodeInvalidRequest
                                     userInfo:@{ NSLocalizedDescriptionKey : SRGILDataProviderLocalizedString(@"The request is invalid.", nil) }];
        }
    }
    
    return components;
}

- (void)updateQueryItemsWithSearchString:(NSString *)newQueryString
{
    NSParameterAssert(newQueryString);
    [self replaceQueryItemWithName:@"q" withNewItem:[NSURLQueryItem queryItemWithName:@"q" value:newQueryString]];
}

- (void)updateQueryItemsWithPageSize:(NSString *)newPageSize
{
    NSParameterAssert(newPageSize);
    [self replaceQueryItemWithName:@"pageSize" withNewItem:[NSURLQueryItem queryItemWithName:@"pageSize" value:newPageSize]];
}

- (void)updateQueryItemsWithDate:(NSDate *)newDate
{
    NSParameterAssert(newDate);
    if (self.index == SRGILFetchListVideoEpisodesByDate) {
        [self replaceQueryItemWithName:@"day" withNewItem:NSURLQueryItemForName(@"day", newDate, NO)];
    }
    else {
        DDLogDebug(@"Providing a date for an index different from SRGILFetchListVideoEpisodesByDate has no effect.");
    }
}

- (void)replaceQueryItemWithName:(nonnull NSString *)name withNewItem:(nonnull NSURLQueryItem *)newItem
{
    NSMutableArray *items = [self.queryItems mutableCopy];
    if (!items) {
        items = [NSMutableArray array];
    }
    NSArray *filteredArray = [self.queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]];
    if (filteredArray.count == 1) {
        [items removeObject:filteredArray.lastObject];
    }
    [items addObject:newItem];
    self.queryItems = items;
}

- (BOOL)canIncrementPageNumberBoundedByTotal:(NSInteger)totalItemsCount
{
    NSArray *pageSizeItems = [self.queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"pageSize"]];
    if (pageSizeItems.count != 1) {
        return NO; // There is no pageSize in query, hence nothing we can increment.
    }
    
    NSInteger currentPageSize = [[pageSizeItems.lastObject valueForKey:@"value"] integerValue];
    NSInteger expectedNewMax = ([self currentPageNumber] + 1) * currentPageSize;
    BOOL hasReachedEnd = (expectedNewMax - totalItemsCount >= currentPageSize);
    
    return !hasReachedEnd;
}

- (BOOL)incrementPageNumberBoundedByTotal:(NSInteger)totalItemsCount
{
    if ([self canIncrementPageNumberBoundedByTotal:totalItemsCount]) {
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:@"pageNumber" value:[@([self currentPageNumber]+1) stringValue]];
        [self replaceQueryItemWithName:@"pageNumber" withNewItem:item];
        return YES;
    }
    
    return NO;
}

- (NSInteger)currentPageNumber
{
    // The IL is 1-based, not 0-based...
    NSArray *pageNumberItems = [self.queryItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"pageNumber"]];
    NSAssert(pageNumberItems.count <= 1, @"Multiple pageNumber query items?");
    return (pageNumberItems.count == 1) ? [[pageNumberItems.lastObject valueForKey:@"value"] integerValue] : 1;
}

#pragma mark - Constructors

+ (instancetype)componentsWithString:(NSString *)URLString
{
    return [[SRGILURLComponents alloc] initWithString:URLString];
}

+ (instancetype)componentsWithURL:(NSURL *)url resolvingAgainstBaseURL:(BOOL)resolve
{
    return [[SRGILURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:resolve];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wrapped = [[NSURLComponents alloc] init];
    }
    return self;
}

- (instancetype)initWithString:(NSString *)URLString
{
    self = [super init];
    if (self) {
        self.wrapped = [[NSURLComponents alloc] initWithString:URLString];
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url resolvingAgainstBaseURL:(BOOL)resolve
{
    self = [super init];
    if (self) {
        self.wrapped = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:resolve];
    }
    return self;
}

#pragma mark - Accessors

// Required. Otherwise, we get *** Terminating app due to uncaught exception 'NSInvalidArgumentException',
// reason: '*** -setPath: only defined for abstract class.  Define -[SRGILURLComponents setPath:]!'
// Basically, NSURLComponents cannot be subclassed without using a decorator pattern, as it is done here.
// See also https://twitter.com/zadr/status/422482466394624000

- (NSString *)fragment
{
    return self.wrapped.fragment;
}

- (void)setFragment:(NSString *)fragment
{
    self.wrapped.fragment = fragment;
}

- (NSString *)host
{
    return self.wrapped.host;
}

- (void)setHost:(NSString *)host
{
    self.wrapped.host = host;
}

- (NSString *)password
{
    return self.wrapped.password;
}

- (void)setPassword:(NSString *)password
{
    self.wrapped.password = password;
}

- (NSString *)path
{
    return self.wrapped.path;
}

- (void)setPath:(NSString *)path
{
    self.wrapped.path = path;
}

- (NSNumber *)port
{
    return self.wrapped.port;
}

- (void)setPort:(NSNumber *)port
{
    self.wrapped.port = port;
}

- (NSString *)query
{
    return self.wrapped.query;
}

- (void)setQuery:(NSString *)query
{
    self.wrapped.query = query;
}

- (NSArray<NSURLQueryItem *> *)queryItems
{
    return self.wrapped.queryItems;
}

- (void)setQueryItems:(NSArray<NSURLQueryItem *> *)queryItems
{
    self.wrapped.queryItems = queryItems;
}

- (NSString *)scheme
{
    return self.wrapped.scheme;
}

- (void)setScheme:(NSString *)scheme
{
    self.wrapped.scheme = scheme;
}

- (NSString *)user
{
    return self.wrapped.user;
}

- (void)setUser:(NSString *)user
{
    self.wrapped.user = user;
}

- (NSString *)string
{
    return self.wrapped.string;
}

- (NSURL *)URL
{
    return self.wrapped.URL;
}

- (NSURL *)URLRelativeToURL:(NSURL *)baseURL
{
    return [self.wrapped URLRelativeToURL:baseURL];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    SRGILURLComponents *copy = [[SRGILURLComponents alloc] init];
    copy.wrapped = [self.wrapped copyWithZone:zone];
    copy.index = self.index;
    copy.identifier = [self.identifier copyWithZone:zone];
    return copy;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)anObject
{
    if ([anObject isKindOfClass:[SRGILURLComponents class]]) {
        SRGILURLComponents *anOtherURLComponents = (SRGILURLComponents *)anObject;
        return ([self.wrapped.URL isEqual:anOtherURLComponents.wrapped.URL] &&
                self.index == anOtherURLComponents.index);
    }
    else
        return NO;
}

- (NSUInteger)hash
{
    return self.wrapped.URL.hash ^ (self.index + 1);
}

@end
