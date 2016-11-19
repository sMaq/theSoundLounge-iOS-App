//
//  FavouritesViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "FavouritesViewController.h"
#import "SWRevealViewController.h"
#import "PlaylistCell.h"
#import "AlbumDetail.h"
#import "PlayerViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface FavouritesViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sideBarButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPlaylists;

// data
@property NSArray * playlist;
@property NSArray <NSString *> * imageURLs;

@end

@implementation FavouritesViewController

- (IBAction)search:(UIButton *)sender {
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.playlist = @[];
    
    [self.collectionViewPlaylists registerNib:[UINib nibWithNibName:@"PlaylistCell" bundle:nil] forCellWithReuseIdentifier:@"Playlist"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ) {
        [self.sideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    _segmentControl.layer.borderColor=[UIColor colorWithRed:39.0f/255.0f green:166.0f/255.0f blue:149.0f/255.0f alpha:1].CGColor;
    _segmentControl.layer.cornerRadius = 0.0;
    _segmentControl.layer.borderWidth = 1.5f;
    
    UIFont *font = [UIFont fontWithName:@"Optima-bold" size:12];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [_segmentControl setTitleTextAttributes:attributes
                                   forState:UIControlStateNormal];
    [self loadDataFromServer];
}


- (IBAction)segmentedControlValueChanges:(UISegmentedControl *)sender {
    [self loadDataFromServer];
}


#pragma - Fetch Data From Server
-(void)loadDataFromServer {
    if (self.segmentControl.selectedSegmentIndex == 1) {
        [self fetchFavouriteSongs];
    }
    else {
        [self fetchFavouriteAlbums];
    }
    
}

-(void)fetchFavouriteAlbums{
    [self showProgressHUD];
    
    [WebAPI getFavoruiteAlbumsWithCompletionHandler:^(BOOL isError, NSArray *responseData) {
        if (responseData){
            
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                if ( [((NSDictionary *)responseData).allKeys containsObject:@"msg"] ){
                    self.playlist = @[];
                    [self performSelectorOnMainThread:@selector(reloadCollectionViewData) withObject:nil waitUntilDone:NO];
                    [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    return;
                }
            }
            

            NSMutableArray * playlist = [[NSMutableArray alloc]init];
            NSMutableArray * urlsForImages = [[NSMutableArray alloc]init];
            NSDictionary * tempData = (NSDictionary *)responseData;
            NSArray * data = tempData[@"albums"];
            for (NSDictionary * item in data){
                
                NSString * dirName = item[@"dir_name"];
                NSString * albumName = item[@"name"];
                NSString * userName = item[@"username"];
                NSString * artistName =[NSString stringWithFormat:@" %@",item[@"username"]]; //[NSString stringWithFormat:@"%@ %@",item[@"firstname"],item[@"lastname"]];
                NSString * albumID = item[@"album_id"];
                id logoString = item[@"logo"];
                
                NSArray * logos = nil;
                
                if (logoString != [NSNull null]) {
                    logos = [NSJSONSerialization JSONObjectWithData:[logoString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                }
                
                else {
                    logos = @[];
                }
                
                if (logos.count == 0) {
                    [urlsForImages addObject:@""];
                }
                
                else {
                    
                    NSString * logo = logos[0];
                    
                    NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/logo/%@",dirName,albumName,logo];
                    
//                    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                    
//                    image = image != nil ? image : [self imageFromColor:[UIColor darkGrayColor]];
//                    [images addObject:image];
                    [urlsForImages addObject:url];
                    
                }
                
                [playlist addObject:@[
                                       @{
                                           @"name":albumName,
                                           @"dir_name":dirName,
                                           @"filename":@"",
                                           @"album_name":albumName,
                                           @"album_id":albumID
                                           },
                                       artistName,
                                       @""
                                       ]];
                
            }
            
            self.playlist = playlist;
            self.imageURLs = urlsForImages;
            
            [self performSelectorOnMainThread:@selector(reloadCollectionViewData) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
        
        
        
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
    }];
    
}

-(void)fetchFavouriteSongs{
    
    [self showProgressHUD];
    
    [WebAPI getFavoruiteSongsWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (data) {
            
            if (!data){
                self.playlist = @[];
                [self performSelectorOnMainThread:@selector(reloadCollectionViewData) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                
                return;
            }
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                if ( [((NSDictionary *)data).allKeys containsObject:@"msg"] ){
                    NSLog(@"MSG is there....!");
                    self.playlist = @[];
                    [self performSelectorOnMainThread:@selector(reloadCollectionViewData) withObject:nil waitUntilDone:NO];
                    [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    
                    return;
                }
            }
            
            
            NSDictionary * temp = (NSDictionary *)data;
            NSArray * favouriteSongs = temp[@"favorites"];
            NSArray * artists = temp[@"artists"];
            NSArray * albums = temp[@"albums"];
            
            NSMutableArray * images = [[NSMutableArray alloc]init];
            NSMutableArray * songsData = [[NSMutableArray alloc]init];
            
            
            for (NSDictionary * s  in favouriteSongs) {
                
                NSString * songName = s[@"name"];
                NSString * artistID = s[@"artist_id"];
                NSString * fileName = s[@"filename"];
                NSString * dirName = @"";
                NSString * artistName = @"";
                NSString * albumName = @"";
                
                id logoString;
                
                for (NSDictionary * a in artists){
                    if ([a[@"artist_id"] isEqualToString:artistID]) {
                        dirName = a[@"dir_name"];
                        logoString = a[@"logo"];
                        artistName = [NSString stringWithFormat:@"%@ %@",a[@"firstname"],a[@"lastname"]];
                        break;
                    }
                }
                
                for (NSDictionary * album in albums){
                    if ([artistID isEqualToString:album[@"artist_id"]]){
                        albumName = album[@"name"];
                        break;
                    }
                }
                
                NSArray * logos = nil;
                
                if (logoString != [NSNull null]) {
                    logos = [NSJSONSerialization JSONObjectWithData:[logoString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                }
                
                else {
                    logos = @[];
                }
                
                if (logos.count == 0) {
                    [images addObject:[self imageFromColor:[UIColor darkGrayColor]]];
                }
                
                else {
                    
                    NSString * logo = logos[0];
                    NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/logo/%@",dirName,albumName,logo];
                    
                    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                    
                    image = image != nil ? image : [self imageFromColor:[UIColor darkGrayColor]];
                    [images addObject:image];
                }
                
                [songsData addObject:@[
                                       @{
                                           @"name":songName,
                                           @"dir_name":dirName,
                                           @"filename":fileName,
                                           @"album_name":albumName
                                           },
                                       artistName,
                                       @""
                                       ]];
            }
            
            self.playlist = songsData;
            
            [self performSelectorOnMainThread:@selector(reloadCollectionViewData) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            
            
        }
        
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
        
        
    }];
    
}

#pragma mark - Collection View

-(void)reloadCollectionViewData {
    [self.collectionViewPlaylists reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.playlist.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlaylistCell *cell = (PlaylistCell *)[self.collectionViewPlaylists dequeueReusableCellWithReuseIdentifier:@"Playlist" forIndexPath:indexPath];
    
    cell.titleLabel.text = self.playlist[indexPath.row][0][@"name"];
    
    cell.subtitleLabel.text = self.playlist[indexPath.row][1];
    //cell.subtitleLabel.hidden=YES;
    if ([self.imageURLs[indexPath.row] isEqualToString:@""]) {
        [self imageFromColor:[UIColor blackColor]];
    }
    else {
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[indexPath.row]] placeholderImage:[self imageFromColor:[UIColor blackColor]]];
    }
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize deviceSize = [UIScreen mainScreen].bounds.size;
    CGFloat flexSize = sqrt((double)(deviceSize.width * deviceSize.height) / ((double)(10)));
    
    return CGSizeMake(flexSize, flexSize);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:self.segmentControl.selectedSegmentIndex == 0 ? @"player" : @"song" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"player"]) {
        AlbumDetail * vc = segue.destinationViewController;
        PlaylistCell * cell = (PlaylistCell*)sender;
        NSIndexPath *indexPath = [self.collectionViewPlaylists indexPathForCell:cell];
        NSString * albumID = self.playlist[indexPath.row][0][@"album_id"];
        vc.albumID = albumID;
        vc.albumImage = cell.coverImage.image;
    }
    
    else if ([segue.identifier isEqualToString:@"song"]){
        PlayerViewController * vc = segue.destinationViewController;
        PlaylistCell * cell = (PlaylistCell*)sender;
        NSIndexPath *indexPath = [self.collectionViewPlaylists indexPathForCell:cell];
        NSArray * data = self.playlist[indexPath.row];
        vc.currentSongData = data;
        vc.coverImage = cell.coverImage.image;
        vc.isTrending = NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }

@end
