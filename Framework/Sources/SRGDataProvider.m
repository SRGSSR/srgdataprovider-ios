//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider.h"

#import <Mantle/Mantle.h>

NSString * const SRGBusinessIdentifierRSI = @"rsi";
NSString * const SRGBusinessIdentifierRTR = @"rtr";
NSString * const SRGBusinessIdentifierRTS = @"rts";
NSString * const SRGBusinessIdentifierSRF = @"srf";
NSString * const SRGBusinessIdentifierSWI = @"swi";

static SRGDataProvider *s_currentDataProvider;

@interface SRGDataProvider ()

@property (nonatomic) NSURL *serviceURL;
@property (nonatomic, copy) NSString *businessUnitIdentifier;

@end

@implementation SRGDataProvider

#pragma mark Class methods

+ (SRGDataProvider *)currentDataProvider
{
    return s_currentDataProvider;
}

+ (SRGDataProvider *)setCurrentDataProvider:(SRGDataProvider *)currentDataProvider
{
    SRGDataProvider *previousDataProvider = s_currentDataProvider;
    s_currentDataProvider = currentDataProvider;
    return previousDataProvider;
}

#pragma mark Object lifecycle

// TODO: Improve: Service URL must be a proper base URL, ending with a slash if needed
// See http://stackoverflow.com/questions/16582350/nsurl-urlwithstringrelativetourl-is-clipping-relative-url

- (instancetype)initWithServiceURL:(NSURL *)serviceURL businessUnitIdentifier:(NSString *)businessUnitIdentifier
{
    if (self = [super init]) {
        self.serviceURL = serviceURL;
        self.businessUnitIdentifier = businessUnitIdentifier;
    }
    return self;
}

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark Requests

- (NSURLSessionTask *)listTopicsWithCompletionBlock:(void (^)(NSArray<SRGTopic *> * _Nullable, NSError * _Nullable))completionBlock
{
    NSURL *URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"2.0/%@/topicList/tv.json", self.businessUnitIdentifier] relativeToURL:self.serviceURL];
    return [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }
        
        // TODO: Implement common safe top-level parsing
        NSArray *JSONDictionaries = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"topicList"];
        
        NSMutableArray<SRGTopic *> *topics = [NSMutableArray array];
        for (NSDictionary *JSONDictionary in JSONDictionaries) {
            SRGTopic *topic = [MTLJSONAdapter modelOfClass:[SRGTopic class] fromJSONDictionary:JSONDictionary error:NULL];
            [topics addObject:topic];
        }
        
        completionBlock([topics copy], nil);
    }];
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; serviceURL: %@; businessUnitIdentifier: %@>",
            [self class],
            self,
            self.serviceURL,
            self.businessUnitIdentifier];
}

@end
