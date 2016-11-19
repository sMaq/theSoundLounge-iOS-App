//
//  Home.m
//  SoundLounge
//
//  Created by Apple on 24/04/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "TrendingViewController.h"
#import "WDWExampleStatusFlowCell.h"
#import "WDWStatusFlowView.h"
#import "WDWStatusFlowEnum.h"
#import "SWRevealViewController.h"
#import "NewArtistViewController.h"
#import "PlaylistCell.h"
#import "AlbumDetail.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FullyHorizontalFlowLayout.h"



@interface TrendingViewController(){
    int layerZ;
}

@property (nonatomic, weak) IBOutlet WDWStatusFlowView * collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPlaylists;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPlayListNew;
@property (nonatomic, weak) IBOutlet UIButton * sideBarButton;

@property NSArray * trendingArtists;
@property NSArray * trendingPlaylists;
@property NSArray * trendingPlaylistsNew;

@property NSArray <NSString *> * artistImages;
@property NSArray <NSString *> * playlistImages;
@property NSArray <NSString *> * playlistImagesNew;

@property NSMutableArray <NSString *> * artistNamesForPlaylists;
@property NSMutableArray <NSString *> * artistNamesForPlaylistsNew;
@end

@implementation TrendingViewController
- (IBAction)search:(UIButton *)sender {
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    counterSwipe=5;
   // self.collectionView.scrollEnabled = FALSE;
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.collectionView addGestureRecognizer:swipeleft];
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.collectionView addGestureRecognizer:swiperight];
    [self.collectionViewPlaylists registerNib:[UINib nibWithNibName:@"PlaylistCell" bundle:nil] forCellWithReuseIdentifier:@"Playlist"];
    
    layerZ = 0;
    self.collectionViewPlayListNew.dataSource = self;
    self.collectionViewPlayListNew.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.gapBetweenCells = -50;
    self.collectionView.direction = WDWStatusFlowViewDirectionHorizontal;

    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ){
        
        [self.sideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.trendingArtists = @[];
    self.trendingPlaylists = @[];
    self.artistNamesForPlaylists = [[NSMutableArray alloc]init];
    self.artistNamesForPlaylistsNew = [[NSMutableArray alloc]init];
    [self loadDataFromServer];
    
}
NSInteger counterSwipe=5;
-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (self.collectionView.selectedIndex==0) {
        
    }
    if (counterSwipe<_trendingPlaylists.count+1) {
        counterSwipe++;
        layerZ = layerZ +1;
    }
    else if(counterSwipe>0)
    {

    }
    
            NSIndexPath *iPath = [NSIndexPath indexPathForItem:counterSwipe inSection:0];
    
            [self.collectionView cellForItemAtIndexPath:iPath].layer.zPosition = layerZ;
    
            [self.collectionView setNeedsDisplay];
    
            if( self.collectionView.selectedIndex < 10 ){
                self.collectionView.selectedIndex = counterSwipe;
            }
    //Do what you want here
    NSLog(@"Left Swipe");
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (self.collectionView.selectedIndex==0) {
        
    }
    if (counterSwipe>0) {
        counterSwipe--;
        layerZ = layerZ -1;
    }
    else if(counterSwipe>0)
    {
        //        layerZ = 1;
        //        counterSwipe=3;
        //        [self performSelectorOnMainThread:@selector(reloadCollectionViewData:) withObject:self.collectionView waitUntilDone:NO];
    }
    
    NSIndexPath *iPath = [NSIndexPath indexPathForItem:counterSwipe inSection:0];
    
    [self.collectionView cellForItemAtIndexPath:iPath].layer.zPosition = layerZ;
    
    [self.collectionView setNeedsDisplay];
    
    if( self.collectionView.selectedIndex < 10 ){
        self.collectionView.selectedIndex = counterSwipe;
    }

    NSLog(@"Right Swipe");
}

-(void)fetchArtistsData {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [WebAPI getTrendingArtistsWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            if (data != nil) {
                NSMutableArray * artistData = [data mutableCopy];
                NSMutableArray * artistThumbNails = [[NSMutableArray alloc]init];
                
                for (NSDictionary *t in artistData) {
                    id logoString = [t objectForKey:@"logo"];
                    NSArray * logos = nil;
                    
                    if (logoString != [NSNull null]) {
                        logos = [NSJSONSerialization JSONObjectWithData:[logoString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                    }
                    
                    else {
                        logos = @[];
                    }
                    
                    if (logos.count == 0) {
                        [artistThumbNails addObject:@""];
                        continue;
                    }
                    
                    else {
                        NSString * logo = logos.count > 1 ? logos[1] : logos[0];
                        NSString * dirName = t[@"dir_name"];
                        NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/photos/artist/%@/logo/%@",dirName,logo];
                        NSLog(@"URL: %@",url);
                        
                        [artistThumbNails addObject:url];
                    }
                    
                }
                
                self.trendingArtists = artistData;
                self.artistImages = artistThumbNails;
                
                [self performSelectorOnMainThread:@selector(reloadCollectionViewData:) withObject:self.collectionView waitUntilDone:NO];
            }
            
        }
        
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
    }];
}


-(void)fetchPlaylistDataWithCompletionHandler:(void (^)(void))callbackBlock {

    [WebAPI getTrendingPlaylistWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            if (data != nil) {
                NSMutableArray * playlistData = [[data valueForKey:@"new"] mutableCopy];
                
                NSMutableArray * playlistThumbNails = [[NSMutableArray alloc]init];
                NSMutableArray * playlistDataNew = [[data valueForKey:@"playlist"] mutableCopy];
                _artistNamesForPlaylists=[[NSMutableArray alloc]init];
                _artistNamesForPlaylists=[[playlistData valueForKey:@"username"]mutableCopy];;
                NSMutableArray * playlistThumbNailsNew = [[NSMutableArray alloc]init];
                //////////Trending List Play//////////
                for (NSDictionary *t in playlistData) {
                    id logoString = [t objectForKey:@"logo"];
                    NSArray * logos = nil;
                    
                    if (logoString != [NSNull null]) {
                        logos = [NSJSONSerialization JSONObjectWithData:[logoString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                    }
                    
                    else {
                        logos = @[];
                    }
                    
                    if (logos.count == 0) {
                        [playlistThumbNails addObject:@""];
                        continue;
                    }
                    
                    else {
//                        NSString * logo = logos.count > 1 ? logos[1]: logos[0];
                        NSString * logo = logos[0];
                        NSString * dirName = t[@"dir_name"];
                        NSString * albumName = t[@"name"];
                        
                        NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/logo/%@",dirName,albumName,logo];
                        NSLog(@"URL: %@",url);
                        
                        
                        [playlistThumbNails addObject:url];
                        
                    }
                    
                }
                
                self.trendingPlaylists = playlistData;
                self.playlistImages = playlistThumbNails;
        //////////////////////////Trending List Play NEW//////////
                _artistNamesForPlaylistsNew=[[NSMutableArray alloc]init];
                _artistNamesForPlaylistsNew=[[playlistDataNew valueForKey:@"username"]mutableCopy];
                for (NSDictionary *t in playlistDataNew) {
                    id logoString = [t objectForKey:@"logo"];
                    NSArray * logos = nil;
                    
                    if (logoString != [NSNull null]) {
                        logos = [NSJSONSerialization JSONObjectWithData:[logoString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                    }
                    
                    else {
                        logos = @[];
                    }
                    
                    if (logos.count == 0) {
                        [playlistThumbNailsNew addObject:@""];
                        continue;
                    }
                    
                    else {
                        //                        NSString * logo = logos.count > 1 ? logos[1]: logos[0];
                        NSString * logo = logos[0];
                        NSString * dirName = t[@"dir_name"];
                        NSString * albumName = t[@"name"];
                        
                        NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/logo/%@",dirName,albumName,logo];
                        NSLog(@"URL: %@",url);
                        
                        
                        [playlistThumbNailsNew addObject:url];
                        
                    }
                    
                }
                self.trendingPlaylistsNew = playlistDataNew;
                self.playlistImagesNew = playlistThumbNailsNew;

                callbackBlock();
            }
        }
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];

        }
    }];
    
}


-(void)loadDataFromServer {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self showProgressHUD];
    [self fetchArtistsData];
    [self fetchPlaylistDataWithCompletionHandler:^{
        for (NSDictionary * temp in self.trendingPlaylists){
            NSString * artistID = temp[@"artist_id"];
            NSLog(@"album id: %@",temp[@"album_id"]);
            NSLog(@"artist id: %@",temp[@"artist_id"]);
            NSString * url = [NSString stringWithFormat:@"%@f_name=get_artist&user_id=%@",API_URL,artistID];
            NSArray * tempArray = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]] options:NSJSONReadingMutableLeaves error:nil];
            
            NSString * fullName = [NSString stringWithFormat:@"%@ %@",tempArray[0][@"firstname"] == [NSNull null]?@"":tempArray[0][@"firstname"],tempArray[0][@"lastname"] ==[NSNull null]?@"":tempArray[0][@"lastname"]];
            [self.artistNamesForPlaylists addObject:fullName];
        }
        [self performSelectorOnMainThread:@selector(reloadCollectionViewData:) withObject:self.collectionViewPlaylists waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(ListCollectionViewDataNew:) withObject:self.collectionViewPlayListNew waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];

    }];
}

-(void)reloadCollectionViewData:(UICollectionView *)collectionView {
    [collectionView reloadData];
}
-(void)ListCollectionViewDataNew:(UICollectionView *)collectionView {
    [collectionView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    
    
    [UIView animateWithDuration:0
                     animations: ^{ [self.collectionView reloadData]; }
                     completion:^(BOOL finished) {
                         
                         if( self.collectionView.selectedIndex < 10 ){
                             self.collectionView.selectedIndex = 5;
                         }
                         
                     }];
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (collectionView == self.collectionView) {
        return 1;
    }
    else
    {
        return 2;
    }
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.collectionView)
    {
        return self.trendingArtists.count;
    }
    else
    {
        if (section ==0)
        {
            return self.trendingPlaylists.count;
            
        }
        else
        {
            
            return self.trendingPlaylistsNew.count;
        }
        
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
        
        WDWExampleStatusFlowCell *cell = (WDWExampleStatusFlowCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"WDWExampleCell" forIndexPath:indexPath];
        
        if( cell ){
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.artistImages[indexPath.row]] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
            
        }
        
//        CAShapeLayer *circle = [CAShapeLayer layer];
//        // Make a circular shape
//        UIBezierPath *circularPath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, cell.imageView.frame.size.width, cell.imageView.frame.size.height) cornerRadius:MAX(cell.imageView.frame.size.width, cell.imageView.frame.size.height)];
//        
//        circle.path = circularPath.CGPath;
//        
//        // Configure the apperence of the circle
//        circle.fillColor = [UIColor blackColor].CGColor;
//        circle.strokeColor = [UIColor blackColor].CGColor;
//        circle.lineWidth = 0;
//        
//        cell.imageView.layer.mask=circle;
        
        return cell;
    }
    else{
        NSLog(@"%ld section %ld index",(long)indexPath.section,(long)indexPath.row);
        if (indexPath.section ==0)
        {
            PlaylistCell *cell = (PlaylistCell *)[self.collectionViewPlaylists dequeueReusableCellWithReuseIdentifier:@"Playlist" forIndexPath:indexPath];
            [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:self.playlistImages[indexPath.row]] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
            NSDictionary * temp = self.trendingPlaylists[indexPath.row];
            cell.titleLabel.text = temp[@"name"];
             cell.subtitleLabel.text = self.artistNamesForPlaylists[indexPath.row];
             NSLog(@"%@",self.artistNamesForPlaylists[indexPath.row]);
            
            return cell;
           
            
        }
        else
        {
            PlaylistCell *cell = (PlaylistCell *)[self.collectionViewPlaylists dequeueReusableCellWithReuseIdentifier:@"Playlist" forIndexPath:indexPath];
            [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:self.playlistImagesNew[indexPath.row]] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
            NSDictionary * temp = self.trendingPlaylistsNew[indexPath.row];
            cell.titleLabel.text = temp[@"name"];
             cell.subtitleLabel.text = self.artistNamesForPlaylistsNew[indexPath.row];
             NSLog(@"%@ New lists ",self.artistNamesForPlaylistsNew[indexPath.row]);
            
            return cell;
        }
    
        
    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionViewCellHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerVw" forIndexPath:indexPath];
        if (indexPath.section==0) {
            
            headerView.titleLbl.text = @"What's New";
        }
        else
        {
            headerView.titleLbl.text = @"Trending Playlists";
            
        }
        
        
        reusableview = headerView;
    }
    
    
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView) {
        
        if (indexPath.section == 0){
            return CGSizeMake(170, 170);
        }
        
    }
    else{
        
        //if (indexPath.section == 0){
            return CGSizeMake(135, 165);
       // }
//        CGSize deviceSize = [UIScreen mainScreen].bounds.size;
//        CGFloat flexSize = sqrt((double)(deviceSize.width * deviceSize.height) / ((double)(10)));
//        
//        return CGSizeMake(flexSize, flexSize);
//        
    }
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        
        [self performSegueWithIdentifier:@"newArtist" sender:[collectionView cellForItemAtIndexPath:indexPath]];
//        NSIndexPath *iPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
//        layerZ = layerZ +1;
//        [self.collectionView cellForItemAtIndexPath:iPath].layer.zPosition = layerZ;
//        
//        [self.collectionView setNeedsDisplay];
//        
//        if( self.collectionView.selectedIndex < 10 ){
//            self.collectionView.selectedIndex = indexPath.row;
//        }
        
    }
    else {
        NSLog(@"%ld section %ld index",(long)indexPath.section,(long)indexPath.row);
        if (indexPath.section==0) {
            
            
            NSDictionary * temp = self.trendingPlaylists[indexPath.row];
            _albumID = temp[@"album_id"];
            [self performSegueWithIdentifier:@"player" sender:[collectionView cellForItemAtIndexPath:indexPath]];
            
        }
        else
        {
            NSDictionary * temp = self.trendingPlaylistsNew[indexPath.row];
            _albumID = temp[@"album_id"];
            [self performSegueWithIdentifier:@"player" sender:[collectionView cellForItemAtIndexPath:indexPath]];
            
        }
        
    }
    
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"player"]) {
        AlbumDetail * vc = segue.destinationViewController;
        PlaylistCell * cell = (PlaylistCell*)sender;
//        NSIndexPath *indexPath = [self.collectionViewPlaylists indexPathForCell:cell];
//        NSDictionary * temp = self.trendingPlaylists[indexPath.row];
//        NSString * albumID = temp[@"album_id"];
        vc.albumID = _albumID;
        vc.albumImage = cell.coverImage.image;
        vc.albumName=cell.titleLabel.text;
    }
    else if ([segue.identifier isEqualToString:@"newArtist"]) {
        NewArtistViewController * vc = segue.destinationViewController;
        PlaylistCell * cell = (PlaylistCell*)sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        NSDictionary * temp = self.trendingArtists[indexPath.row];
        NSString * artistID = temp[@"artist_id"];
        vc.selectedArtistIdFrmTrendingView = artistID.integerValue;
        vc.artist_idFOrAlbum=artistID;
        
    }
    
}


@end
