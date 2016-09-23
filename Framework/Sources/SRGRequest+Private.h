//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SRGRequestCompletionBlock)(NSDictionary * _Nullable JSONDictionary, SRGPage * _Nullable nextPage, NSError * _Nullable error);

@interface SRGRequest (Private)

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session completionBlock:(SRGRequestCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
