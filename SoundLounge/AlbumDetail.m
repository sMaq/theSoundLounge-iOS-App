//
//  AlbumDetail.m
//  SoundLounge
//
//  Created by Apple on 30/04/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "AlbumDetail.h"
#import "SongsCell.h"
#import "PlayerViewController.h"
#import <Social/Social.h>
#import "NewArtistViewController.h"
@interface AlbumDetail ()<UIPopoverPresentationControllerDelegate,UIAdaptivePresentationControllerDelegate,SongsCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *albumCoverImageView;

@property NSArray * songsData;

@end

@implementation AlbumDetail
- (IBAction)search:(UIButton *)sender {
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _popUPVIew.hidden=YES;
    _popAlbumNameLbl.text=_albumName;
    [self.tableView registerNib:[UINib nibWithNibName:@"SongsCell" bundle:nil] forCellReuseIdentifier:@"AlbumDetail"];
    _albumnameLbl.text=_albumName;
    _albumNameLBltitle.text=_albumName;
    self.songsData = @[];
    
    if (self.albumID) {
        if (_isfromNowStreaming) {
            [self loadSongsFromServerFOrStreamings];
        }
        else
        {
            [self loadSongsFromServer];
            
        }
    }
    else if (self.genreID) {
        [self loadGenreSongsFromServer];
    }
    if (_isfromNowStreaming) {
        _profileBtn.hidden=YES;
        _heartbtn.hidden=YES;
        _shareBtn.hidden=YES;
    }
    else
    {
        _profileBtn.hidden=NO;
        _heartbtn.hidden=NO;
        _shareBtn.hidden=NO;
    }
    if (self.albumImage) {
        self.albumCoverImageView.image = self.albumImage;
    }
    [self getFavouriteAlbums];
    [self getFavouriteSongs];
}
-(void)getFavouriteSongs
{
    [WebAPI getFavoruiteSongsWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (data){
            //[self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Fetched Favourites Successfully" waitUntilDone:NO];
            if ([LocalStorage getSaveUserType] == kUserTypeArtist) {
                NSArray *datainArr=[data valueForKey:@"favorites"];
                for (int i=0; i<datainArr.count; i++)
                {
                    if ([[[datainArr valueForKey:@"music_id"] objectAtIndex:i] isEqualToString:_MusicID]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_heartBtnPop setImage:[UIImage imageNamed:@"favarit_mp.png"] forState:UIControlStateNormal];
                        });
                        break;
                    }
                    else
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_heartBtnPop setImage:[UIImage imageNamed:@"heart-1.png"] forState:UIControlStateNormal];
                        });
                    }
                }
            }
            else
            {
                for (int i=0; i<data.count; i++)
                {
                    NSArray *datainArr=[data valueForKey:@"favorites"];
                    if ([[[datainArr valueForKey:@"music_id"] objectAtIndex:i] isEqualToString:_MusicID]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_heartBtnPop setImage:[UIImage imageNamed:@"favarit_mp.png"] forState:UIControlStateNormal];
                        });
                        break;
                    }
                    else
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_heartBtnPop setImage:[UIImage imageNamed:@"heart-1.png"] forState:UIControlStateNormal];
                        });
                    }
                }
                
            }
          
            
            
        }
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
            
        }
    }];
    //
}
-(void)getFavouriteAlbums
{

    [WebAPI getFavoruiteAlbumsWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (data){
            //[self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Fetched Favourites Successfully" waitUntilDone:NO];
            if ([LocalStorage getSaveUserType] == kUserTypeArtist) {
                NSArray *datainArr=[data valueForKey:@"albums"];
                for (int i=0; i<datainArr.count; i++)
                {
                    if ([[[datainArr valueForKey:@"album_id"] objectAtIndex:i] isEqualToString:_albumID]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_heartbtn setImage:[UIImage imageNamed:@"favarit_mp.png"] forState:UIControlStateNormal];
                        });
                        break;
                    }
                    else
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_heartbtn setImage:[UIImage imageNamed:@"heart-1.png"] forState:UIControlStateNormal];
                        });
                    }
                }
            }
            else
            {
                for (int i=0; i<data.count; i++)
                {
                    if ([[[data valueForKey:@"album_id"] objectAtIndex:i] isEqualToString:_albumID]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_heartbtn setImage:[UIImage imageNamed:@"favarit_mp.png"] forState:UIControlStateNormal];
                        });
                        break;
                    }
                    else
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_heartbtn setImage:[UIImage imageNamed:@"heart-1.png"] forState:UIControlStateNormal];
                        });
                    }
                }
                
            }
            
            
            
        }
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
            
        }
    }];
   //
}
-(void)viewWillAppear:(BOOL)animated
{
    _albumCoverImageView.layer.cornerRadius = _albumCoverImageView.frame.size.width / 2;
    _albumCoverImageView.clipsToBounds = YES;

}
- (IBAction)addAlbumToFavourite:(UIButton *)sender {
    if ([_heartbtn.currentImage isEqual:[UIImage imageNamed:@"heart-1.png"]])
    {
       // [_heartbtn setImage:[UIImage imageNamed:@"heart-1.png"] forState:UIControlStateNormal];
        [WebAPI addFavouriteAlbumWithAlbumID:self.albumID completionHandler:^(BOOL isError, NSArray *data) {
            if (data){
                [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Added to Favourites Successfully" waitUntilDone:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                   [_heartbtn setImage:[UIImage imageNamed:@"favarit_mp.png"] forState:UIControlStateNormal];
                });
                
            }
            else {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
                
            }
        }];
    }
    else
    {
        
        //[_heartbtn setImage:[UIImage imageNamed:@"favarit_mp.png"] forState:UIControlStateNormal];
        [WebAPI deleteFavouriteAlbumWithAlbumID:self.albumID completionHandler:^(BOOL isError, NSArray *data) {
            if (data){
                [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Deleted From Favourites Successfully" waitUntilDone:NO];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_heartbtn setImage:[UIImage imageNamed:@"heart-1.png"] forState:UIControlStateNormal];
                });
            }
            else {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
                
            }
        }];
        
    }
    //do some thing here for your image1
    
    
}


-(void)loadGenreSongsFromServer {
    [self showProgressHUD];
    [WebAPI getSongsByAlbum:self.albumID CompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            if (data!=nil) {
                
                NSMutableArray * songs = [[NSMutableArray alloc]init];
                
                NSDictionary * temp = (NSDictionary * )data;
                NSArray * songsArray = temp[@"songs"];
                NSArray * artistsArray = temp[@"artists"];
                NSArray * genreArray = temp[@"genre"];
                
                for (NSDictionary * song in songsArray) {
                    NSString * artistID = song[@"artist_id"];
                    _artistID=artistID;
                    NSString * genreID = song[@"genre_id"];
                    NSString * artistName = @"";
                    
                    NSString * genreName = @"";
                    
                    for (NSDictionary * a in artistsArray) {
                        if ([a[@"artist_id"] isEqualToString:artistID]) {
                            artistName = [NSString stringWithFormat:@"%@ %@",a[@"firstname"],a[@"lastname"]];
                            break;
                        }
                    }
                    
                    for (NSDictionary * g in genreArray) {
                        if ([genreID isEqualToString:g[@"category_id"]]) {
                            genreName = g[@"name"];
                        }
                    }
                    
                    
                    [songs addObject:@[song,artistName,genreName]];
                    
                }
                
                self.songsData = songs;
                [self performSelectorOnMainThread:@selector(reloadTableViewData) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            }
        }
        else {
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
        }
    }];
}
-(void)loadSongsFromServerFOrStreamings {
    [self showProgressHUD];
    [WebAPI getSongsByAlbumForStreaming2:self.albumID CompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            if (data!=nil)
            {
                
                NSMutableArray * songs = [[NSMutableArray alloc]init];
                
                NSDictionary * temp = (NSDictionary * )data;
                NSArray * songsArray = temp[@"music"];
               // NSArray * artistsArray = temp[@"artists"];
                //NSArray * genreArray = temp[@"genre"];
                
                for (NSDictionary * song in songsArray)
                {
                    NSString * artistID = song[@"artist_id"];
                    NSString * genreID = song[@"genre_id"];
                    NSString * artistName = @"";
                    
                    NSString * genreName = @"";
                    
//                    for (NSDictionary * a in artistsArray) {
//                        if ([a[@"artist_id"] isEqualToString:artistID]) {
//                            artistName = [NSString stringWithFormat:@"%@ %@",a[@"firstname"],a[@"lastname"]];
//                            break;
//                        }
//                    }
//                    
//                    for (NSDictionary * g in genreArray) {
//                        if ([genreID isEqualToString:g[@"category_id"]]) {
//                            genreName = g[@"name"];
//                        }
//                    }
                    
                    
                    [songs addObject:@[song,artistName,genreName]];
                    
                }
                
                self.songsData = songs;
                [self performSelectorOnMainThread:@selector(reloadTableViewData) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            }
        }
        else {
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
        }
    }];
}
-(void)loadSongsFromServer {
    [self showProgressHUD];
    [WebAPI getSongsByAlbum:self.albumID CompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            if (data!=nil) {
                
                NSMutableArray * songs = [[NSMutableArray alloc]init];
                
                NSDictionary * temp = (NSDictionary * )data;
                NSArray * songsArray = temp[@"songs"];
                NSArray * artistsArray = temp[@"artists"];
                NSArray * genreArray = temp[@"genre"];
                
                for (NSDictionary * song in songsArray) {
                    NSString * artistID = song[@"artist_id"];
                    NSString * genreID = song[@"genre_id"];
                    NSString * artistName = @"";
                    
                    NSString * genreName = @"";
                    
                    for (NSDictionary * a in artistsArray) {
                        if ([a[@"artist_id"] isEqualToString:artistID]) {
                            artistName = [NSString stringWithFormat:@"%@ %@",a[@"firstname"],a[@"lastname"]];
                            break;
                        }
                    }
                    
                    for (NSDictionary * g in genreArray) {
                        if ([genreID isEqualToString:g[@"category_id"]]) {
                            genreName = g[@"name"];
                        }
                    }
                    
                    
                    [songs addObject:@[song,artistName,genreName]];
                    
                }
                
                self.songsData = songs;
                [self performSelectorOnMainThread:@selector(reloadTableViewData) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            }
        }
        else {
            [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
        }
    }];
}

-(void)reloadTableViewData {
    [self.tableView reloadData];
}

-(void)playButtonPressedWithTag:(int)tag {
    SongsCell * cell = (SongsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    [self performSegueWithIdentifier:@"showPlayer" sender:cell.playButton];
}

-(void)clockButtonPressedWithTag:(int)tag {
    SongsCell * cell = (SongsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    _popUPVIew.hidden=NO;
    _MusicID=self.songsData[tag][0][@"music_id"];
    if (self.songsData) {
        
        NSString * dirName = self.songsData[tag][0][@"dir_name"];
        NSString * fileName = self.songsData[tag][0][@"filename"];
        NSString * albumName = self.songsData[tag][0][@"album_name"];
        NSString * categoryID = self.songsData[tag][0][@"category_id"];
        
        _SongsName=fileName;
//        if (self.isTrending) {
//            
//            self.SongsUrlDownload = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/admin/media/%@/%@/music/%@",categoryID,albumName,fileName];
//        }
//        else {
            self.SongsUrlDownload = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/music/%@",dirName,albumName,fileName];
//        }
        
        NSLog(@"SONG URL:%@",self.SongsUrlDownload);
    }
   // [self albumDetailPopoverClicked:cell];
    
}


- (IBAction)backButtonPressed:(UIButton *)sender {
    if (_isfromSearch) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.songsData.count;
}

-(UITableViewCell * ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SongsCell * cell =[tableView dequeueReusableCellWithIdentifier:@"AlbumDetail"];
    
    if(!cell){
        cell = [[SongsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlbumDetail"];
    }
    
    NSArray * cellData = self.songsData[indexPath.row];
    
    cell.songTitle.text = cellData[0][@"name"];
    cell.songGenre.text = cellData[2];
    cell.artistName.text = cellData[1];
    cell.playButton.tag = indexPath.row;
    cell.clockButton.tag = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showPlayer" sender:self];
}

- (IBAction)albumDetailPopoverClicked:(id)sender {

    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *contentVC = [storyboard instantiateViewControllerWithIdentifier:@"AlbumDetailPopover"];

    contentVC.view.backgroundColor = [UIColor whiteColor];
    
    // Set your popover size.
    contentVC.preferredContentSize = CGSizeMake(260, 265);
    
    // Set the presentation style to modal so that the above methods get called.
    contentVC.modalPresentationStyle = UIModalPresentationPopover;
    // Set the popover presentation controller delegate so that the above methods get called.
    contentVC.popoverPresentationController.delegate = self;
    
    contentVC.popoverPresentationController.sourceView=self.view;
    contentVC.popoverPresentationController.permittedArrowDirections = 0;
    contentVC.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0);
    // Present the popover.
    [self presentViewController:contentVC animated:YES completion:nil]; // 19
    

}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{

    return UIModalPresentationNone;
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showPlayer"]) {
 
        PlayerViewController * playerVC = (PlayerViewController*)segue.destinationViewController;
        
        NSInteger index = ((UIButton *)sender).tag;
        
        playerVC.currentSongData = self.songsData[index];
        playerVC.allSongsArr=self.songsData;
        playerVC.coverImage = self.albumImage;
        playerVC.indexForward=index;
        playerVC.albumname=_albumName;
        if (_isfromNowStreaming) {
            playerVC.isStreamedSongs=YES;
        }
        else
        {
            playerVC.isTrending = self.genreID != nil ? YES : NO;
        }
        
        
    }
    else if ([segue.identifier isEqualToString:@"newArtist"]) {
        NewArtistViewController * vc = segue.destinationViewController;
        vc.selectedArtistIdFrmTrendingView = _artistID.integerValue;
        vc.artist_idFOrAlbum=_artistID;
    }
}

#pragma mark - Social

- (IBAction)shareButtonPressed:(UIButton *)sender {
    UIAlertController * shareAlert = [UIAlertController alertControllerWithTitle:@"Choose Social Network" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [shareAlert addAction:[UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self performSelectorOnMainThread:@selector(shareOnTwitter) withObject:nil waitUntilDone:NO];
        
    }]];
    
    [shareAlert addAction:[UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self performSelectorOnMainThread:@selector(shareOnFacebook) withObject:nil waitUntilDone:NO];
        
    }]];
    
    [shareAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:shareAlert animated:YES completion:nil];
    
    
}




-(void)shareOnTwitter {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    NSString * message = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/album/%@/music",_albumName];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:message];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        UIAlertController * error = [UIAlertController alertControllerWithTitle:@"Twitter Account Not Found" message:@"It seems that you have not configured twitter account with your iPhone. Please go to Settings and add twitter account details." preferredStyle:UIAlertControllerStyleAlert];
        [error addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [error addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:error animated:YES completion:nil];
        
        NSLog(@"twitter account not found");
    }
}

-(void)shareOnFacebook {
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    NSString * message = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/album/%@/music",_albumName];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:message];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else {
        UIAlertController * error = [UIAlertController alertControllerWithTitle:@"Facebook Account Not Found" message:@"It seems that you have not configured facebook account with your iPhone. Please go to Settings and add facebook account details." preferredStyle:UIAlertControllerStyleAlert];
        [error addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [error addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:error animated:YES completion:nil];
        NSLog(@"Facebook account not found");
    }
}


- (IBAction)profileBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"newArtist" sender:self];
}

- (IBAction)closeBtnClicked:(id)sender {
    _popUPVIew.hidden=YES;
}

- (IBAction)artistProfileBtnCLicked:(id)sender {
    
    [self performSegueWithIdentifier:@"newArtist" sender:self];
}

- (IBAction)addFavourites:(id)sender {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [WebAPI addFavouriteSongWithMusicID:_MusicID albumID:self.albumID completionHandler:^(BOOL isError, NSArray *data) {
//            if (data){
//                [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Added to Favourites Successfully" waitUntilDone:NO];
//            }
//            else {
//                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
//                
//            }
//        }];
//        
//    });
    if ([_heartBtnPop.currentImage isEqual:[UIImage imageNamed:@"heart-1.png"]])
    {
        // [_heartbtn setImage:[UIImage imageNamed:@"heart-1.png"] forState:UIControlStateNormal];
        [WebAPI addFavouriteSongWithMusicID:_MusicID albumID:self.albumID completionHandler:^(BOOL isError, NSArray *data) {
            if (data){
                [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Added to Favourites Successfully" waitUntilDone:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_heartBtnPop setImage:[UIImage imageNamed:@"favarit_mp.png"] forState:UIControlStateNormal];
                });
                
            }
            else {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
                
            }
        }];
    }
    else
    {
        
        //[_heartbtn setImage:[UIImage imageNamed:@"favarit_mp.png"] forState:UIControlStateNormal];
        [WebAPI deleteFavouriteSongWithMusicID:_MusicID albumID:self.albumID completionHandler:^(BOOL isError, NSArray *data) {
            if (data){
                [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Deleted From Favourites Successfully" waitUntilDone:NO];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_heartBtnPop setImage:[UIImage imageNamed:@"heart-1.png"] forState:UIControlStateNormal];
                });
            }
            else {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Error connecting to server" waitUntilDone:NO];
                
            }
        }];
        
    }
    
}

- (IBAction)shareBtnClicked:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self shareButtonPressed:sender];
        
    });
    
}
- (IBAction)downloadBtnClicked:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL  *url = [NSURL URLWithString:_SongsUrlDownload];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            //        NSString  *documentsDirectory = [paths objectAtIndex:0];
            //
            //        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,_SongsName];
            //        [urlData writeToFile:filePath atomically:YES];
            
            NSString *mp3FileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject]stringByAppendingPathComponent:_SongsName];
            //create the file
            [[NSFileManager defaultManager] createFileAtPath:mp3FileName contents:urlData attributes:nil];
            NSLog(@"song saved at %@",mp3FileName);
            
            
        }
        
    });
   
}

@end
