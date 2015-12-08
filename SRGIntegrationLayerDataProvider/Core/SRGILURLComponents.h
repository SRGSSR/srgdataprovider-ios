//
//  SRGILFetchPath.h
//  SRGIntegrationLayerDataProvider
//  Copyright © 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILDataProviderConstants.h"

// Note: overriding host and scheme has no effect.

@interface SRGILURLComponents : NSURLComponents

@property(nonatomic, assign, readonly) SRGILFetchListIndex index;
@property(nonatomic, copy, readonly, nullable) NSString *identifier;

+ (nullable SRGILURLComponents *)componentsForFetchListIndex:(SRGILFetchListIndex)index
                                              withIdentifier:(nullable NSString *)identifier
                                                       error:(NSError * __nullable __autoreleasing * __nullable)error;

// Convenient methods to update the query
- (void)updateQueryItemsWithSearchString:(nonnull NSString *)newQueryString;
- (void)updateQueryItemsWithPageSize:(nonnull NSString *)newPageSize;
- (void)updateQueryItemsWithDate:(nonnull NSDate *)newDate;

/// Returns NO in case the end is reached, and the pageNumber is not increased.
- (BOOL)canIncrementPageNumberBoundedByTotal:(NSInteger)totalItemsCount;
- (BOOL)incrementPageNumberBoundedByTotal:(NSInteger)totalItemsCount;

@end
