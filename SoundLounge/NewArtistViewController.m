//
//  WallFeedViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/12/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "NewArtistViewController.h"
#import "WallFeedCell.h"
#import "SWRevealViewController.h"
#import "PlaylistCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AlbumDetail.h"


@interface NewArtistViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UIImageView *artistCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *artistCityCountryTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sideBarButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewAlbums;

@property NSArray * dataCollectionView;
@property NSDictionary * data;
@property NSArray <NSString *> * imageURLs;

@property NSMutableDictionary * selectedArtist;
@property NSMutableDictionary * selectedArtistArrSpecificID;



@end

@implementation NewArtistViewController

- (IBAction)search:(UIButton *)sender {
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
//    User * user = [LocalStorage getCurrentSavedUser];
//    NSLog(@"Saved User ID: %@ name %@",user.userID,user.userName);
//    NSLog(@"Saved user type: %@",[LocalStorage getSaveUserType]== kUserTypeArtist ? @"artist":@"listener");
//    _artistNameTextField.text=user.userName;
    
    if (sender.selectedSegmentIndex == 0) {
        self.collectionViewAlbums.hidden = YES;
        self.tableView.hidden = NO;
        [self loadWallFeedData];
    }
    else {
        self.tableView.hidden = YES;
        self.collectionViewAlbums.hidden = NO;
        [self loadAlbumsData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.sideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }


}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"new artist id %ld",(long)_selectedArtistIdFrmTrendingView);
    self.artistImageView.layer.cornerRadius = self.artistImageView.bounds.size.width/2.0;
    self.artistImageView.clipsToBounds = YES;
    //if (!_isFromSearchView) {
        [self loadLatestAlbumsData];
//    }
//    else
//    {
//    }
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.sideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WallFeedCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.collectionViewAlbums registerNib:[UINib nibWithNibName:@"PlaylistCell" bundle:nil] forCellWithReuseIdentifier:@"Playlist"];
    
    self.data  = @{};
    self.dataCollectionView = @[];
    if (_selectedArtistIdFrmTrendingView>0) {
        [self segmentedControlValueChanged:self.segmentedControl];
    }
    else
    {
        [self segmentedControlValueChanged:self.segmentedControl];
    }
    _tableView.hidden=YES;
    _collectionViewAlbums.hidden=YES;
    _segmentedControl.hidden=YES;
    _checkINdexForDD=NO;
}
-(void)loadFollowAlbumsData {
   // [self showProgressHUD];
    
    [WebAPI getFollowArtistAlbumsWithArtistId:_artist_idFOrAlbum  CompletionHandler:^(BOOL error, NSArray *data) {
        if (!error) {
            if (data) {
                NSString* check=[data valueForKey:@"msg"];
                if ([check isEqualToString:@"TRUE"]) {
                   // _followBtn.titleLabel.text=@"UnFollow";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_followBtn setTitle:@"UnFollow" forState:UIControlStateNormal];
                    });
                }
                else
                {
                    //_followBtn.titleLabel.text=@"Follow";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_followBtn setTitle:@"Follow" forState:UIControlStateNormal];
                    });
                }
//                NSDictionary * temp = (NSDictionary *)data;
//                // if ([temp.allKeys containsObject:@"msg"]) return;
//                int r = arc4random_uniform((u_int32_t)data.count);
//                NSDictionary * artist = data[r];
                
                
                
            }
            else
            {
              
                
            }
            
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressHUB];
                [self showErrorAlert:kError_Network];
            });
        }
    }];
    
    
}
-(void)loadWallFeedData {
    
    [self showProgressHUD];
    
    [WebAPI getNewArtistWallFeedsWithArtistID:_artist_idFOrAlbum   WithCompletionHandler:^(BOOL isError, NSArray *data)
    {
        if (!isError)
        {
            
            if (data)
            {
                
                NSDictionary * temp = (NSDictionary *)data;
                if ([temp.allKeys containsObject:@"msg"]) return;
                
                self.data = temp;
                NSArray * details =(self.data[@"detail"] != [NSNull null]) ? _data[@"detail"] : @[];
                
                if (_selectedArtistIdFrmTrendingView>0)
                {
                    if (self.selectedArtist == nil)
                    {
                        if (details.count > 0)
                        {
                            self.selectedArtist = [[NSMutableDictionary alloc]init];
                            
                            int r = arc4random_uniform((u_int32_t)details.count);
                            NSMutableDictionary * artistother=[[NSMutableDictionary alloc] init];
                            for (NSMutableDictionary *artist in details) {
                                NSInteger artistIdGet=[artist[@"artist_id"] integerValue];
                                
                                NSLog(@"%ld check ",(long)artistIdGet);
                            if(_selectedArtistIdFrmTrendingView==artistIdGet)
                                {
                                    self.selectedArtist[@"username"] = artist[@"username"];
                                    self.selectedArtist[@"firstname"] = artist[@"firstname"];
                                    self.selectedArtist[@"lastname"] = artist[@"lastname"];
                                    self.selectedArtist[@"city"] = artist[@"city"];
                                    self.selectedArtist[@"country"] = artist[@"country"];
                                    
                                    
                                    NSString * dirName = artist[@"dir_name"];
                                    
                                    NSString * logo = @"";
                                    NSString * cover = @"";
                                    
                                    NSString * logoURL = @"";
                                    NSString * coverURL = @"";
                                    
                                    if (artist[@"logo"] != [NSNull null]){
                                        NSString * logoString = artist[@"logo"];
                                        NSData * data = [logoString dataUsingEncoding:NSUTF8StringEncoding];
                                        
                                        if (data!=nil) {
                                            NSArray * logoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                            logo = (logoArray.count > 0 && logoArray.count < 2) ? logoArray[1] : logoArray [0];
                                            if (logoArray.count > 1) {
                                                logo=[logoArray objectAtIndex:logoArray.count-1];
                                                NSLog(@"%@ my logo",logo);
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                    if (artist[@"cover"] != [NSNull null])
                                    {
                                        NSString * coverString = artist[@"cover"];
                                        NSData * data = [coverString dataUsingEncoding:NSUTF8StringEncoding];
                                        
                                        if (data!=nil) {
                                            NSArray * coverArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                            cover = coverArray.count == 1 ? coverArray[0] : coverArray[0];
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    if (![logo isEqualToString:@""]) {
                                        logoURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/photos/artist/%@/logo/%@",dirName,logo];
                                        NSLog(@"LOGO URL: %@",logoURL);
                                    }
                                    
                                    if (![cover isEqualToString:@""]) {
                                        coverURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/photos/artist/%@/cover/%@",dirName,cover];
                                        NSLog(@"COVER URL: %@",coverURL);
                                    }
                                    
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
//                                        self.artistNameTextField.text = [NSString stringWithFormat:@"%@",self.selectedArtist[@"username"]];
//                                        self.artistCityCountryTextField.text = [NSString stringWithFormat:@"%@, %@",self.selectedArtist[@"city"],self.selectedArtist[@"country"]];
//                                        
                                       // [self.artistImageView sd_setImageWithURL:[NSURL URLWithString:logoURL] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
                                      //  [self.artistCoverImageView sd_setImageWithURL:[NSURL URLWithString:coverURL] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
                                        
                                    });
                                    break;
                                }
                                else
                                {
                                    NSLog(@"not found data");
                                }
                            }     
                            
                        }
                        
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideProgressHUB];
                        [self.tableView reloadData];
                    });
                }
                else
                {
                    if (self.selectedArtist == nil) {
                        
                        if (details.count > 0) {
                            
                            self.selectedArtist = [[NSMutableDictionary alloc]init];
                            
                            int r = arc4random_uniform((u_int32_t)details.count);
                            NSDictionary * artist = details[r];
                            
                            self.selectedArtist[@"username"] = artist[@"username"];
                            self.selectedArtist[@"firstname"] = artist[@"firstname"];
                            self.selectedArtist[@"lastname"] = artist[@"lastname"];
                            self.selectedArtist[@"city"] = artist[@"city"];
                            self.selectedArtist[@"country"] = artist[@"country"];
                            
                            
                            NSString * dirName = artist[@"dir_name"];
                            
                            NSString * logo = @"";
                            NSString * cover = @"";
                            
                            NSString * logoURL = @"";
                            NSString * coverURL = @"";
                            
                            if (artist[@"logo"] != [NSNull null]){
                                NSString * logoString = artist[@"logo"];
                                NSData * data = [logoString dataUsingEncoding:NSUTF8StringEncoding];
                                
                                if (data!=nil) {
                                    NSArray * logoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                    logo = (logoArray.count > 0 && logoArray.count < 2) ? logoArray[0] : logoArray [0];
                                    if (logoArray.count > 1) {
                                        logo=[logoArray objectAtIndex:logoArray.count-1];
                                        NSLog(@"%@ my logo",logo);
                                    }
                                }
                                
                                
                            }
                            
                            if (artist[@"cover"] != [NSNull null]){
                                NSString * coverString = artist[@"cover"];
                                NSData * data = [coverString dataUsingEncoding:NSUTF8StringEncoding];
                                
                                if (data!=nil) {
                                    NSArray * coverArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                    cover = coverArray.count == 1 ? coverArray[0] : coverArray[0];
                                    
                                }
                                
                                
                            }
                            
                            if (![logo isEqualToString:@""]) {
                                logoURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/photos/artist/%@/logo/%@",dirName,logo];
                                NSLog(@"LOGO URL: %@",logoURL);
                            }
                            
                            if (![cover isEqualToString:@""]) {
                                coverURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/photos/artist/%@/cover/%@",dirName,cover];
                                NSLog(@"COVER URL: %@",coverURL);
                            }
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
//                                self.artistNameTextField.text = [NSString stringWithFormat:@"%@",self.selectedArtist[@"username"]];
//                                self.artistCityCountryTextField.text = [NSString stringWithFormat:@"%@, %@",self.selectedArtist[@"city"],self.selectedArtist[@"country"]];
                                
                               // [self.artistImageView sd_setImageWithURL:[NSURL URLWithString:logoURL] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
                               // [self.artistCoverImageView sd_setImageWithURL:[NSURL URLWithString:coverURL] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
                                
                            });
                            
                        }
                        
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideProgressHUB];
                        [self.tableView reloadData];
                    });
                    
                }
                

            }

        }
        
        else {
            
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
            
        }
    }];
}
-(void)loadLatestAlbumsData {
    [self showProgressHUD];

        [WebAPI getLatestArtistAlbumsWithCompletionHandler:^(BOOL error, NSArray *data) {
            if (!error) {
                if (data) {
                    NSDictionary * temp = (NSDictionary *)data;
                   // if ([temp.allKeys containsObject:@"msg"]) return;
                    int r = arc4random_uniform((u_int32_t)data.count);
                    NSDictionary * artist;
                    BOOL check=NO;
                    if (_selectedArtistIdFrmTrendingView) {
                        for (int i=0; i<temp.count; i++) {
                            if ([[temp valueForKey:@"artist_id"] objectAtIndex:i] ==_artist_idFOrAlbum) {
                                artist = data[i];
                                check=YES;
                                break;
                            }
                        }
                        
                    }
                    else
                    {
                        artist = data[r];
                    }
                    if (!check) {
                        artist = data[r];
                    }
                    _artist_idFOrAlbum=artist[@"artist_id"];
                    
                    NSString * dirName = artist[@"dir_name"];
                    
                    NSString * logo = @"";
                    NSString * cover = @"";
                    
                    NSString * logoURL = @"";
                    NSString * coverURL = @"";
                    
                    if (artist[@"logo"] != [NSNull null]){
                        NSString * logoString = artist[@"logo"];
                        NSData * data = [logoString dataUsingEncoding:NSUTF8StringEncoding];
                        
                        if (data!=nil) {
                            NSArray * logoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                            logo = (logoArray.count > 0 && logoArray.count < 2) ? logoArray[1] : logoArray [0];
                            if (logoArray.count > 1) {
                                logo=[logoArray objectAtIndex:logoArray.count-1];
                                NSLog(@"%@ my logo",logo);
                            }
                        }
                        
                        
                    }
                    
                    if (artist[@"cover"] != [NSNull null])
                    {
                        NSString * coverString = artist[@"cover"];
                        NSData * data = [coverString dataUsingEncoding:NSUTF8StringEncoding];
                        
                        if (data!=nil) {
                            NSArray * coverArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                            cover = coverArray.count == 1 ? coverArray[0] : coverArray[0];
                            
                        }
                        
                        
                    }
                    
                    if (![logo isEqualToString:@""]) {
                        logoURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/photos/artist/%@/logo/%@",dirName,logo];
                        NSLog(@"LOGO URL: %@",logoURL);
                    }
                    
                    if (![cover isEqualToString:@""]) {
                        coverURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/photos/artist/%@/cover/%@",dirName,cover];
                        NSLog(@"COVER URL: %@",coverURL);
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _artistNameTextField.text=artist[@"username"];
                        _artistCityCountryTextField.text=[NSString stringWithFormat:@"%@,%@",artist[@"city"],artist[@"country"]];
                        _followersLbl.text=[NSString stringWithFormat:@"%@ followers",artist[@"followers"]];
                        _emaillbl.text=[NSString stringWithFormat:@"%@",artist[@"email"]];
                        _totalsongs.text=[NSString stringWithFormat:@"%@ songs",artist[@"music"]];
                        [self.artistImageView sd_setImageWithURL:[NSURL URLWithString:logoURL] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
                        [self.artistCoverImageView sd_setImageWithURL:[NSURL URLWithString:coverURL] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
                        
                    });
                    [self loadFollowAlbumsData];
                }
                else
                {
                    _artistNameTextField.text=@"";
                    //_artist_idFOrAlbum=artist[@"artist_id"];
                    _artistCityCountryTextField.text=@"";
                    
                }
                
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHUB];
                    [self showErrorAlert:kError_Network];
                });
            }
        }];
    
   
}


-(void)loadAlbumsData {
    [self showProgressHUD];
    if (_selectedArtistIdFrmTrendingView>0)
    {
        [WebAPI getNewArtistAlbumsWithArtistID:[NSString stringWithFormat:@"%ld", (long)_selectedArtistIdFrmTrendingView] WithCompletionHandler:^(BOOL error, NSArray *data) {
            if (!error) {
                if (data) {
                    NSDictionary * temp = (NSDictionary *)data;
                    if ([temp.allKeys containsObject:@"msg"]) return;
                    
                    self.dataCollectionView =([data valueForKey:@"albums"] != [NSNull null]) ? [data valueForKey:@"albums"] : @[];
                    NSMutableArray * imageURLs = [[NSMutableArray alloc]init];
                    
                    for (NSDictionary * tempData in self.dataCollectionView) {
                        NSString * dirName = tempData[@"dir_name"];
                        NSString * albumName = tempData[@"name"];
                        
                        NSString * logo = @"";
                        
                        NSString * url = @"";
                        
                        if (tempData[@"logo"] != [NSNull null]){
                            NSString * logoString = tempData[@"logo"];
                            NSData * data = [logoString dataUsingEncoding:NSUTF8StringEncoding];
                            
                            if (data!=nil) {
                                NSArray * logoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                logo = (logoArray.count > 0 && logoArray.count < 2) ? logoArray[1] : logoArray [0];
                            }
                            
                            
                        }
                        
                        if (![logo isEqualToString:@""]) {
                            url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/logo/%@",dirName,albumName,logo];
                            NSLog(@"URL: %@",url);
                        }
                        
                        [imageURLs addObject:url];
                        
                    }
                    _imageURLs=imageURLs;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionViewAlbums reloadData];
                        
                    });
                    
                }
                
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHUB];
                    [self showErrorAlert:kError_Network];
                });
            }
        }];

    }
    else
    {
        [WebAPI getNewArtistAlbumsWithArtistID:_artist_idFOrAlbum WithCompletionHandler:^(BOOL error, NSArray *data) {
            if (!error) {
                if (data) {
                    NSDictionary * temp = (NSDictionary *)data;
                    if ([temp.allKeys containsObject:@"msg"]) return;
                    
                    self.dataCollectionView =([data valueForKey:@"albums"] != [NSNull null]) ? [data valueForKey:@"albums"] : @[];
                    NSMutableArray * imageURLs = [[NSMutableArray alloc]init];
                    
                    for (NSDictionary * tempData in self.dataCollectionView) {
                        NSString * dirName = tempData[@"dir_name"];
                        NSString * albumName = tempData[@"name"];
                        
                        NSString * logo = @"";
                        
                        NSString * url = @"";
                        
                        if (tempData[@"logo"] != [NSNull null]){
                            NSString * logoString = tempData[@"logo"];
                            NSData * data = [logoString dataUsingEncoding:NSUTF8StringEncoding];
                            
                            if (data!=nil) {
                                NSArray * logoArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                logo = (logoArray.count > 0 && logoArray.count < 2) ? logoArray[1] : logoArray [0];
                            }
                            
                            
                        }
                        
                        if (![logo isEqualToString:@""]) {
                            url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/logo/%@",dirName,albumName,logo];
                            NSLog(@"URL: %@",url);
                        }
                        
                        [imageURLs addObject:url];
                        
                    }
                    _imageURLs=imageURLs;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionViewAlbums reloadData];
                        
                    });
                    
                }
                
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHUB];
                    [self showErrorAlert:kError_Network];
                });
            }
        }];

        
    }
}

#pragma mark - Table View

-(void)reloadTableViewData {
    [self.tableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.data.allKeys.count == 0) return 0;
    if ((self.data[@"waal_posts"] != [NSNull null])) {
        return ((NSArray *)self.data[@"waal_posts"]).count;
    }else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WallFeedCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[WallFeedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    NSLog(@"%@ data",self.data);
    NSDictionary * data = self.data[@"waal_posts"][indexPath.row];
    
    NSString * userID = data[@"user_id"];
    NSString * userName = @"";
    NSString * artistID = @"";
    for (NSDictionary * d in self.data[@"detail"]) {
        if([d[@"artist_id"] isEqualToString:userID]) {
            userName = d[@"username"];
            artistID=d[@"artist_id"];
            break;
        }
    }
    
     //cell.artistNameTextField.text = userName;
    cell.dateTextField.text = data[@"created_date"];
    //_artist_idFOrAlbum=artistID;
    NSString * text = data[@"text"];
    
    text = [text stringByReplacingOccurrencesOfString:@"<button class=\"shopping-cart shopping-cart-home\" type=\"submit\" name=\"add_to_cart\"><i class=\"fa fa-shopping-cart\"></i></button>" withString:@""];
    
    [cell.contentWebView loadHTMLString:text baseURL:[NSURL URLWithString:@""]];
    cell.contentWebView.scrollView.scrollEnabled = NO;
    cell.likeButton.hidden = YES;
    cell.unlikebtn.hidden = YES;
    cell.commentsButton.hidden = YES;

     cell.comentsLbl.text=[NSString stringWithFormat:@"%@ Comments",data[@"num_comments"]];
    cell.numberOfLikesTF.text=[NSString stringWithFormat:@"%@ Likes",data[@"num_likes"]];
    return cell;
}


#pragma mark - Collection View

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataCollectionView.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlaylistCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Playlist" forIndexPath:indexPath];
    if ([self.imageURLs[indexPath.row] isEqualToString:@""]) {
        cell.coverImage.image = [self imageFromColor:[UIColor blackColor]];
    }
    else {
        NSLog(@"%@ IMageUrls",_imageURLs);
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[indexPath.row]] placeholderImage:[self imageFromColor:[UIColor blackColor]]];
    }
    
    cell.titleLabel.text = self.dataCollectionView[indexPath.row][@"name"];
    cell.subtitleLabel.text = @"";
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"player" sender:[self.collectionViewAlbums cellForItemAtIndexPath:indexPath]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"player"]) {
        AlbumDetail * vc = (AlbumDetail*)segue.destinationViewController;
        PlaylistCell * cell = (PlaylistCell *)sender;
        NSIndexPath * indexPath = [self.collectionViewAlbums indexPathForCell:cell];
        NSString * albumID = self.dataCollectionView[indexPath.row][@"album_id"];
        vc.albumImage = cell.coverImage.image;
        vc.albumID = albumID;
        
    }
}



- (IBAction)FollowBtnClicked:(id)sender {
    if ([_followBtn.titleLabel.text isEqualToString:@"UnFollow"]) {
        [self showProgressHUD];
        
        [WebAPI unFollowAlbumWithAlbumID:_artist_idFOrAlbum  CompletionHandler:^(BOOL error, NSArray *data) {
            if (!error) {
                if (data) {
                   // NSString* check=[data valueForKey:@"msg"];
                   // if ([check isEqualToString:@"TRUE"]) {
                      //  _followBtn.titleLabel.text=@"Follow";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_followBtn setTitle:@"Follow" forState:UIControlStateNormal];
                    });
//                    }
//                    else
//                    {
//                        _followBtn.titleLabel.text=@"UnFollow";
//                    }
                    
                }
                else
                {
                    
                    
                }
                
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHUB];
                    [self showErrorAlert:kError_Network];
                });
            }
        }];
        
        

    }
    else
    {
        [self showProgressHUD];
        
        [WebAPI FollowAlbumWithAlbumID:_artist_idFOrAlbum  CompletionHandler:^(BOOL error, NSArray *data) {
            if (!error) {
                if (data) {
                   // NSString* check=[data valueForKey:@"msg"];
                    //if ([check isEqualToString:@"TRUE"]) {
                       // _followBtn.titleLabel.text=@"UnFollow";
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_followBtn setTitle:@"UnFollow" forState:UIControlStateNormal];
                    });
//                    }
//                    else
//                    {
//                        _followBtn.titleLabel.text=@"Follow";
//                    }
                
                    
                    
                    
                }
                else
                {
                    
                    
                }
                
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHUB];
                    [self showErrorAlert:kError_Network];
                });
            }
        }];
        
    }
}
- (IBAction)dropDownBtnCLicked:(id)sender {
    if (_checkINdexForDD) {
        _tableView.hidden=YES;
        _collectionViewAlbums.hidden=YES;
        _segmentedControl.hidden=YES;
        _emaillbl.hidden=NO;
        _followersLbl.hidden=NO;
        _checkINdexForDD=NO;
        _totalsongs.hidden=NO;
    }
    else
    {
        _tableView.hidden=NO;
        _collectionViewAlbums.hidden=NO;
        _segmentedControl.hidden=NO;
        _emaillbl.hidden=YES;
        _followersLbl.hidden=YES;
        _totalsongs.hidden=YES;
        _checkINdexForDD=YES;
    }
}
@end
