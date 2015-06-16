//
//  SRGOfflineStorageCenter.m
//  RTSOfflineMediaStorage
//
//  Created by Cédric Foellmi on 21/04/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Realm/Realm.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

#import "RTSOfflineStorageCenter.h"
#import "RTSMediaMetadata.h"
#import "RTSShowMetadata.h"

#define REALM_NONNULL_STRING(value) ((value == nil) ? @"" : (value))

static NSString * const SRGOfflineStorageCenterFavoritesStorageKey = @"SRGOfflineStorageCenterFavoritesStorage";

@interface RTSOfflineStorageCenter ()
@property(nonatomic, strong) id<RTSMetadatasProvider> metadatasProvider;
@property(nonatomic, strong) RLMRealm *realm;
@end

@implementation RTSOfflineStorageCenter

+ (RTSOfflineStorageCenter *)favoritesCenterWithMetadataProvider:(id<RTSMetadatasProvider>)metadataProvider
{
    RTSOfflineStorageCenter *instance = [[RTSOfflineStorageCenter alloc] init_SRGOfflineStorageCenter_withStorageKey:SRGOfflineStorageCenterFavoritesStorageKey];
    instance.metadatasProvider = metadataProvider;
    return instance;
}

- (instancetype)init_SRGOfflineStorageCenter_withStorageKey:(NSString *)storageKey
{
    self = [super init];
    if (self) {
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
        NSString *realmPath = [libraryPath stringByAppendingPathComponent:[storageKey stringByAppendingPathExtension:@"realm"]];
        
        NSError *error;
        NSUInteger currentSchemaVersion = [RLMRealm schemaVersionAtPath:realmPath error:&error];
        if (error) {
            DDLogWarn(@"Error getting schema version for realm at path %@", realmPath);
            DDLogWarn(@"%@", error);
        }
        
        // Avoid running the setSchemaVersion:... on realm that have already migrated (for having been opened already
        // for instance, like in unit tests).
        NSUInteger newSchemaVersion = 1;
        if (!error && currentSchemaVersion < newSchemaVersion) {
            [RLMRealm setSchemaVersion:newSchemaVersion
                        forRealmAtPath:realmPath
                    withMigrationBlock:^(RLMMigration *migration, NSUInteger oldSchemaVersion) {                    
                        [migration enumerateObjects:RTSShowMetadata.className
                                              block:^(RLMObject *oldObject, RLMObject *newObject) {
                                                  if (oldSchemaVersion < 1) {
                                                      newObject[@"showDescription"] = @"";
                                                  }
                                              }];
                    }];
        }
        
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
    return self;
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
    RTSBaseMetadata *metadata = [objectClass objectInRealm:self.realm forPrimaryKey:identifier];
    [self.realm beginWriteTransaction];
    if (metadata != nil && metadata.title.length == 0) {
        [self.realm deleteObject:metadata];
        metadata = nil;
    }
    if (metadata == nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id<RTSBaseMetadataContainer> container = [self.metadatasProvider performSelector:selector withObject:identifier];
#pragma clang diagnostic pop
        if (container == nil) {
            DDLogWarn(@"No container for identifier: %@", identifier);
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

- (id<RTSMediaMetadataContainer>)mediaMetadataForIdentifier:(NSString *)identifier
{
    if (identifier) {
        return [RTSMediaMetadata objectInRealm:self.realm forPrimaryKey:identifier];
    }
    else {
        return nil;
    }
}

- (id<RTSShowMetadataContainer>)showMetadataForIdentifier:(NSString *)identifier
{
    if (identifier) {
        return [RTSShowMetadata objectInRealm:self.realm forPrimaryKey:identifier];
    }
    else {
        return nil;
    }
}

- (RLMResults *)allSavedMediaMetadatas
{
    return [RTSMediaMetadata allObjectsInRealm:self.realm];
}

- (RLMResults *)allSavedShowMetadatas
{
    return [RTSShowMetadata allObjectsInRealm:self.realm];
}

@end
