//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

OBJC_EXPORT NSURLRequest *SRGDataProviderRequestWithError(NSError *error);

@interface NSURLSession (SRGIntegrationLayerDataProvider)

- (NSURLSessionTask *)srg_taskForError:(NSError *)error withCompletionHandler:(void (^)(NSError *error))completionHandler;

@end
