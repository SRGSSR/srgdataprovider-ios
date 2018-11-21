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

+ (SRGPage *)nextPageAfterPage:(SRGPage *)page withJSONDictionary:(NSDictionary *)JSONDictionary
{
    // Ensure the next field is a string. In now and next requests, we namely have a next dictionary entry, which
    // does not correspond to next page information, but to next program information
    id next = JSONDictionary[@"next"];
    NSURL *nextURL = [next isKindOfClass:NSString.class] ? [NSURL URLWithString:next] : nil;
    return [page nextPageWithURL:nextURL];
}

#pragma mark Object lifecycle

- (instancetype)initWithURLRequest:(NSURLRequest *)URLRequest session:(NSURLSession *)session pageCompletionBlock:(SRGPageCompletionBlock)pageCompletionBlock
{
    SRGPage *page = [SRGPage firstPageForOriginalURLRequest:URLRequest withSize:SRGPageDefaultSize];
    
    SRGRequestCompletionBlock completionBlock = ^(NSDictionary * _Nullable JSONDictionary, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        SRGPage *nextPage = [SRGFirstPageRequest nextPageAfterPage:page withJSONDictionary:JSONDictionary];
        pageCompletionBlock(JSONDictionary, JSONDictionary[@"total"], page, nextPage, HTTPResponse, error);
    };
    
    if (self = [super initWithURLRequest:page.URLRequest session:session completionBlock:completionBlock]) {
        self.page = page;
        self.pageCompletionBlock = pageCompletionBlock;
    }
    return self;
}

#pragma mark Page management

- (__kindof SRGPageRequest *)requestWithPage:(SRGPage *)page withClass:(Class)cls
{
    SRGPageRequest *request = [[cls alloc] initWithURLRequest:page.URLRequest session:self.session completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSHTTPURLResponse * _Nullable HTTPResponse, NSError * _Nullable error) {
        SRGPage *nextPage = [SRGFirstPageRequest nextPageAfterPage:page withJSONDictionary:JSONDictionary];
        self.pageCompletionBlock(JSONDictionary, JSONDictionary[@"total"],  page, nextPage, HTTPResponse, error);
    }];
    request.page = page;
    request.pageCompletionBlock = self.pageCompletionBlock;
    return request;
}

- (SRGFirstPageRequest *)requestWithPageSize:(NSUInteger)pageSize
{
    SRGPage *page = [self.page firstPageWithSize:pageSize];
    return [self requestWithPage:page withClass:SRGFirstPageRequest.class];
}

- (SRGPageRequest *)requestWithPage:(SRGPage *)page
{
    if (! page) {
        page = self.page.firstPage;
    }
    return [self requestWithPage:page withClass:SRGPageRequest.class];
}

@end
