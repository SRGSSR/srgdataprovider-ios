//
//  AppDelegate.h
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Samuel Defago on 20.05.15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SRGIntegrationLayerDataProvider/SRGIntegrationLayerDataProvider.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SRGILDataProvider *dataSource;

@end

