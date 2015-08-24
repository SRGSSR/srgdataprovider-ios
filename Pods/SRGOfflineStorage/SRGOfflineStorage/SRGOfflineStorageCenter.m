//
//  SRGOfflineStorageCenter.m
//  SRGOfflineStorage
//
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Realm/Realm.h>

#import "SRGOfflineStorageCenter.h"
#import "RTSMediaMetadata.h"
#import "RTSShowMetadata.h"

#define REALM_NONNULL_STRING(value) ((value == nil) ? @"" : (value))

NSString * const RTSOfflineStorageErrorDomain = @"RTSOfflineStorageErrorDomain";

static NSString * const SRGOfflineStorageCenterFavoritesStorageKey = @"SRGOfflineStorageCenterFavoritesStorage";
static NSString * const SRGOfflineStorageCenterSessionIdentifier = @"SRGOfflineStorageCenterSessionIdentifier";

static NSMutableDictionary *keyedCenters = nil;

@interface SRGOfflineStorageCenter () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property(nonatomic, strong) RLMRealm *realm;
@property(nonatomic, strong) NSString *storageKey;
@property(nonatomic, strong) NSURLSession *downloadSession;
@end

@implementation SRGOfflineStorageCenter

+ (void)initialize
{
    if (self == [SRGOfflineStorageCenter class]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            keyedCenters = [[NSMutableDictionary alloc] init];
        });
    }
}

+ (SRGOfflineStorageCenter *)favoritesOffineStorageCenter
{
    SRGOfflineStorageCenter *instance = [keyedCenters objectForKey:SRGOfflineStorageCenterFavoritesStorageKey];
    if (!instance) {
        instance = [[SRGOfflineStorageCenter alloc] init_SRGOfflineStorageCenter_withStorageKey:SRGOfflineStorageCenterFavoritesStorageKey];
        keyedCenters[SRGOfflineStorageCenterFavoritesStorageKey] = instance;
    }
    return instance;
}

+ (NSString *)realmPathForStorageKey:(NSString *)storageKey
{
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *realmPath = [libraryPath stringByAppendingPathComponent:[storageKey stringByAppendingPathExtension:@"realm"]];
    return realmPath;
}

- (instancetype)init_SRGOfflineStorageCenter_withStorageKey:(NSString *)storageKey
{
    self = [super init];
    if (self) {
        self.storageKey = storageKey;
        [self setup:storageKey];
    }
    return self;
}

- (void)__resetCenter__
{
    @try {
        [self.realm cancelWriteTransaction];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    [self.realm beginWriteTransaction];
    [self.realm deleteAllObjects];
    [self.realm commitWriteTransaction];
}

- (void)setup:(NSString *)storageKey
{
    NSString *realmPath = [SRGOfflineStorageCenter realmPathForStorageKey:storageKey];
    
    [RLMRealm setSchemaVersion:2
                forRealmAtPath:realmPath
            withMigrationBlock:^(RLMMigration *migration, uint64_t oldSchemaVersion) {
                [migration enumerateObjects:RTSShowMetadata.className
                                      block:^(RLMObject *oldObject, RLMObject *newObject) {
                                          if (oldSchemaVersion < 1) {
                                              newObject[@"showDescription"] = @"";
                                          }
                                          if (oldSchemaVersion < 2) {
                                              if ([newObject isKindOfClass:[RTSMediaMetadata class]]) {
                                                  newObject[@"isDownloading"] = @(NO);
                                                  newObject[@"isDownloaded"] = @(NO);
                                                  newObject[@"downloadURLString"] = @"";
                                                  newObject[@"localURLString"] = @"";
                                              }
                                          }
                                      }];
            }];
    
    @try {
        self.realm = [RLMRealm realmWithPath:realmPath];
    }
    @catch(NSException *exception) {
        NSLog(@"Caught exception while opening Realm: %@", exception);
        
        if([exception.name isEqualToString:RLMExceptionName]) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:realmPath error:nil];
            
            self.realm = [RLMRealm realmWithPath:realmPath];
        }
        else {
            @throw; // rethrow
        }
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:SRGOfflineStorageCenterFavoritesStorageKey];
    self.downloadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
}

#pragma mark - Favorites - specific methods

- (NSArray *)flaggedAsFavoriteMediaMetadatas
{
    RLMResults *results = [[RTSMediaMetadata objectsInRealm:self.realm where:@"isFavorite = YES"] sortedResultsUsingProperty:@"favoriteChangeDate" ascending:NO];
    NSMutableArray *items = [NSMutableArray array];
    for (id<SRGMediaMetadataContainer>container in results) {
        [items addObject:container];
    }
    return [NSArray arrayWithArray:items];
}

- (NSArray *)flaggedAsFavoriteShowMetadatas
{
    RLMResults *results = [[RTSShowMetadata objectsInRealm:self.realm where:@"isFavorite = YES"] sortedResultsUsingProperty:@"favoriteChangeDate" ascending:NO];
    NSMutableArray *items = [NSMutableArray array];
    for (id<SRGShowMetadataContainer>container in results) {
        [items addObject:container];
    }
    return [NSArray arrayWithArray:items];
}

- (void)flagAsFavorite:(BOOL)favorite mediaMetadata:(id<SRGMediaMetadataContainer>)mediaMetadata
{
    [self flagAsFavorite:favorite
             itemOfClass:[RTSMediaMetadata class]
           withContainer:mediaMetadata];
}

- (void)flagAsFavorite:(BOOL)favorite showMetadata:(id<SRGShowMetadataContainer>)showMetadata
{
    [self flagAsFavorite:favorite
             itemOfClass:[RTSShowMetadata class]
          withContainer:showMetadata];
}

- (void)flagAsFavorite:(BOOL)favorite
           itemOfClass:(Class)objectClass
        withContainer:(id<SRGBaseMetadataContainer>)container
{
    if (!container.identifier) {
        @throw [NSException exceptionWithName:RTSOfflineStorageErrorDomain reason:@"Missing media|show identifier" userInfo:nil];
    }
    
    NSParameterAssert(objectClass);
    NSParameterAssert(container);
    
    RTSBaseMetadata *metadata = [objectClass objectInRealm:self.realm forPrimaryKey:container.identifier];
    [self.realm beginWriteTransaction];

    if (metadata == nil) {
        metadata = [objectClass metadataForContainer:container];
        [self.realm addObject:metadata];
    }
    else {
        [metadata udpateWithContainer:container];
    }
    
    metadata.isFavorite = favorite;
    metadata.favoriteChangeDate = [NSDate date];
    metadata.audioChannelID = REALM_NONNULL_STRING(container.audioChannelID);
    
    [self.realm commitWriteTransaction];
}

#pragma mark - Generic Storage

- (NSSet *)savedMediaMetadataIdentifiers
{
    NSAssert([RTSMediaMetadata instancesRespondToSelector:@selector(identifier)], @"Something wrong here.");
    RLMResults *results = [RTSMediaMetadata allObjectsInRealm:self.realm];
    return [results valueForKey:@"identifier"];
}

- (id<SRGMediaMetadataContainer>)mediaMetadataForIdentifier:(NSString *)identifier
{
    if (identifier) {
        return [RTSMediaMetadata objectInRealm:self.realm forPrimaryKey:identifier];
    }
    return nil;
}

- (id<SRGShowMetadataContainer>)showMetadataForIdentifier:(NSString *)identifier
{
    if (identifier) {
        return [RTSShowMetadata objectInRealm:self.realm forPrimaryKey:identifier];
    }
    return nil;
}

- (NSArray *)allSavedMediaMetadatas
{
    RLMResults *results = [RTSMediaMetadata allObjectsInRealm:self.realm];
    NSMutableArray *items = [NSMutableArray array];
    for (id<SRGMediaMetadataContainer>container in results) {
        [items addObject:container];
    }
    return [NSArray arrayWithArray:items];
}

- (NSArray *)allSavedShowMetadatas
{
    RLMResults *results = [RTSShowMetadata allObjectsInRealm:self.realm];
    NSMutableArray *items = [NSMutableArray array];
    for (id<SRGShowMetadataContainer>container in results) {
        [items addObject:container];
    }
    return [NSArray arrayWithArray:items];
}

- (void)deleteMediaMetadatasWithIdentifier:(NSString *)identifier
{
    RTSMediaMetadata *object = [RTSMediaMetadata objectInRealm:self.realm forPrimaryKey:identifier];
    if (!object) {
        return;
    }
    
    if (object.isDownloading) {
        NSURL *downloadURL = [NSURL URLWithString:[object downloadURLString]];

        [self.downloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
            
            __block NSURLSessionDownloadTask *currentTask = nil;
            [downloadTasks enumerateObjectsUsingBlock:^(NSURLSessionDownloadTask *task, NSUInteger idx, BOOL *stop) {
                if ([task.originalRequest.URL isEqual:downloadURL]) {
                    currentTask = task;
                    *stop = YES;
                }
            }];
            
            if (currentTask) {
                [currentTask cancel];
            }
        }];
    }
    else if (object.isDownloaded) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:object.localURLString error:&error];
    }

    [self.realm beginWriteTransaction];
    [self.realm deleteObject:object];
    [self.realm commitWriteTransaction];
}

- (void)deleteShowMetadatasWithIdentifier:(NSString *)identifier
{
    RTSShowMetadata *object = [RTSShowMetadata objectInRealm:self.realm forPrimaryKey:identifier];
    if (object) {
        [self.realm beginWriteTransaction];
        [self.realm deleteObject:object];
        [self.realm commitWriteTransaction];
    }
}

#pragma mark - Downloads

- (void)markForDownload:(BOOL)download mediaMetadata:(id<SRGMediaMetadataContainer>)mediaMetadata
{
    if (!mediaMetadata.isDownloadable || !mediaMetadata.downloadURLString || [mediaMetadata.downloadURLString length] == 0) {
        // Handle error case.
        return;
    }
    
    [self.downloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        RLMRealm *realm = [RLMRealm realmWithPath:[SRGOfflineStorageCenter realmPathForStorageKey:SRGOfflineStorageCenterFavoritesStorageKey]];
        RTSMediaMetadata *storedMediaMetadata = [RTSMediaMetadata objectInRealm:realm forPrimaryKey:mediaMetadata.identifier];
        NSURL *downloadURL = [NSURL URLWithString:[storedMediaMetadata downloadURLString]];
        
        NSArray *fileteredDownloadTasks = [downloadTasks filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask *)evaluatedObject;
            return [task.originalRequest.URL isEqual:downloadURL];
        }]];
        
        NSURLSessionDownloadTask *currentTask = fileteredDownloadTasks.firstObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(storageCenter:willStartDownloading:)]) {
                [self.delegate storageCenter:self willStartDownloading:mediaMetadata.identifier];
            }
        });
        
        if (!currentTask && download) {
            currentTask = [self.downloadSession downloadTaskWithURL:downloadURL];
            [currentTask resume];
        }
        else if (currentTask && download) {
            [currentTask resume];
        }
        else if (currentTask && !download) {
            [currentTask suspend];
        }

        [realm beginWriteTransaction];
        storedMediaMetadata.isDownloading = download;
        [realm commitWriteTransaction];
    }];
}

- (NSArray *)flaggedAsDownloadedMediaMetadatas;
{
    RLMResults *results = [[RTSMediaMetadata objectsInRealm:self.realm where:@"isDownloaded = YES"] sortedResultsUsingProperty:@"title" ascending:NO];
    NSMutableArray *items = [NSMutableArray array];
    for (id<SRGMediaMetadataContainer>container in results) {
        [items addObject:container];
    }
    return [NSArray arrayWithArray:items];
}

- (NSArray *)flaggedAsDownloadingMediaMetadatas;
{
    RLMResults *results = [[RTSMediaMetadata objectsInRealm:self.realm where:@"isDownloading = YES"] sortedResultsUsingProperty:@"title" ascending:NO];
    NSMutableArray *items = [NSMutableArray array];
    for (id<SRGMediaMetadataContainer>container in results) {
        [items addObject:container];
    }
    return [NSArray arrayWithArray:items];
}

- (NSArray *)flaggedAsDownloadingOrDownloadedMediaMetadatas;
{
    RLMResults *results = [[RTSMediaMetadata objectsInRealm:self.realm where:@"isDownloading = YES OR isDownloaded = YES"] sortedResultsUsingProperty:@"title" ascending:NO];
    NSMutableArray *items = [NSMutableArray array];
    for (id<SRGMediaMetadataContainer>container in results) {
        [items addObject:container];
    }
    return [NSArray arrayWithArray:items];
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    RLMRealm *realm = [RLMRealm realmWithPath:[SRGOfflineStorageCenter realmPathForStorageKey:SRGOfflineStorageCenterFavoritesStorageKey]];
    
    RLMResults *results = [RTSMediaMetadata objectsInRealm:realm where:@"downloadURLString == %@",
                           downloadTask.originalRequest.URL.absoluteString];

    if ([results count] == 1) {
        RTSMediaMetadata *storedMediaData = results[0];
        NSString *identifier = storedMediaData.identifier.copy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(storageCenter:isDownloading:progress:total:)]) {
                float progress = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
                [self.delegate storageCenter:self isDownloading:identifier progress:progress total:totalBytesExpectedToWrite];
            }
        });
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    RLMRealm *realm = [RLMRealm realmWithPath:[SRGOfflineStorageCenter realmPathForStorageKey:SRGOfflineStorageCenterFavoritesStorageKey]];

    RLMResults *results = [RTSMediaMetadata objectsInRealm:realm where:@"downloadURLString == %@",
                           downloadTask.originalRequest.URL.absoluteString];
    
    if ([results count] == 1) {
        [realm beginWriteTransaction];
        RTSMediaMetadata *container = results[0];
        NSString *identifier = container.identifier.copy;
        
        container.isDownloading = NO;
        container.isDownloaded = YES;
        
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
        NSString *lastPathComponent = [downloadTask.originalRequest.URL lastPathComponent];
        NSString *localURLString = [[libraryPath stringByAppendingPathComponent:@"Downloads"] stringByAppendingPathComponent:lastPathComponent];
        
        NSError *error = nil;
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL URLWithString:localURLString] error:&error];
        container.localURLString = localURLString;
        
        [realm commitWriteTransaction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(storageCenter:finishedDownloading:withLocalURLString:)]) {
                [self.delegate storageCenter:self finishedDownloading:identifier withLocalURLString:localURLString];
            }
        });
    }
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
}

@end
