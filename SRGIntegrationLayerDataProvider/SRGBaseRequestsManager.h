//
// Created by Sebastien Chauvin on 26/11/14.
//

#import <Foundation/Foundation.h>

@class SRGILList;
@class AFHTTPClient;
@class AFHTTPRequestOperation;

@interface SRGBaseRequestsManager : NSObject

@property (nonatomic, strong) AFHTTPClient *httpClient;
@property (nonatomic, strong) NSMutableDictionary *ongoingVideoListRequests;
@property (nonatomic, strong) NSMutableDictionary *ongoingVideoListDownloads;
@property (nonatomic, strong) NSMutableDictionary *ongoingAssetRequests;

/**
 *  Designated initializer.
 *
 *  @param baseURL The base URL for request.
 *
 *  @return An instance of the SRGRequestManager;
 */
- (id)initWithBaseURL:(NSURL *)baseURL;

/**
 *  The base URL of the request manager.
 *
 *  @return A new URL instance containing the base URL of the manager.
 */
- (NSURL *)baseURL;

/**
 *  The categories indexes for which a request for video list is currently underway;
 *
 *  @return A new index set containing the categories for which a request is ongoing.
 */
- (NSArray *)ongoingRequestPaths;

- (AFHTTPRequestOperation *)requestOperationWithPath:(NSString *)path completion:(void (^)(id JSON, NSError *error))completion;

/**
 *  Request the IL for a video list with a given URL path.
 *
 *  @return A boolean indicating wether the request is being started or not.
 */
//- (BOOL)requestItemsWithURLPath:(NSString *)path
//                         forTag:(id<NSCopying>)tag
//               organisationType:(SRGModelDataOrganisationType)orgType
//                     onProgress:(void (^)(float))downloadBlock
//                   onCompletion:(void (^)(id<NSCopying>, SRGILList *, Class, NSError *))completionBlock;

/**
 *  Cancel all ongoing requests managed by the receiver.
 */
- (void)cancelAllRequests;

/**
 *  The request manager store dates associated with keys, to allow for the pullt-to-refresh label to display
 *  meaningful information.
 *
 *  @param key The key associated with the date. Usually is equal to the sectionTag of the data.
 *
 *  @return The date for the given key, or nil of no date is available.
 */
//+ (NSDate *)downloadDateForKey:(NSString *)key;

/**
 *  Update the date associated with the given key. It takes the system date at the time of call of this method.
 *
 *  @param key A key to attach to the date.
 */
//+ (void)refreshDownloadDateForKey:(NSString *)key;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Whether the network connection at the time of calling is using the WIFI or not.
 */
+ (BOOL)isUsingWIFI;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Returns the SSID string of the current WIFI, if 'isUsingWIFI' returns 'YES'.
 *  Returns nil otherwise.
 */
+ (NSString *)WIFISSID;

/**
 *  As a central network-based request, the request manager also provide some utilities.
 *
 *  @return Whether the network connection at the time of calling is using a Swisscom WIFI.
 *  Returns 'NO' if the method 'isUsingWIFI' returns 'NO', obviously.
 */
+ (BOOL)isUsingSwisscomWIFI;

@end