//
//  Playlists.m
//  SoundLounge
//
//  Created by Apple on 01/05/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "Playlists.h"

@interface Playlists ()<UISearchDisplayDelegate>

@end

@implementation Playlists

- (void)viewDidLoad {
    [super viewDidLoad];
    _albumDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    _albumDetailTableView.tableHeaderView = searchBar;
    _albumDetailTableView.contentOffset = CGPointMake(0, CGRectGetHeight(searchBar.frame));

    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{

    [self.albumDetailTableView setContentOffset:CGPointMake(0,44) animated:NO];
    [self.searchDisplayController setActive:NO animated:NO];//or (0, 88) depends on the height of it
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
-(UITableViewCell * ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"AlbumDetail"];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlbumDetail"];
        
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
