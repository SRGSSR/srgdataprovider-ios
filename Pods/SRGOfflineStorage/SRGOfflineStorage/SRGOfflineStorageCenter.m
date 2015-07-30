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
static NSMutableDictionary *keyedCenters = nil;

@interface SRGOfflineStorageCenter ()
@property(nonatomic, weak) id<SRGMetadatasProvider> metadatasProvider;
@property(nonatomic, strong) RLMRealm *realm;
@property(nonatomic, strong) NSString *storageKey;
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

+ (SRGOfflineStorageCenter *)favoritesCenterWithMetadataProvider:(id<SRGMetadatasProvider>)metadataProvider
{
    SRGOfflineStorageCenter *instance = [keyedCenters objectForKey:SRGOfflineStorageCenterFavoritesStorageKey];
    if (!instance) {
        instance = [[SRGOfflineStorageCenter alloc] init_SRGOfflineStorageCenter_withStorageKey:SRGOfflineStorageCenterFavoritesStorageKey];
        keyedCenters[SRGOfflineStorageCenterFavoritesStorageKey] = instance;
    }
    instance.metadatasProvider = metadataProvider;
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
    [RLMRealm setSchemaVersion:1
                forRealmAtPath:realmPath
            withMigrationBlock:^(RLMMigration *migration, NSUInteger oldSchemaVersion) {
                [migration enumerateObjects:RTSShowMetadata.className
                                      block:^(RLMObject *oldObject, RLMObject *newObject) {
                                          if (oldSchemaVersion < 1) {
                                              newObject[@"showDescription"] = @"";
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
}

#pragma mark - Favorites - specific methods

- (RLMResults *)flaggedAsFavoriteMediaMetadatas
{
    return [[RTSMediaMetadata objectsInRealm:self.realm where:@"isFavorite = YES"] sortedResultsUsingProperty:@"favoriteChangeDate" ascending:NO];
}

- (RLMResults *)flaggedAsFavoriteShowMetadatas
{
    return [[RTSShowMetadata objectsInRealm:self.realm where:@"isFavorite = YES"] sortedResultsUsingProperty:@"favoriteChangeDate" ascending:NO];
}

- (void)flagAsFavorite:(BOOL)favorite mediaWithIdentifier:(NSString *)identifier audioChannelID:(NSString *)audioChannelID
{
    [self flagAsFavorite:favorite
             itemOfClass:[RTSMediaMetadata class]
          withIdentifier:identifier
          audioChannelID:audioChannelID
    withProviderSelector:@selector(mediaMetadataContainerForIdentifier:)];
}

- (void)flagAsFavorite:(BOOL)favorite showWithIdentifier:(NSString *)identifier audioChannelID:(NSString *)audioChannelID
{
    [self flagAsFavorite:favorite
             itemOfClass:[RTSShowMetadata class]
          withIdentifier:identifier
          audioChannelID:audioChannelID
    withProviderSelector:@selector(showMetadataContainerForIdentifier:)];
}

- (void)flagAsFavorite:(BOOL)favorite
           itemOfClass:(Class)objectClass
        withIdentifier:(NSString *)identifier
        audioChannelID:(NSString *)audioChannelID
  withProviderSelector:(SEL)selector
{
    if (!self.metadatasProvider) {
        @throw [NSException exceptionWithName:RTSOfflineStorageErrorDomain reason:@"Missing metadata provider" userInfo:nil];
    }
    if (!identifier) {
        @throw [NSException exceptionWithName:RTSOfflineStorageErrorDomain reason:@"Missing media|show identifier" userInfo:nil];
    }
    
    NSParameterAssert(objectClass);
    NSParameterAssert(selector);

    RTSBaseMetadata *metadata = [objectClass objectInRealm:self.realm forPrimaryKey:identifier];
    [self.realm beginWriteTransaction];
    if (metadata != nil && metadata.title.length == 0) {
        [self.realm deleteObject:metadata];
        metadata = nil;
    }
    if (metadata == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id<SRGBaseMetadataContainer> container = [self.metadatasProvider performSelector:selector withObject:identifier];
#pragma clang diagnostic pop
        if (container == nil) {
#ifdef DEBUG
            NSLog(@"No container for identifier: %@", identifier);
#endif
            metadata = [[objectClass alloc] init];
        }
        else {
            metadata = [objectClass metadataForContainer:container];
        }
        metadata.identifier = identifier;
        [self.realm addObject:metadata];
    }
    metadata.isFavorite = favorite;
    metadata.favoriteChangeDate = [NSDate date];
    metadata.audioChannelID = REALM_NONNULL_STRING(audioChannelID);

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

- (RLMResults *)allSavedMediaMetadatas
{
    return [RTSMediaMetadata allObjectsInRealm:self.realm];
}

- (RLMResults *)allSavedShowMetadatas
{
    return [RTSShowMetadata allObjectsInRealm:self.realm];
}

- (void)deleteMediaMetadatasWithIdentifier:(NSString *)identifier
{
    RTSMediaMetadata *object = [RTSMediaMetadata objectInRealm:self.realm forPrimaryKey:identifier];
    if (object) {
        [self.realm beginWriteTransaction];
        [self.realm deleteObject:object];
        [self.realm commitWriteTransaction];
    }
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

@end
