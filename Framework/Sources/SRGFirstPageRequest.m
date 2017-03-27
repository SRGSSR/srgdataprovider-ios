//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGFirstPageRequest.h"

#import "SRGFirstPageRequest+Private.h"
#import "SRGPage+Private.h"
#import "SRGPageRequest+Private.h"
#import "SRGRequest+Private.h"

@interface SRGFirstPageRequest ()

@property (nonatomic) SRGPage *page;
@property (nonatomic, copy) SRGPageCompletionBlock pageCompletionBlock;

@end

@implementation SRGFirstPageRequest

#pragma mark Class methods

+ (SRGPage *)nextPageAfterPage:(SRGPage *)page fromJSONDictionary:(NSDictionary *)JSONDictionary
{
    id next = JSONDictionary[@"next"];
    
    // Ensure the next field is a string. In now and next requests, we have a next dictionary entry, which
    // does not correspond to next page information, but to next program information
    return [next isKindOfClass:[NSString class]] ? [page nextPageWithURL:[NSURL URLWithString:next]] : nil;
}

#pragma mark Object lifecycle

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session pageCompletionBlock:(SRGPageCompletionBlock)pageCompletionBlock
{
    SRGPage *page = [SRGPage firstPageWithDefaultSize];
    
    SRGRequestCompletionBlock requestCompletionBlock = ^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        SRGPage *nextPage = [SRGFirstPageRequest nextPageAfterPage:page fromJSONDictionary:JSONDictionary];
        pageCompletionBlock(JSONDictionary, page, nextPage, error);
    };
    
    if (self = [super initWithRequest:request session:session completionBlock:requestCompletionBlock]) {
        self.page = page ?: [SRGPage firstPageWithDefaultSize];
        self.pageCompletionBlock = pageCompletionBlock;
    }
    return self;
}

#pragma mark Page management

- (__kindof SRGRequest *)requestAtPage:(SRGPage *)page withClass:(Class)cls
{
    NSURLRequest *request = [SRGPage request:self.request withPage:page];
    SRGFirstPageRequest *pageRequest = [[cls alloc] initWithRequest:request session:self.session completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        SRGPage *nextPage = [SRGFirstPageRequest nextPageAfterPage:page fromJSONDictionary:JSONDictionary];
        self.pageCompletionBlock(JSONDictionary, page, nextPage, error);
    }];
    pageRequest.page = page;
    pageRequest.pageCompletionBlock = self.pageCompletionBlock;
    return pageRequest;
}

- (SRGFirstPageRequest *)withPageSize:(NSInteger)pageSize
{
    SRGPage *page = [SRGPage firstPageWithSize:pageSize];
    return [self requestAtPage:page withClass:[SRGFirstPageRequest class]];
}

- (SRGPageRequest *)atPage:(SRGPage *)page
{
    if (! page) {
        page = self.page.firstPage;
    }
    
    return [self requestAtPage:page withClass:[SRGPageRequest class]];
}

@end
