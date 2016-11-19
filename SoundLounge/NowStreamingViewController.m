//
//  NowStreamingViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "NowStreamingViewController.h"
#import "SWRevealViewController.h"
#import "PlaylistCell.h"
#import "NowStreamingDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface NowStreamingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sideBarButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPlaylists;
@property NSArray * genreData;

@end

@implementation NowStreamingViewController

- (IBAction)search:(UIButton *)sender {
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.genreData = @[];
    
    [self.collectionViewPlaylists registerNib:[UINib nibWithNibName:@"PlaylistCell" bundle:nil] forCellWithReuseIdentifier:@"Playlist"];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
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




-(void)loadDataFromServer{
    [self showProgressHUD];
    [WebAPI getGenereWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            if (data) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    if ( [((NSDictionary *)data).allKeys containsObject:@"msg"] ){
                        self.genreData = @[];
                        [self performSelectorOnMainThread:@selector(reloadCollectionViewData) withObject:nil waitUntilDone:NO];
                        [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                        return;
                    }
                }
                
                NSDictionary * temp = (NSDictionary *)data;
                
                self.genreData = temp[@"category"];
                
                [self performSelectorOnMainThread:@selector(reloadCollectionViewData) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                
            }
        }
        else {
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
        }
    }];
}

-(void)reloadCollectionViewData{
    [self.collectionViewPlaylists reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.genreData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/admin/media/%@/logo/%@",self.genreData[indexPath.row][@"category_id"],self.genreData[indexPath.row][@"logo"]];
    NSLog(@"URL: %@",url);
    PlaylistCell *cell = (PlaylistCell *)[self.collectionViewPlaylists dequeueReusableCellWithReuseIdentifier:@"Playlist" forIndexPath:indexPath];
    cell.titleLabel.text = self.genreData[indexPath.row][@"name"];
    cell.subtitleLabel.text = @"";
    [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"details" sender:[self.collectionViewPlaylists cellForItemAtIndexPath:indexPath]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize deviceSize = [UIScreen mainScreen].bounds.size;
    CGFloat flexSize = sqrt((double)(deviceSize.width * deviceSize.height) / ((double)(10)));
    
    return CGSizeMake(flexSize, flexSize);
    
}


#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"details"]) {
        NSIndexPath * indexPath = [self.collectionViewPlaylists indexPathForCell:(PlaylistCell *)sender];;
        NowStreamingDetailsViewController * vc = segue.destinationViewController;
        vc.genreData = self.genreData;
        vc.selectedIndex = indexPath.row;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }

@end
