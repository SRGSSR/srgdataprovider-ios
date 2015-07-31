//
//  SearchViewController.m
//  SRGIntegrationLayerDataProvider Demo
//
//  Created by Frédéric VERGEZ on 30/07/15.
//  Copyright (c) 2015 SRG. All rights reserved.
//

#import "SearchViewController.h"
#import <SRGIntegrationLayerDataProvider/SRGILDataProviderMediaPlayerDataSource.h>


#import "AppDelegate.h"


@interface SearchViewController ()

@property(nonatomic,weak) SRGILDataProvider *dataSource;
@property(nonatomic,strong) SRGILList *resultItems;

@end

@implementation SearchViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.dataSource = appDelegate.dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchBar.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // DO the stuff...
    
    [self.dataSource fetchListOfIndex:SRGILFetchListVideoSearchResult
                     withPathArgument:searchBar.text
                            organised:SRGILModelDataOrganisationTypeFlat
                           onProgress:^(float fraction) {
                               // Nothing here on progression
                           }
                         onCompletion:^(SRGILList *items, __unsafe_unretained Class itemClass, NSError *error) {
                             // TODO...
                             self.resultItems = items;
                             NSLog(@"Result: %@", items);
                             
                             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                 [self.tableview reloadData];
                             }];
                         }];
    
    [searchBar resignFirstResponder];
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultItems ? [self.resultItems count] : 0;
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

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
