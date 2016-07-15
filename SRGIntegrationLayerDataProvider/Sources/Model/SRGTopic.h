//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface SRGTopic : JSONModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;

@end
