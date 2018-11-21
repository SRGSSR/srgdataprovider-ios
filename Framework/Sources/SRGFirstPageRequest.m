//
//  Copyright (c) SRG SSR. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGFirstPageRequest.h"

#import "SRGDataProviderLogger.h"
#import "SRGFirstPageRequest+Private.h"
#import "SRGPage+Private.h"
#import "SRGPageRequest+Private.h"
#import "SRGRequest+Private.h"

@interface SRGFirstPageRequest ()

@property (nonatomic, copy) SRGPageCompletionBlock pageCompletionBlock;

@end

@implementation SRGFirstPageRequest

#pragma mark Class methods

+ (SRGPage *)nextPageForURLRequest:(NSURLRequest *)request afterPage:(SRGPage *)page withJSONDictionary:(NSDictionary *)JSONDictionary
{
    // Ensure the next field is a string. In now and next requests, we namely have a next dictionary entry, which
    // does not correspond to next page information, but to next program information
    id next = JSONDictionary[@"next"];
    NSURL *nextURL = [next isKindOfClass:NSString.class] ? [NSURL URLWithString:next] : nil;
    return [page nextPageForRequest:request withNextURL:nextURL];
}

#pragma mark Object lifecycle

- (instancetype)initWithURLRequest:(NSURLRequest *)URLRequest session:(NSURLSession *)session pageCompletionBlock:(SRGPageCompletionBlock)pageCompletionBlock
{
    SRGPage *page = [SRGPage firstPageForRequest:URLRequest withSize:SRGPageDefaultSize];
    
    SRGRequestCompletionBlock completionBlock = ^(NSDictionary * _Nullable JSONDictionary, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        SRGPage *nextPage = [SRGFirstPageRequest nextPageForURLRequest:URLRequest afterPage:page withJSONDictionary:JSONDictionary];
        pageCompletionBlock(JSONDictionary, JSONDictionary[@"total"], page, nextPage, HTTPResponse, error);
    };
    
    NSURLRequest *pageURLRequest = [SRGPage request:URLRequest withPage:page];
    if (self = [super initWithURLRequest:pageURLRequest session:session completionBlock:completionBlock]) {
        self.page = page;
        self.pageCompletionBlock = pageCompletionBlock;
    }
    return self;
}

#pragma mark Page management

- (__kindof SRGPageRequest *)requestWithPage:(SRGPage *)page withClass:(Class)cls
{
    NSURLRequest *pageURLRequest = [SRGPage request:self.URLRequest withPage:page];
    SRGPageRequest *pageRequest = [[cls alloc] initWithURLRequest:pageURLRequest session:self.session completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        SRGPage *nextPage = [SRGFirstPageRequest nextPageForURLRequest:self.URLRequest afterPage:page withJSONDictionary:JSONDictionary];
        self.pageCompletionBlock(JSONDictionary, JSONDictionary[@"total"],  page, nextPage, HTTPResponse, error);
    }];
    pageRequest.page = page;
    pageRequest.pageCompletionBlock = self.pageCompletionBlock;
    return pageRequest;
}

- (SRGFirstPageRequest *)requestWithPageSize:(NSUInteger)pageSize
{
    SRGPage *page = [SRGPage firstPageForRequest:self.URLRequest withSize:pageSize];
    return [self requestWithPage:page withClass:SRGFirstPageRequest.class];
}

- (SRGPageRequest *)requestWithPage:(SRGPage *)page
{
    if (! page) {
        page = [SRGPage firstPageForRequest:self.URLRequest withSize:self.page.size];
    }
    
    return [self requestWithPage:page withClass:SRGPageRequest.class];
}

@end
