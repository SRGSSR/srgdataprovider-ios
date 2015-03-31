//
//  SRGTokenHandler.h
//  SRFPlayer
//
//  Created by Frédéric VERGEZ on 07/03/14.
//  Copyright (c) 2014 SRG SSR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SRGTokenRequestCompletionBlock) (NSURL *tokenizedURL, NSError *error);

@interface SRGTokenHandler : NSObject

+ (instancetype)sharedHandler;

/**
 * Perform an async operation to return a tokenized URL
 * To check the validity of the 'tokenized' URL, use: canReadURL:
 */
- (void)requestTokenForURL:(NSURL *)url
 appendLogicalSegmentation:(NSString *)segmentation
           completionBlock:(SRGTokenRequestCompletionBlock)completionBlock;

@end
