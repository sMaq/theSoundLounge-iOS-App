//
//  FreeBieExclusive.m
//  SoundLounge
//
//  Created by Apple on 01/05/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "FreeBieExclusive.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PlaylistCell.h"
#import "AlbumDetail.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface FreeBieExclusive ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sideBarButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPlaylists;
@property NSArray * playlist;
@property NSArray <NSString *> * imageURLs;
@end
@implementation FreeBieExclusive
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
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [self fetchFreebies];
    }
    else {
        [self fetchExclusives];
    }
    
}

-(void)fetchFreebies{
    [self showProgressHUD];
    [WebAPI getFreeBiesWithCompletionHandler:^(BOOL isError, NSArray *data) {
        
        if (data) {
            
            NSDictionary * temp = (NSDictionary *)data;
            if ([temp.allKeys containsObject:@"msg"]) return;
            
            NSArray * playlist = temp[@"Free_bies"];
            NSArray * artists = temp[@"artist"];
            
            NSMutableArray * urlsForImages = [[NSMutableArray alloc]init];
            
            for (NSDictionary *t in playlist) {
                id logoString = [t objectForKey:@"logo"];
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
                    //                        NSString * logo = logos.count > 1 ? logos[1]: logos[0];
                    NSString * logo = logos[0];
                    NSString * artistID =  t[@"artist_id"];
                    NSString * dirName = @"";
                    for (NSDictionary *a in artists) {
                        
                        if ([a[@"artist_id"] isEqualToString:artistID]) {
                            dirName = a[@"dir_name"];
                            break;
                        }
                    }
                    
                    NSString * albumName = t[@"name"];
                    
                    NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/logo/%@",dirName,albumName,logo];
                    
                    [urlsForImages addObject:url];
                    
                }
                
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

-(void)fetchExclusives{
    [self showProgressHUD];
    [WebAPI getExclusiveFreeBiesWithCompletionHandler:^(BOOL isError, NSArray *data) {
        
        if (data) {
            
            NSDictionary * temp = (NSDictionary *)data;
            if ([temp.allKeys containsObject:@"msg"]) return;

            NSArray * playlist = temp[@"Free_bies"];
            NSArray * artists = temp[@"artist"];
            
            NSMutableArray * urlsForImages = [[NSMutableArray alloc]init];
            
            for (NSDictionary *t in playlist) {
                id logoString = [t objectForKey:@"logo"];
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
                    //                        NSString * logo = logos.count > 1 ? logos[1]: logos[0];
                    NSString * logo = logos[0];
                    NSString * artistID =  t[@"artist_id"];
                    NSString * dirName = @"";
                    for (NSDictionary *a in artists) {
                        
                        if ([a[@"artist_id"] isEqualToString:artistID]) {
                            dirName = a[@"dir_name"];
                            break;
                        }
                    }
                    
                    NSString * albumName = t[@"name"];
                    
                    NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/logo/%@",dirName,albumName,logo];
//                    NSLog(@"URL: %@",url);
//                    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                    
//                    image = image != nil ? image : [self imageFromColor:[UIColor darkGrayColor]];
                    [urlsForImages addObject:url];
                    
                }
                
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
    NSDictionary * temp = self.playlist[indexPath.row];
    cell.titleLabel.text = temp[@"name"];
    //    cell.subtitleLabel.text = self.artistNamesForPlaylists[indexPath.row];
    
    if ([self.imageURLs[indexPath.row] isEqualToString:@""]) {
        cell.coverImage.image = [self imageFromColor:[UIColor blackColor]];
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
    [self performSegueWithIdentifier:@"player" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"player"]) {
        AlbumDetail * vc = segue.destinationViewController;
        PlaylistCell * cell = (PlaylistCell*)sender;
        NSIndexPath *indexPath = [self.collectionViewPlaylists indexPathForCell:cell];
        NSDictionary * temp = self.playlist[indexPath.row];
        NSString * albumID = temp[@"album_id"];
        vc.albumID = albumID;
        vc.albumImage = cell.coverImage.image;
    }
}


@end
