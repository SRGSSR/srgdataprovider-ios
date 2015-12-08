//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGIntegrationLayerDataProvider/SRGIntegrationLayerDataProvider.h>
#import "SearchViewController.h"
#import "AppDelegate.h"


@interface SearchViewController ()

@property(nonatomic,weak) SRGILDataProvider *dataProvider;
@property(nonatomic,strong) SRGILList *resultItems;

@end

@implementation SearchViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.dataProvider = appDelegate.dataProvider;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _searchBar.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // DO the stuff...
    
    SRGILURLComponents *components = [self.dataProvider URLComponentsForFetchListIndex:SRGILFetchListVideoSearch
                                                                        withIdentifier:nil
                                                                                 error:nil];
    
    [components updateQueryItemsWithSearchString:searchBar.text];
    
    [self.dataProvider fetchObjectsListWithURLComponents:components
                                             organised:SRGILModelDataOrganisationTypeFlat
                                            progressBlock:nil
                                          completionBlock:^(SRGILList *items, __unsafe_unretained Class itemClass, NSError *error) {
                                              self.resultItems = items;
                                              NSLog(@"Result: %@", items);
                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                  [self.tableview reloadData];
                                              }];
                                          }];
    
    [searchBar resignFirstResponder];
}


#pragma mark - UITableViewdataProvider

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultItems ? [self.resultItems count] : 0;
}


#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const identifier = @"resultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    SRGILSearchResult *item = self.resultItems[indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.resultDescription;
    
    
    return cell;
}



@end
