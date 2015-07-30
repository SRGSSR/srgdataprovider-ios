//
//  SRGILBaseMetadata.h
//  Pods
//
//  Created by Cédric Foellmi on 06/05/15.
//
//

#import <Foundation/Foundation.h>
#import <SRGOfflineStorage/SRGOfflineStorage.h>

@interface SRGILBaseMetadata : NSObject <SRGBaseMetadataContainer>

@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *imageURLString;

@property(nonatomic, strong) NSDate *expirationDate;
@property(nonatomic, strong) NSDate *favoriteChangeDate;

@property(nonatomic, assign) BOOL isFavorite;

@property(nonatomic, strong) NSString *audioChannelID;

+ (instancetype)metadataForContainer:(id<SRGBaseMetadataContainer>)container;
- (instancetype)initWithContainer:(id<SRGBaseMetadataContainer>)container;

@end
