//
//  SRGTokenHandler.h
//  SRFPlayer
//
//  Created by Frédéric VERGEZ on 07/03/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SRGILTokenRequestCompletionBlock) (NSURL *tokenizedURL, NSError *error);

@interface SRGILTokenHandler : NSObject

+ (instancetype)sharedHandler;

/**
 * Perform an async operation to return a tokenized URL
 */
- (void)requestTokenForURL:(NSURL *)url
 appendLogicalSegmentation:(NSString *)segmentation
           completionBlock:(SRGILTokenRequestCompletionBlock)completionBlock;

@end
