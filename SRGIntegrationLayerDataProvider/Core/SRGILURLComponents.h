//
//  SRGILFetchPath.h
//  SRGIntegrationLayerDataProvider
//  Copyright © 2015 SRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRGILDataProviderConstants.h"

// Note: overriding host and scheme has no effect.

@interface SRGILURLComponents : NSObject <NSCopying>

/**
 *  Create the URL Components object objects of a specific 'index';
 *
 *  @param index      The fetch index
 *  @param identifier The identifier relevant for that fetch index (Optionnal).
 *  @param error      The reference to an error instance.
 *
 *  @return The URL Components for that index. Or nil in case of error. In which the error object contains the reason.
 */
+ (nullable SRGILURLComponents *)componentsForFetchListIndex:(SRGILFetchListIndex)index
                                              withIdentifier:(nullable NSString *)identifier
                                                       error:(NSError * __nullable __autoreleasing * __nullable)error;

@property (nullable, readonly, copy) NSURL *URL;
@property (nullable, readonly, copy) NSString *string;

@property (nullable, readonly, copy) NSArray<NSURLQueryItem *> *queryItems;

@property (nullable, copy) NSString *scheme;
@property (nullable, copy) NSString *host;
@property (nullable, copy) NSString *path;

@property(nonatomic, assign, readonly) SRGILFetchListIndex index;
@property(nonatomic, copy, readonly, nullable) NSString *identifier;
@property(nonatomic, copy, null_resettable) NSString *serviceVersion;          // defaults to 1.0

// Convenient methods to update the query
- (void)updateQueryItemsWithSearchString:(nonnull NSString *)newQueryString;
- (void)updateQueryItemsWithPageSize:(nonnull NSString *)newPageSize;
- (void)updateQueryItemsWithDate:(nonnull NSDate *)newDate;

/// Returns NO in case the end is reached, and the pageNumber is not increased.
- (BOOL)canIncrementPageNumberBoundedByTotal:(NSInteger)totalItemsCount;
- (BOOL)incrementPageNumberBoundedByTotal:(NSInteger)totalItemsCount;

@end
