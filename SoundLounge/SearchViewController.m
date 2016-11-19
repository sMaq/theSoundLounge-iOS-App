//
//  SearchViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/17/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "SearchViewController.h"
#import "PlaylistCell.h"
#import "SongsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PlayerViewController.h"
#import "AlbumDetail.h"
#import "NewArtistViewController.h"
typedef enum {
    kLoadTypeArtist = 0,
    kLoadTypePlaylists = 1,
    kLoadTypeSongs = 2
} kLoadType;

@interface SearchViewController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    kLoadType searchType;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSArray * playlists;
@property NSArray * artists;
@property NSArray * songs;
@property NSArray * MainArrForCollectionView;
@end

@implementation SearchViewController

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SongsCell" bundle:nil] forCellReuseIdentifier:@"AlbumDetail"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    searchType = (int)self.segmentedControl.selectedSegmentIndex;
    
    self.playlists = @[];
    self.artists = @[];
    self.songs = @[];
    
}

-(void)loadDataFromServerWithKeyword:(NSString *)keyword {
    [self showProgressHUD];
    
    [WebAPI searchKeyword:keyword WithCompletionHandler:^(BOOL isError, NSArray *responseData) {
        if (responseData.count>0){
            
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                if ( [((NSDictionary *)responseData).allKeys containsObject:@"msg"] ){
                    [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    return;
                }
            }
            
            NSDictionary * data = (NSDictionary *)responseData;
            
            self.artists = (data[@"artists"] != [NSNull null]) ? data[@"artists"] : @[];
            self.playlists = (data[@"albums"]!= [NSNull null]) ? data[@"albums"] : @[];
            self.songs = (data[@"music"]!= [NSNull null]) ? data[@"music"] : @[];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadAllData];
                [self hideProgressHUB];
            });
            
        }
        
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }

    }];
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    searchType = (int)self.segmentedControl.selectedSegmentIndex;
    if (searchType == kLoadTypeSongs) {
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
       
    }
    else if (searchType == kLoadTypeArtist){
       // _MainArrForCollectionView=_artists;
        self.collectionView.hidden = NO;
        self.tableView.hidden = YES;
     
    }
    else {
        //_MainArrForCollectionView=_playlists;
        self.collectionView.hidden = NO;
        self.tableView.hidden = YES;
      
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadAllData];
        [self hideProgressHUB];
    });
  // [self reloadAllData];
}


-(void)reloadAllData {
    [self.collectionView reloadData];
    [self.tableView reloadData];

}


#pragma mark - Search Bar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    // return NO to not become first responder
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // called when text starts editing
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    // return NO to not resign first responder
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // called when text ends editing
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // called when text changes (including clear)
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // called before text changes
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (![searchBar.text isEqualToString:@""]) {
        [self loadDataFromServerWithKeyword:[searchBar text]];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    // called when cancel button pressed
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    // called when search results button pressed
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}



#pragma mark - Table View

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SongsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumDetail" forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[SongsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlbumDetail"];
        
    }
    NSLog(@"songs %@",_songs);
    cell.songTitle.text=[[_songs valueForKey:@"name"] objectAtIndex:indexPath.row];
    cell.songGenre.text=[[_songs valueForKey:@"username"] objectAtIndex:indexPath.row];
    cell.artistName.hidden=YES;
    cell.playButton.tag=indexPath.row;
    cell.clockButton.tag=indexPath.row;
    //cell.textLabel.text=[_songs valueForKey:@""
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // [self performSegueWithIdentifier:@"showPlayer1" sender:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.songs.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
#pragma mark - Collection View

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (searchType == kLoadTypeArtist) ? self.artists.count : self.playlists.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlaylistCell *cell = (PlaylistCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"Playlist" forIndexPath:indexPath];
if (searchType == kLoadTypeArtist)
{
    NSLog(@"%@ artists array",_artists);
    if ([_artists objectAtIndex:indexPath.row]!=nil) {
        NSString * dirName =[[_artists valueForKey:@"dir_name"] objectAtIndex:indexPath.row];
        NSArray * logos = nil;
        NSString * logo;
        id logoString = [[_artists valueForKey:@"logo"] objectAtIndex:indexPath.row];
        if (logoString != [NSNull null]) {
            logos = [NSJSONSerialization JSONObjectWithData:[logoString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        }
        
        else {
            logos = @[];
        }
        
        if (logos.count == 0) {
            logo=@"";
        }
        
        else {
            //                        NSString * logo = logos.count > 1 ? logos[1]: logos[0];
            logo =logos.count > 1 ? logos[1]: logos[0];
            
            
        }
        
        NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/photos/artist/%@/logo/%@",dirName,logo];
        NSLog(@"URL: %@",url);
        
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
        //    NSDictionary * temp = self.artists[indexPath.row];
        cell.titleLabel.text = [[_artists valueForKey:@"username"] objectAtIndex:indexPath.row];
    }
    
    
    }
    else
    {
        NSLog(@"%@ playlist array",_playlists);
        NSString * dirName =[[_playlists valueForKey:@"dir_name"] objectAtIndex:indexPath.row];
        NSString *albumname=[[_playlists valueForKey:@"name"] objectAtIndex:indexPath.row];
        
        NSArray * logos = nil;
        NSString * logo;
        id logoString = [[_playlists valueForKey:@"3"] objectAtIndex:indexPath.row];
        if (logoString != [NSNull null]) {
            logos = [NSJSONSerialization JSONObjectWithData:[logoString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        }
        
        else {
            logos = @[];
        }
        
        if (logos.count == 0) {
            logo=@"";
        }
        
        else {
            //                        NSString * logo = logos.count > 1 ? logos[1]: logos[0];
            logo =logos.count > 1 ? logos[1]: logos[0];
            
            
        }
        NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/logo/%@",dirName,albumname,logo];
        NSLog(@"URL: %@",url);
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
        //    NSDictionary * temp = self.artists[indexPath.row];
        cell.titleLabel.text = [[_playlists valueForKey:@"username"] objectAtIndex:indexPath.row];
        
    }
 
    //cell.subtitleLabel.text = self.artists[indexPath.row];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (searchType != kLoadTypeArtist){
        [self performSegueWithIdentifier:@"showAlbum1" sender:[self.collectionView cellForItemAtIndexPath:indexPath]];
    }
    else
    {
        _artistID=[[_artists objectAtIndex:indexPath.row] valueForKey:@"artist_id"];
        [self performSegueWithIdentifier:@"showArtist" sender:[self.collectionView cellForItemAtIndexPath:indexPath]];
    }
    
 
    
}
-(void)playButtonPressedWithTag:(int)tag {
    SongsCell * cell = (SongsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    [self performSegueWithIdentifier:@"showPlayer1" sender:cell.playButton];
}
-(void)clockButtonPressedWithTag:(int)tag
{
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showArtist"]) {
        
        NewArtistViewController * vc = segue.destinationViewController;
        vc.selectedArtistIdFrmTrendingView = _artistID.integerValue;
        vc.artist_idFOrAlbum=_artistID;
        vc.isFromSearchView=YES;
        //playerVC.isTrending = self.genreID != nil ? YES : NO;
        
    }
    else if ([segue.identifier isEqualToString:@"showPlayer1"]) {
        
        
        PlayerViewController * playerVC = (PlayerViewController*)segue.destinationViewController;
        
        NSInteger index = ((UIButton *)sender).tag;
        
        playerVC.currentSongData = self.songs[index];
        playerVC.allSongsArr=self.songs;
        playerVC.isSearchedSongs=YES;
        playerVC.indexForward=index;
        playerVC.coverImage = [UIImage imageNamed:[[self.songs valueForKey:@"album_logo"] objectAtIndex:index]];
        
        //playerVC.isTrending = self.genreID != nil ? YES : NO;
        
    }
    else if ([segue.identifier isEqualToString:@"showAlbum1"]) {
        AlbumDetail * vc = (AlbumDetail*)segue.destinationViewController;
        PlaylistCell * cell = (PlaylistCell *)sender;
        NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
        if (searchType == kLoadTypeArtist)
        {
            NSString * albumID = self.playlists[indexPath.row][@"album_id"];
            vc.albumImage = cell.coverImage.image;
            vc.albumID = albumID;
            vc.isfromSearch= YES;
        }
        else
        {
            NSString * albumID = self.playlists[indexPath.row][@"album_id"];
            vc.albumImage = cell.coverImage.image;
            vc.albumID = albumID;
            vc.isfromSearch= YES;
        }
        
        
    }
}

@end
