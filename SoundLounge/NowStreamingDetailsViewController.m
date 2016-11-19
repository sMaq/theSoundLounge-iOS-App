//
//  NowStreamingDetailsViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "NowStreamingDetailsViewController.h"
#import "WDWExampleStatusFlowCell.h"
#import "WDWStatusFlowView.h"
#import "WDWStatusFlowEnum.h"
#import "LTInfiniteScrollView.h"
#import "PlaylistCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AlbumDetail.h"



@interface NowStreamingDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,LTInfiniteScrollViewDataSource,LTInfiniteScrollViewDelegate> {
    
    int layerZ;

}

@property (weak, nonatomic) IBOutlet LTInfiniteScrollView *genreView;

@property (weak, nonatomic) IBOutlet WDWStatusFlowView *collectionViewPlaylistsCover;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPlaylists;

@property NSArray * albumsData;
@property NSArray * selectedAlbumData;
@property NSArray * otherPlaylistData;

@end

@implementation NowStreamingDetailsViewController

- (IBAction)search:(UIButton *)sender {
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.albumsData = @[];
    _selectedAlbumData=[[NSArray alloc] init];
    [self.collectionViewPlaylists registerNib:[UINib nibWithNibName:@"PlaylistCell" bundle:nil] forCellWithReuseIdentifier:@"Playlist"];
    
    NSLog(@"selected Index: %lu",_selectedIndex);
    
    layerZ = 0;
    self.collectionViewPlaylists.delegate=self;
    self.collectionViewPlaylists.dataSource=self;
    self.collectionViewPlaylistsCover.dataSource = self;
    self.collectionViewPlaylistsCover.delegate = self;
    self.collectionViewPlaylistsCover.gapBetweenCells = -50;
    self.collectionViewPlaylistsCover.direction = WDWStatusFlowViewDirectionHorizontal;
    
    self.genreView.dataSource = self;
    self.genreView.delegate = self;
    
    self.genreView.verticalScroll = NO;
    [self.genreView setContentInset:UIEdgeInsetsMake(0, 0, 0, 550)];
    self.genreView.maxScrollDistance = 5;
    
    [self.genreView reloadDataWithInitialIndex: self.selectedIndex];
    
    [self loadDataFromServer];

}

#pragma mark - LT Scroll View


-(void)loadDataFromServer {
    
    NSString * categoryID = self.genreData[self.selectedIndex][@"category_id"];
    
    [self showProgressHUD];
    [WebAPI getNowStreamingAlbumsWithCategoryID:categoryID CompletionHandler:^(BOOL isError, NSArray *data) {
        if (isError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressHUB];
                [self showErrorAlert:kError_Network];
            });
            
            return;
        }
        
        if(data) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                if ( [((NSDictionary *)data).allKeys containsObject:@"msg"] ){
                    NSLog(@"MSG is there....!");
                    [self performSelectorOnMainThread:@selector(reloadCollectionViewData:) withObject:self.collectionViewPlaylists waitUntilDone:NO];
                    [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    
                    return;
                }
            }

            
            
            self.albumsData = [((NSDictionary * )data) valueForKey:@"playlist"] == [NSNull null] ? @[] : [((NSDictionary * )data) valueForKey:@"playlist"];
            self.otherPlaylistData = [((NSDictionary * )data) valueForKey:@"other_playlist"] == [NSNull null] ? @[] : [((NSDictionary * )data) valueForKey:@"other_playlist"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadCollectionViewData:self.collectionViewPlaylists];
                [self reloadCollectionViewData:self.collectionViewPlaylistsCover];
                [self hideProgressHUB];
            });
           
        }
        
        
    }];
}


-(void)reloadCollectionViewData:(UICollectionView *)collectionView {
    [collectionView reloadData];
}
-(void)reloadCollectionViewDataNew:(UICollectionView *)collectionView {
    [collectionView reloadData];
}

- (void)viewSelected:(UIView *)view {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if ([view isKindOfClass:[UIImageView class]]){
        UIImageView * imageView = (UIImageView *)view;
        NSLog(@"%@",((UILabel *)imageView.subviews[0]).text);
        NSLog(@"%lu",imageView.tag);
        
        self.selectedIndex = imageView.tag;
        
        [self loadDataFromServer];
        

    }
}

- (NSInteger)numberOfViews
{
    // you can set it to a very big number to mimic the infinite behavior, no performance issue here
//    return self.genreData.count;
    
    return self.genreData.count < 5 ? self.genreData.count : 5;
}

- (NSInteger)numberOfVisibleViews {
    return self.genreData.count < 5 ? self.genreData.count : 5;
}

- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    if (view) {
        NSLog(@"INDEX %lu",index);
        ((UIImageView *)view).image = [self imageFromColor:[UIColor blueColor]];
        ((UILabel *)((UIImageView *)view).subviews[0]).text = self.genreData[index][@"name"];
        ((UILabel *)((UIImageView *)view).subviews[0]).textColor = [UIColor whiteColor];
        ((UIImageView *)view).tag = index;
        return view;
    }
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.tag = index;
    imageView.image = [self imageFromColor:[UIColor blueColor]];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.layer.cornerRadius = 20;
    imageView.layer.masksToBounds = YES;
    UILabel * label = [[UILabel alloc]initWithFrame:imageView.bounds];
    label.font = [UIFont systemFontOfSize:8];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.genreData[index][@"name"];
    [imageView addSubview:label];
    
    return imageView;
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    
    
//    [UIView animateWithDuration:0
//                     animations: ^{ [self.collectionViewPlaylistsCover reloadData]; }
//                     completion:^(BOOL finished) {
//                         
//                         if( self.collectionViewPlaylistsCover.selectedIndex < 10 ){
//                             self.collectionViewPlaylistsCover.selectedIndex = 5;
//                         }
//                         
//                     }];
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return (collectionView == self.collectionViewPlaylists) ? self.otherPlaylistData.count : self.albumsData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if( !(indexPath.section == 0) ){
        return nil;
    }
    
    if (collectionView == self.collectionViewPlaylistsCover)
    {
        
        WDWExampleStatusFlowCell *cell = (WDWExampleStatusFlowCell *)[self.collectionViewPlaylistsCover dequeueReusableCellWithReuseIdentifier:@"PlaylistCell" forIndexPath:indexPath];
        
        NSString* categoryID = self.genreData[self.selectedIndex][@"category_id"];
        NSString* categoryName = self.albumsData[indexPath.row][@"name"];
        NSString * logo = self.albumsData[indexPath.row][@"logo"];
        NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/admin/media/%@/%@/logo/%@",categoryID,categoryName,logo];
        //http://thesound-lounge.com/lounge/admin/media/45/cool album/logo/activity.png
        _UrlStr=url;
        NSLog(@"%@ 11",url);
        NSString* encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:
                                NSUTF8StringEncoding];
        NSLog(@"%@ urlwithstr",[NSURL URLWithString:encodedUrl]);
        if (cell){
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:encodedUrl] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
            });
            
        }
       // [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
        
        
        
        /*
        CAShapeLayer *circle = [CAShapeLayer layer];
        // Make a circular shape
        UIBezierPath *circularPath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, cell.imageView.frame.size.width, cell.imageView.frame.size.height) cornerRadius:MAX(cell.imageView.frame.size.width, cell.imageView.frame.size.height)];
        
        circle.path = circularPath.CGPath;
        
        // Configure the apperence of the circle
        circle.fillColor = [UIColor blackColor].CGColor;
        circle.strokeColor = [UIColor blackColor].CGColor;
        circle.lineWidth = 0;
        
        cell.imageView.layer.mask=circle;
         */
        
        return cell;
    }
    else
    {

        NSString* name = self.otherPlaylistData[indexPath.row][@"name"];
        NSString* categoryID = self.otherPlaylistData[indexPath.row][@"category"];
        NSString* categoryName = self.otherPlaylistData[indexPath.row][@"name"];
        NSString * logo = self.otherPlaylistData[indexPath.row][@"logo"];
        NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/admin/media/%@/%@/logo/%@",categoryID,categoryName,logo];
        NSLog(@"%@ 22",url);
        PlaylistCell *cell = (PlaylistCell *)[self.collectionViewPlaylists dequeueReusableCellWithReuseIdentifier:@"Playlist" forIndexPath:indexPath];
        
        cell.titleLabel.text = name;
        cell.subtitleLabel.text = @"";
        NSString* encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:
                                NSUTF8StringEncoding];
        NSLog(@"%@ urlwithstr",[NSURL URLWithString:encodedUrl]);
        dispatch_async(dispatch_get_main_queue(), ^{
       [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:encodedUrl] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
        });
        
        
        return cell;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionViewPlaylistsCover) {
        
        if (indexPath.section == 0){
            return CGSizeMake(100, 100);
        }
        
    }
    else {
        
        if (indexPath.section == 0){
            //return CGSizeMake(135, 135);
        }
        CGSize deviceSize = [UIScreen mainScreen].bounds.size;
        CGFloat flexSize = sqrt((double)(deviceSize.width * deviceSize.height) / ((double)(10)));
        
        return CGSizeMake(flexSize, flexSize);
        
    }
    
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionViewPlaylistsCover) {
        
        NSIndexPath *iPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
        layerZ = layerZ +1;
        [self.collectionViewPlaylistsCover cellForItemAtIndexPath:iPath].layer.zPosition = layerZ;
        
        [self.collectionViewPlaylistsCover setNeedsDisplay];
        
        if ( self.collectionViewPlaylistsCover.selectedIndex < 10 )
        {
            self.collectionViewPlaylistsCover.selectedIndex = indexPath.row;
        }
        
    }
    
    else if (collectionView == self.collectionViewPlaylists) {
        [self performSegueWithIdentifier:@"player" sender:[collectionView cellForItemAtIndexPath:indexPath]];
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"player"]) {
        PlaylistCell * cell = (PlaylistCell *)sender;
        
        NSIndexPath * indexPath = [self.collectionViewPlaylists indexPathForCell:cell];

        NSString* categoryID = self.otherPlaylistData[indexPath.row][@"category"];
        
        NSString* albumID = self.otherPlaylistData[indexPath.row][@"album_id"];
        NSString* albumName = self.otherPlaylistData[indexPath.row][@"name"];
        AlbumDetail * vc = segue.destinationViewController;
        vc.albumID = albumID;
        vc.genreID = categoryID;
        vc.albumImage = cell.coverImage.image;
        vc.isfromNowStreaming=YES;
        vc.albumName=albumName;
        
        
    }
}



@end
