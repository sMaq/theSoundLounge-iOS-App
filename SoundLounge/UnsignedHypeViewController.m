//
//  UnsignedHypeViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "UnsignedHypeViewController.h"
#import "SWRevealViewController.h"
#import "PlaylistCell.h"
#import "NewArtistViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface UnsignedHypeViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *sideBarButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPlaylists;

@property NSArray * data;

@end

@implementation UnsignedHypeViewController

- (IBAction)search:(UIButton *)sender {
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.collectionViewPlaylists registerNib:[UINib nibWithNibName:@"PlaylistCell" bundle:nil] forCellWithReuseIdentifier:@"Playlist"];
    
    self.data = @[];
    
    [self showProgressHUD];
    
    [WebAPI getUnsignedHypesWithCompletionHandler:^(BOOL isError, NSArray *temp) {
        if (isError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showErrorAlert:kError_Network];
                [self hideProgressHUB];
            });
           
            return;
        }
        
        if (temp) {
            self.data = [((NSDictionary *)temp) valueForKey:@"hypes"];
        }
        NSString * dirName =  [_data valueForKey:@"dir_name"];
        
        NSString * logo = @"";
        
        NSString * logoURL = @"";
        _imagesArr=[[NSMutableArray alloc] init];
        
        NSMutableArray *thumbnailsArr=[[NSMutableArray alloc] init];
        for (NSDictionary *t in _data) {
            id logoString = [t objectForKey:@"logo"];
            NSArray * logos = nil;
            
            if (logoString != [NSNull null]) {
                logos = [NSJSONSerialization JSONObjectWithData:[logoString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            }
            
            else {
                logos = @[];
            }
            
            if (logos.count == 0) {
                [thumbnailsArr addObject:@""];
                continue;
            }
            
            else {
                //                        NSString * logo = logos.count > 1 ? logos[1]: logos[0];
                NSString * logo = logos.count > 1 ? logos[1] : logos[0];
                NSString * dirName = t[@"dir_name"];
                NSString * albumName = t[@"name"];
                
                NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/photos/artist/%@/logo/%@",dirName,logo];
                NSLog(@"URL: %@",url);
                
                [thumbnailsArr addObject:url];
                
            }
            
        }
        self.imagesArr = thumbnailsArr;
        [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(reloadCollectionViewData) withObject:nil waitUntilDone:NO];
        
    }];
    
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
    
}

-(void)reloadCollectionViewData {
    [self.collectionViewPlaylists reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.data.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!(indexPath.section == 0)){
        return nil;
    }
    
    NSDictionary * tempData = self.data[indexPath.row];
    PlaylistCell *cell = (PlaylistCell *)[self.collectionViewPlaylists dequeueReusableCellWithReuseIdentifier:@"Playlist" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@",tempData[@"firstname"],tempData[@"lastname"]];
    cell.subtitleLabel.text = tempData[@"songs"];
    [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize deviceSize = [UIScreen mainScreen].bounds.size;
    CGFloat flexSize = sqrt((double)(deviceSize.width * deviceSize.height) / ((double)(10)));
    
    return CGSizeMake(flexSize, flexSize);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"gotoNewArtist" sender:[collectionView cellForItemAtIndexPath:indexPath]];
    
}
#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"player"]) {

    }
    else if ([segue.identifier isEqualToString:@"gotoNewArtist"]) {
        NewArtistViewController * vc = segue.destinationViewController;
        PlaylistCell * cell = (PlaylistCell*)sender;
        NSIndexPath *indexPath = [self.collectionViewPlaylists indexPathForCell:cell];
        NSDictionary * temp = self.data[indexPath.row];
        NSString * artistID = temp[@"artist_id"];
        vc.artist_idFOrAlbum=artistID;
        vc.selectedArtistIdFrmTrendingView = artistID.integerValue;
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }

@end
