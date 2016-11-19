//
//  WallFeedViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/16/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "WallFeedViewController.h"
#import "WallFeedCell.h"
#import "SWRevealViewController.h"
#import "PlaylistCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AlbumDetail.h"
#import "BAAlertController.h"
#import "HotBoxNotification.h"
#import "WallFeedStatusCell.h"
#import "SVProgressHUD.h"

@interface WallFeedViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,WallFeedStatusCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UIImageView *artistCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *artistCityCountryTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sideBarButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewAlbums;

@property UIImagePickerController * imagePicker;

@property NSArray * dataCollectionView;
@property NSDictionary * data;
@property NSArray <NSString *> * imageURLs;

@property NSMutableDictionary * selectedArtist;

@end

@implementation WallFeedViewController

- (IBAction)search:(UIButton *)sender {
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.artistImageView.layer.cornerRadius = 40.0f;
    self.artistImageView.clipsToBounds = YES;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WallFeedCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.collectionViewAlbums registerNib:[UINib nibWithNibName:@"PlaylistCell" bundle:nil] forCellWithReuseIdentifier:@"Playlist"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WallFeedStatusCell" bundle:nil] forCellReuseIdentifier:@"StatusCell"];
    
    self.data  = @{};
    self.dataCollectionView = @[];
    
    [self loadWallFeedData];
    
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.delegate = self;

    
}

-(void)loadWallFeedData {
    
    [self showProgressHUD];
    
    [WebAPI getNewArtistWallFeedsWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            
            if (data) {
                
                NSDictionary * temp = (NSDictionary *)data;
                if ([temp.allKeys containsObject:@"msg"]) return;
                
                self.data = temp;
                NSArray * details = self.data[@"detail"];
                
                if (self.selectedArtist == nil) {
                    
                    if (details.count > 0) {
                        
                        self.selectedArtist = [[NSMutableDictionary alloc]init];
                        
                        int r = arc4random_uniform((u_int32_t)details.count);
                        NSDictionary * artist = details[r];
                        
                        
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
                            
                            
                            
                        });
                        self.artistNameTextField.text = [NSString stringWithFormat:@"%@ %@",self.selectedArtist[@"firstname"],self.selectedArtist[@"lastname"]];
                        self.artistCityCountryTextField.text = [NSString stringWithFormat:@"%@, %@",self.selectedArtist[@"city"],self.selectedArtist[@"country"]];
                        
                        [self.artistImageView sd_setImageWithURL:[NSURL URLWithString:logoURL] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
                        [self.artistCoverImageView sd_setImageWithURL:[NSURL URLWithString:coverURL] placeholderImage:[UIImage imageNamed:@"sampleImage.jpg"]];
                    }
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHUB];
                    [self.tableView reloadData];
                });
                
            }
            
        }
        
        else {
            
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
            
        }
    }];
}
-(void)likePostWithPostId:(NSString*)postID andUserId:(NSString*)userID
{
    [SVProgressHUD show];
        [WebAPI addLikeToPost:postID  andUserId:(NSString *)userID WithCompletionHandler:^(BOOL error, NSArray *responseData) {
            if (responseData){
                
                if ([responseData isKindOfClass:[NSDictionary class]]) {
                    if ( [((NSDictionary *)responseData).allKeys containsObject:@"msg"] ){
                        [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                        [self performSelectorOnMainThread:@selector(showSuccessAlert1:) withObject:@"Thanks for your feedback" waitUntilDone:NO];
                        [SVProgressHUD dismiss];
                        [_collectionViewAlbums reloadData];
                        return;
                    }
                }
                
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                
            }
            
            else {
                [SVProgressHUD dismiss];
                [self performSelectorOnMainThread:@selector(showErrorAlert1:) withObject:@"Error connecting to server" waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                
            }
            
            
        }];

    
    
}
- (NSString *)base64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
-(void)postCommentWithMessage:(NSString*)msg andPostImage:(UIImage*)image
{
    
    if (msg != nil || image != nil
        ){
        [SVProgressHUD show];
    [WebAPI addPostWithMessage:msg andPostImage:[self base64String:image] WithCompletionHandler:^(BOOL error, NSArray *responseData) {
        if (responseData){
            
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                if ( [((NSDictionary *)responseData).allKeys containsObject:@"msg"] ){
                    [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    [self performSelectorOnMainThread:@selector(showSuccessAlert1:) withObject:@"Thanks for your interaction" waitUntilDone:NO];
                    [SVProgressHUD dismiss];
                    [_collectionViewAlbums reloadData];
                    return;
                }
            }
            
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            
        }
        
        else {
            [SVProgressHUD dismiss];
            [self performSelectorOnMainThread:@selector(showErrorAlert1:) withObject:@"Error connecting to server" waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            
        }
        
        
    }];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Enter message or image." waitUntilDone:NO];
    }
    
    
}
-(void)unlikePostWithPostId:(NSString*)postID andUserId:(NSString*)userID
{
    [SVProgressHUD show];
    [WebAPI addLikeToPost:postID  andUserId:(NSString *)userID WithCompletionHandler:^(BOOL error, NSArray *responseData) {
        if (responseData){
            
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                if ( [((NSDictionary *)responseData).allKeys containsObject:@"msg"] ){
                    [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    [self performSelectorOnMainThread:@selector(showSuccessAlert1:) withObject:@"Thanks for your feedback" waitUntilDone:NO];
                    [SVProgressHUD dismiss];
                    [_collectionViewAlbums reloadData];
                    return;
                }
            }
            
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            
        }
        
        else {
            [SVProgressHUD dismiss];
            [self performSelectorOnMainThread:@selector(showErrorAlert1:) withObject:@"Error connecting to server" waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            
        }
        
        
    }];
    
    
    
}
-(void)deleteCommentWithId:(NSString*)postID andUserId:(NSString*)userID
{
    [SVProgressHUD show];
    [WebAPI deleteCommentWithUserId:postID  andUserId:(NSString *)userID WithCompletionHandler:^(BOOL error, NSArray *responseData) {
        if (responseData){
            
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                if ( [((NSDictionary *)responseData).allKeys containsObject:@"msg"] ){
                    [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    [self performSelectorOnMainThread:@selector(showSuccessAlert1:) withObject:@"Thanks for your feedback" waitUntilDone:NO];
                    [SVProgressHUD dismiss];
                    [_collectionViewAlbums reloadData];
                    return;
                }
            }
            
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            
        }
        
        else {
            [SVProgressHUD dismiss];
            [self performSelectorOnMainThread:@selector(showErrorAlert1:) withObject:@"Error connecting to server" waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            
        }
        
        
    }];
    
    
    
}
#pragma mark - helper methods

-(void)showSuccessAlert1:(NSString *)text {
    NSAttributedString * message = [[NSAttributedString alloc] initWithString:text];
    [[HotBox sharedInstance]showMessage:message ofType:kAlertSuccess withDelegate:nil duration:3];
    
}

-(void)showInfoAlert1:(NSString *)text {
    NSAttributedString * message = [[NSAttributedString alloc] initWithString:text];
    [[HotBox sharedInstance]showMessage:message ofType:kAlertWarning withDelegate:nil duration:3];
}

-(void)showErrorAlert1:(NSString*)text{
    NSAttributedString * message = [[NSAttributedString alloc] initWithString:text];
    [[HotBox sharedInstance]showMessage:message ofType:kAlertError withDelegate:nil duration:3];
}

//-(void)likePostWithPostId:(NSString*)postID
//{
//    if (self.eventNameTextField.text != nil &&
//        ![self.eventNameTextField.text isEqualToString:@""] &&
//        self.locationTextField.text != nil &&
//        ![self.locationTextField.text isEqualToString:@""] &&
//        self.locationTextField.text != nil &&
//        ![self.locationTextField.text isEqualToString:@""] &&
//        self.selectedImage != nil &&
//        ![self.startDateButton.titleLabel.text isEqualToString:@"Select Date"] &&
//        ![self.endDateButton.titleLabel.text isEqualToString:@"Select Date"]
//        ){
//        NSString * eventID = self.selectedEvent[@"event_id"];
//        [WebAPI updateEventWithEventID:eventID name:self.eventNameTextField.text eventDescription:self.descriptionTextField.text location:self.locationTextField.text startDate:self.startDateButton.titleLabel.text endDate:self.endDateButton.titleLabel.text image: [self base64String:self.selectedImage]  CompletionHandler:^(BOOL error, NSArray *responseData) {
//            if (responseData){
//                
//                if ([responseData isKindOfClass:[NSDictionary class]]) {
//                    if ( [((NSDictionary *)responseData).allKeys containsObject:@"msg"] ){
//                        [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
//                        return;
//                    }
//                }
//                
//                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
//                [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Event Updated Successfully" waitUntilDone:NO];
//                
//            }
//            
//            else {
//                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
//                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
//            }
//            
//            
//        }];
//    }
//    else
//    {
//        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"All fields must be filled." waitUntilDone:NO];
//    }
//    
//
//}
#pragma mark - Table View

-(void)reloadTableViewData {
    [self.tableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.data.allKeys.count == 0) return 0;
    
    return ((NSArray *)self.data[@"waal_posts"]).count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row ==0 ) {
        WallFeedStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
        
        if (cell==nil) {
            cell = [[WallFeedStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StatusCell"];
        }
        cell.delegate = self;
        
        return cell;
        
    }
    
    else {
        WallFeedCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            
            cell = [[WallFeedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        
        NSDictionary * data = self.data[@"waal_posts"][indexPath.row];
        
        NSString * userID = data[@"user_id"];
        NSString * userName = @"";
        
        for (NSDictionary * d in self.data[@"detail"]) {
            if([d[@"artist_id"] isEqualToString:userID]) {
                userName = d[@"username"];
                break;
            }
        }
        
        
        NSArray * likes = self.data[@"likes"];
        for (NSDictionary * l in likes) {
            
        }
        
        cell.artistNameTextField.text = userName;
        cell.dateTextField.text = data[@"created_date"];
        cell.comentsLbl.text=[NSString stringWithFormat:@"%@ Comments",data[@"num_comments"]];
        cell.numberOfLikesTF.text=[NSString stringWithFormat:@"%@ Likes",data[@"num_likes"]];
        NSString * text = data[@"text"];
        
        text = [text stringByReplacingOccurrencesOfString:@"<button class=\"shopping-cart shopping-cart-home\" type=\"submit\" name=\"add_to_cart\"><i class=\"fa fa-shopping-cart\"></i></button>" withString:@""];
        
        [cell.contentWebView loadHTMLString:text baseURL:[NSURL URLWithString:@""]];
        cell.contentWebView.scrollView.scrollEnabled = NO;
        cell.likeButton.tag=indexPath.row;
        cell.unlikebtn.tag=indexPath.row;
        cell.commentsButton.hidden=YES;     /////.tag=indexPath.row;
        cell.delegate=self;
        
        return cell;
    }
}
-(void)likeBtnPressedWithTag:(int)tag {
    WallFeedCell * cell = (WallFeedCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    NSDictionary * data = self.data[@"waal_posts"][tag];
    [self likePostWithPostId:[data valueForKey:@"wp_id"] andUserId:[data valueForKey:@"user_id"]];
}
-(void)unlikeBtnPressedWithTag:(int)tag {
    WallFeedCell * cell = (WallFeedCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    NSDictionary * data = self.data[@"waal_posts"][tag];
    [self unlikePostWithPostId:[data valueForKey:@"wp_id"] andUserId:[data valueForKey:@"user_id"]];
}
-(void)comntBtnPressedWithTag:(int)tag {
//    WallFeedCell * cell = (WallFeedCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    NSDictionary * data = self.data[@"waal_posts"][tag];
    [self deleteCommentWithId:[data valueForKey:@"wp_id"] andUserId:[data valueForKey:@"user_id"]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 250;
    }
    else {
        return 357;
    }
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
        [cell.coverImage sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[indexPath.row]] placeholderImage:[self imageFromColor:[UIColor blackColor]]];
    }
    
    cell.titleLabel.text = self.dataCollectionView[indexPath.row][@"name"];
    cell.subtitleLabel.text = @"";
   
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"player" sender:[self.collectionViewAlbums cellForItemAtIndexPath:indexPath]];
}


#pragma mark - POST STATUS

-(void)postButtonPressed:(NSString *)text {
    NSLog(@"POST TEXT: %@",text);
    if (_selectedImage) {
        
    }
    else
    {
        _selectedImage=[UIImage imageNamed:@"sampleImage.jpg"];
    }
    [self postCommentWithMessage:text andPostImage:_selectedImage];
}

-(void)selectImageButtonPressed {
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * pickedImage = (UIImage *) info[UIImagePickerControllerOriginalImage];
    _selectedImage=pickedImage;
    if (pickedImage) {
        
    }
    else
    {
        _selectedImage=[UIImage imageNamed:@"sampleImage.jpg"];
    }
    
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

@end
