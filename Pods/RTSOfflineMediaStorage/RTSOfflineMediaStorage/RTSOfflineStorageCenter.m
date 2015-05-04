//
//  RTSOfflineStorageCenter.m
//  RTSOfflineMediaStorage
//
//  Created by Cédric Foellmi on 21/04/15.
//  Copyright (c) 2015 RTS. All rights reserved.
//

#import <Realm/Realm.h>
#import "RTSOfflineStorageCenter.h"
#import "RTSMediaMetadata.h"

static NSString * const RTSOfflineStorageCenterFavoritesStorageKey = @"RTSOfflineStorageCenterFavoritesStorage";

@interface RTSOfflineStorageCenter ()
@property(nonatomic, strong) id<RTSMediaMetadatasProvider> metadatasProvider;
@property(nonatomic, strong) RLMRealm *realm;
@end

@implementation RTSOfflineStorageCenter

+ (RTSOfflineStorageCenter *)favoritesCenterWithMetadataProvider:(id <RTSMediaMetadatasProvider>)metadataProvider
{
    RTSOfflineStorageCenter *instance = [[RTSOfflineStorageCenter alloc] init_RTSOfflineStorageCenter_withStorageKey:RTSOfflineStorageCenterFavoritesStorageKey];
    instance.metadatasProvider = metadataProvider;
    return instance;
}

- (instancetype)init_RTSOfflineStorageCenter_withStorageKey:(NSString *)storageKey
{
    self = [super init];
    if (self) {
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
        NSString *realmPath = [libraryPath stringByAppendingPathComponent:[storageKey stringByAppendingPathExtension:@"realm"]];
        
        @try {
            self.realm = [RLMRealm realmWithPath:realmPath];
        }
        @catch(NSException *exception) {
            NSLog(@"Caught exception while opening Realm: %@", exception);
            
            if([exception.name isEqualToString:RLMExceptionName]) {
                NSFileManager* fileManager = [NSFileManager defaultManager];
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

- (RLMResults *)flaggedAsFavoriteMetadatas
{
    return [[RTSMediaMetadata objectsWhere:@"favorite = YES"] sortedResultsUsingProperty:@"favoriteChangeDate" ascending:YES];
}

- (void)flagAsFavorite:(BOOL)favorite mediaWithIdentifier:(NSString *)identifier
{
    RTSMediaMetadata *metadata = [RTSMediaMetadata objectInRealm:self.realm forPrimaryKey:identifier];
    [self.realm beginWriteTransaction];
    if (metadata == nil) {
        id<RTSMediaMetadataContainer> container = [self.metadatasProvider mediaMetadataContainerForIdentifier:identifier];
        metadata = [RTSMediaMetadata mediaMetadataForContainer:container];
        metadata.identifier = identifier;
        metadata.isFavorite = YES;
        metadata.favoriteChangeDate = [NSDate date];
        [self.realm addObject:metadata];
    }
    else {
        metadata.isFavorite = favorite;
        metadata.favoriteChangeDate = [NSDate date];
    }
    [self.realm commitWriteTransaction];
}


#pragma mark - Generic Storage

- (void)saveMediaMetadataWithIdentifier:(NSString *)identifier error:(NSError * __autoreleasing *)error
{
    if (!self.metadatasProvider) {
        @throw [NSException exceptionWithName:@"CustomDomain" reason:@"Missing metadatas provider." userInfo:nil];
    }
    
    id<RTSMediaMetadataContainer> container = [self.metadatasProvider mediaMetadataContainerForIdentifier:identifier];
    RTSMediaMetadata *md = [RTSMediaMetadata mediaMetadataForContainer:container];
    if (!md) {
        if (*error) {
            *error = [NSError errorWithDomain:@"CustomDomain" code:-9 userInfo:nil];
        }
        return;
    }
    
    [self.realm beginWriteTransaction];
    [self.realm addObject:md];
    [self.realm commitWriteTransaction];
}

- (void)deleteMediaMetadataWithIdentifier:(NSString *)identifier error:(NSError * __autoreleasing *)error
{
    if (!identifier) {
        return;
    }
    
    RTSMediaMetadata *md = [RTSMediaMetadata objectForPrimaryKey:@"identifier"];
    [self.realm beginWriteTransaction];
    [self.realm deleteObject:md];
    [self.realm commitWriteTransaction];
}

- (NSSet *)savedMediaMetadataIdentifiers
{
    NSAssert([RTSMediaMetadata instancesRespondToSelector:@selector(identifier)], @"Something wrong here.");
    RLMResults *results = [RTSMediaMetadata allObjectsInRealm:self.realm];
    return [results valueForKey:@"identifier"];
}

- (RLMResults *)savedMediaMetadatas
{
    return [RTSMediaMetadata allObjectsInRealm:self.realm];
}


@end
