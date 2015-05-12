//
//  SRGILBaseMetadata.h
//  Pods
//
//  Created by Cédric Foellmi on 06/05/15.
//
//

#import <Foundation/Foundation.h>
#import <RTSOfflineMediaStorage/RTSOfflineMediaStorage.h>

@interface SRGILBaseMetadata : NSObject <RTSBaseMetadataContainer>

@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *imageURLString;

@property(nonatomic, strong) NSDate *expirationDate;
@property(nonatomic, strong) NSDate *favoriteChangeDate;

@property(nonatomic, assign) BOOL isFavorite;

@property(nonatomic, strong) NSString *audioChannelID;

+ (instancetype)metadataForContainer:(id<RTSBaseMetadataContainer>)container;
- (instancetype)initWithContainer:(id<RTSBaseMetadataContainer>)container;

@end
