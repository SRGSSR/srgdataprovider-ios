//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import "SRGPageRequest.h"

#import "SRGPage+Private.h"
#import "SRGPageRequest+Private.h"
#import "SRGRequest+Private.h"

@interface SRGPageRequest ()

@property (nonatomic) SRGPage *page;
@property (nonatomic, copy) SRGPageRequestCompletionBlock pageRequestCompletionBlock;

@end

@implementation SRGPageRequest

#pragma mark Class methods

+ (SRGPage *)nextPageAfterPage:(SRGPage *)page fromJSONDictionary:(NSDictionary *)JSONDictionary
{
    id next = JSONDictionary[@"next"];
    
    // Ensure the next field is a string. In now and next requests, we have a next dictionary entry, which
    // does not correspond to next page information, but to next program information
    return [next isKindOfClass:[NSString class]] ? [page nextPageWithURL:[NSURL URLWithString:next]] : nil;
}

#pragma mark Object lifecycle

- (instancetype)initWithRequest:(NSURLRequest *)request page:(SRGPage *)page session:(NSURLSession *)session completionBlock:(SRGPageRequestCompletionBlock)completionBlock
{
    SRGRequestCompletionBlock requestCompletionBlock = ^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        SRGPage *nextPage = [SRGPageRequest nextPageAfterPage:page fromJSONDictionary:JSONDictionary];
        completionBlock(JSONDictionary, page, nextPage, error);
    };
    
    if (self = [super initWithRequest:request session:session completionBlock:requestCompletionBlock]) {
        self.page = page ?: [SRGPage firstPageWithDefaultSize];
        self.pageRequestCompletionBlock = completionBlock;
    }
    return self;
}

#pragma mark Page management

- (SRGRequest *)withPageSize:(NSInteger)pageSize
{
    // PageSize is only supported on the request to the first page.
    // http://www.srfcdn.ch/developer-docs/integrationlayer/api/public/v2/pagination.html
    NSCAssert(self.page.number == 0, @"`-withPageSize:` can only on be called on the request for the first page");
    SRGPage *page = [SRGPage firstPageWithSize:pageSize];
    return [self atPage:page];
}

- (SRGRequest *)atPage:(SRGPage *)page
{
    if (! page) {
        page = self.page.firstPage;
    }
    
    NSURLRequest *request = [SRGPage request:self.request withPage:page];
    SRGPageRequest *pageRequest = [[[self class] alloc] initWithRequest:request session:self.session completionBlock:^(NSDictionary * _Nullable JSONDictionary, NSError * _Nullable error) {
        SRGPage *nextPage = [SRGPageRequest nextPageAfterPage:page fromJSONDictionary:JSONDictionary];
        self.pageRequestCompletionBlock(JSONDictionary, page, nextPage, error);
    }];
    pageRequest.page = page;
    pageRequest.pageRequestCompletionBlock = self.pageRequestCompletionBlock;
    return pageRequest;
}

@end
