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

static RTSOfflineStorageCenter *favoritesCenter = nil;
static NSString * const RTSOfflineStorageCenterFavoritesStorageKey = @"RTSOfflineStorageCenterFavoritesStorage";

@interface RTSOfflineStorageCenter ()
@property(nonatomic, strong) RLMRealm *realm;
@end

@implementation RTSOfflineStorageCenter

+ (RTSOfflineStorageCenter *)favoritesSharedCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        favoritesCenter = [[RTSOfflineStorageCenter alloc] init_RTSOfflineStorageCenter_withStorageKey:RTSOfflineStorageCenterFavoritesStorageKey];
    });
    return favoritesCenter;
}

- (instancetype)init_RTSOfflineStorageCenter_withStorageKey:(NSString *)storageKey
{
    self = [super init];
    if (self) {
        NSString *libraryPath = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *realmPath = [[libraryPath stringByAppendingPathComponent:storageKey] stringByAppendingPathExtension:@"realm"];
        self.realm = [RLMRealm realmWithPath:realmPath];
    }
    return self;
}

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

- (NSSet *)storedMediaMetadataIdentifiers
{
    NSAssert([RTSMediaMetadata instancesRespondToSelector:@selector(identifier)], @"Something wrong here.");
    RLMResults *results = [RTSMediaMetadata allObjectsInRealm:self.realm];
    return [results valueForKey:@"identifier"];
}

- (NSArray *)storedMediaMetadatas
{
    NSMutableArray *mds = [NSMutableArray array];
    RLMResults *results = [RTSMediaMetadata allObjectsInRealm:self.realm];
    for (RTSMediaMetadata *md in results) {
        [mds addObject:md];
    }
    return [NSArray arrayWithArray:mds];
}

@end
