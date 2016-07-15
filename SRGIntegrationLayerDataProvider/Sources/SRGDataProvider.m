//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGDataProvider.h"

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
        
        // TODO: This is just a parsing / parser dependency test. Use better library and code for JSON mapping
        NSArray *objectDictionaries = [[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL] objectForKey:@"topicList"];
        
        NSMutableArray<SRGTopic *> *topics = [NSMutableArray array];
        for (NSDictionary *objectDictionary in objectDictionaries) {
            SRGTopic *topic = [[SRGTopic alloc] initWithDictionary:objectDictionary error:NULL];
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
