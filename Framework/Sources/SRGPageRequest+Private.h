//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPageRequest.h"

NS_ASSUME_NONNULL_BEGIN

// Block signatures
typedef void (^SRGPageCompletionBlock)(NSDictionary * _Nullable JSONDictionary, SRGPage *page, SRGPage * _Nullable nextPage, NSError * _Nullable error);

@interface SRGPageRequest (Private)

@property (nonatomic) SRGPage *page;
@property (nonatomic, copy) SRGPageCompletionBlock pageCompletionBlock;

@end

NS_ASSUME_NONNULL_END
