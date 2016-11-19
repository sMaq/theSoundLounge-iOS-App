//
//  PlayerViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/27/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "PlayerViewController.h"
#import <Social/Social.h>
#import "HysteriaPlayer.h"
#import "AppDelegate.h"
#import "AppSettings.h"
#define kPLAY @"playIcon-1"
#define kSTOP @"pause"

@import AVFoundation;

@interface PlayerViewController () <UITableViewDelegate,UITableViewDataSource,HysteriaPlayerDelegate, HysteriaPlayerDataSource>{
    BOOL isPlaying;
}

@property NSTimeInterval currentPlaybackTime;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *genreName;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *currentTrackTime;
@property NSString * songURL;

//@property AVPlayer * audioPlayer;

@property (nonatomic, strong) AppDelegate *appdel;
@property (nonatomic, strong) id timeObserver;

@end

@implementation PlayerViewController


#pragma mark - Sharing

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
    
    NSString * message = self.songURL;
    
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
    
    NSString * message = self.songURL;
    
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


#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];

  
}

/*

- (void)setupHyseteriaPlayer {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    HysteriaPlayer *hysteriaPlayer = [HysteriaPlayer sharedInstance];
    hysteriaPlayer.delegate = self;
    hysteriaPlayer.datasource = self;
    hysteriaPlayer.itemsCount = 1;
}


- (NSURL *)hysteriaPlayerURLForItemAtIndex:(NSInteger)index preBuffer:(BOOL)preBuffer {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return [NSURL URLWithString:self.songURL];
}

- (void)hysteriaPlayerReadyToPlay:(HysteriaPlayerReadyToPlay)identifier{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [[HysteriaPlayer sharedInstance] play];
}

-(void)hysteriaPlayerDidFailed:(HysteriaPlayerFailed)identifier error:(NSError *)error {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

*/
-(void)viewWillAppear:(BOOL)animated
{
    _appdel=[[AppDelegate alloc]init];
    _appdel=[[UIApplication sharedApplication] delegate];
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [_appdel setPlayer];
    [_appdel pauseSong];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:0 error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    //_appdel.isPlaying = YES;
    self.coverImageView.image = self.coverImage? self.coverImage : self.coverImageView.image;
    
    _indexBackward=_indexForward;
    NSLog(@"%@ current song data",_currentSongData);
    if (self.currentSongData) {
        NSString * dirName;
        NSString * fileName;
        NSString * albumName;
        NSString * categoryID;
        NSString *songName;
        if (_isStreamedSongs) {
            self.songName.text = [NSString stringWithFormat:@"%@",[[self.currentSongData  objectAtIndex:0] valueForKey:@"name"]];
            self.artistName.hidden=YES;
            self.genreName.hidden=YES;
            songName=[[self.currentSongData objectAtIndex:0]valueForKey:@"name"];
            categoryID = self.currentSongData[0][@"category_id"];
            //dirName = [self.currentSongData valueForKey: @"dir_name"];
            fileName = [[self.currentSongData objectAtIndex:0]valueForKey:@"filename"];
            albumName = _albumname;
        }
       else if (_isSearchedSongs) {
            self.songName.text = [self.currentSongData valueForKey:@"name"];
            self.artistName.hidden=YES;
            self.genreName.hidden=YES;
            
            dirName = [self.currentSongData valueForKey: @"dir_name"];
            fileName = [self.currentSongData valueForKey:@"filename"];
            albumName = [self.currentSongData valueForKey:@"album_name"];
        }
        else
        {
            self.songName.text = self.currentSongData[0][@"name"];
            self.artistName.text = self.currentSongData[1];
            self.genreName.text = self.currentSongData[2];
            
            dirName = self.currentSongData[0][@"dir_name"];
            fileName = self.currentSongData[0][@"filename"];
            albumName = self.currentSongData[0][@"album_name"];
            categoryID = self.currentSongData[0][@"category_id"];
        }
        
        
        
        if (self.isTrending) {
            
            self.songURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/admin/media/%@/%@/music/%@",categoryID,albumName,fileName];
        }
        else {
            
            if (_isStreamedSongs) {
               self.songURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/admin/media/%@/%@/%@/music/%@",categoryID,albumName,songName,fileName];
            }
            else
            {
                
                 self.songURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/music/%@",dirName,albumName,fileName];
            }
        }
        if (_isStreamedSongs) {
            self.songURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/admin/media/%@/%@/%@/music/%@",categoryID,albumName,songName,fileName];
        }
        else
        {
            
            self.songURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/music/%@",dirName,albumName,fileName];
        }
      NSString *urlstr1=  [self.songURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url1=[NSURL URLWithString:urlstr1];
        NSLog(@"SONG URL:%@",url1);
        
        /*
         
         self.audioPlayer = [[AVPlayer alloc]initWithPlayerItem:item];
         
         [self playButtonPressed:nil];
         */
        
        
        AVPlayerItem * item = [[AVPlayerItem alloc]initWithURL:url1];
        _appdel.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[_appdel.player currentItem]];
        // Set AVAudioSession
        NSError *sessionError = nil;
        [[AVAudioSession sharedInstance] setDelegate:self];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        // Change the default output audio route
        UInt32 doChangeDefaultRoute = 1;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                                sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
        
        NSArray *queue = @[item];
        
        _appdel.player = [[AVQueuePlayer alloc] initWithItems:queue];
        _appdel.player.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
        
        [_appdel.player addObserver:self
                      forKeyPath:@"currentItem"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
        void (^observerBlock)(CMTime time) = ^(CMTime time) {
            NSString *timeString = [NSString stringWithFormat:@"%02.2f", ((float)time.value / (float)time.timescale)/60];
            AVPlayerItem *currentItem = _appdel.player.currentItem;
            NSTimeInterval currentTime = CMTimeGetSeconds(currentItem.currentTime);
            NSLog(@" Capturing Time :%f ",currentTime);
            //             NSString *timeString = [NSString stringWithFormat:@"%d",currentTime.timescale];
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                self.currentTrackTime.text = timeString;
                NSLog(@"%@ jjjj",timeString);
            } else {
                NSLog(@"App is backgrounded. Time is: %@", timeString);
            }
        };
        
        self.timeObserver = [_appdel.player addPeriodicTimeObserverForInterval:CMTimeMake(10, 1000)
                                                                      queue:dispatch_get_main_queue()
                                                                 usingBlock:observerBlock];
        
        
    }
   
    [_appdel PlaySong];
    
    
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay)
        {
            NSLog(@"UIEventSubtypeRemoteControlPlay");
            //[[AppMusicPlayer sharedService]playAudio];
            [_appdel.player play];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPause)
        {
            NSLog(@"UIEventSubtypeRemoteControlPause");
            //[[AppMusicPlayer sharedService]pauseAudio];
            [_appdel.player pause];
        }
        else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause)
        {
            NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause");
        }
        else if (event.subtype == UIEventSubtypeRemoteControlNextTrack)
        {
            NSLog(@"UIEventSubtypeRemoteControlToggleNext");
            if (_allSongsArr.count>0 && _indexBackward<_allSongsArr.count-1) {
                _indexBackward++;
                [self playSongatIndex:_indexBackward];
            }
            else
            {
                //_indexBackward=;
                [_appdel.player pause];
                
            }
        }
        else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack)
        {
            NSLog(@"UIEventSubtypeRemoteControlPrevious");
            if (_allSongsArr.count>0  && _indexBackward>0) {
                _indexBackward--;
                [self playSongatIndex:_indexBackward];
            }
            else
            {
                //_indexBackward=0;
                [_appdel.player pause];
                //[self playSongatIndex:_indexBackward];
            }
        }
    }
}
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    NSLog(@"ply hello %@",_allSongsArr);
    // start your next song here
    _indexBackward++;
    if (_allSongsArr.count>0 && _indexBackward<_allSongsArr.count-1) {
        
        [self playSongatIndex:_indexBackward];
    }
    else
    {
        //_indexBackward=;
        _indexBackward=_allSongsArr.count;
        [_appdel.player pause];
        
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.playButton sendActionsForControlEvents:UIControlEventTouchUpInside];

}
-(void)playSongatIndex:(NSInteger)index
{
    [_appdel.player pause];
    if (self.allSongsArr) {
        NSString * dirName;
        NSString * fileName;
        NSString * albumName;
        NSString * categoryID;
        NSString * songName;
        NSLog(@"%@ yes",[_allSongsArr objectAtIndex:index]);
        if (_isStreamedSongs) {
            self.songName.text = [NSString stringWithFormat:@"%@",[[[_allSongsArr  objectAtIndex:index] objectAtIndex:0] valueForKey:@"name"]];
            self.artistName.hidden=YES;
            self.genreName.hidden=YES;
            songName=[[[_allSongsArr objectAtIndex:index]  objectAtIndex:0] valueForKey:@"name"];
            categoryID = _allSongsArr[index][0][@"category_id"];
            //dirName = [self.currentSongData valueForKey: @"dir_name"];
            fileName = [[[_allSongsArr objectAtIndex:index]  objectAtIndex:0] valueForKey:@"filename"];
            albumName = _albumname;
        }
        else if (_isSearchedSongs) {
            self.songName.text = [[[_allSongsArr objectAtIndex:index] objectAtIndex:0] valueForKey:@"name"];    ///self.allSongsArr[index][@"name"];
            self.artistName.hidden=YES;//self.allSongsArr[1];
            self.genreName.hidden=YES; //self.allSongsArr[2];
            
            dirName = [[[_allSongsArr objectAtIndex:index] objectAtIndex:0] valueForKey:@"dir_name"];//self.allSongsArr[index][@"dir_name"];
            fileName =[[[_allSongsArr objectAtIndex:index]  objectAtIndex:0] valueForKey:@"filename"];   // self.allSongsArr[index][@"filename"];
            albumName =  [[[_allSongsArr objectAtIndex:index] objectAtIndex:0] valueForKey:@"album_name"]; ///self.allSongsArr[index][@"album_name"];
        }
        else
        {
            self.songName.text = self.allSongsArr[index][0][@"name"];
            self.artistName.text = self.allSongsArr[index][1];
            self.genreName.text = self.allSongsArr[index][2];
            
            dirName = self.allSongsArr[index][0][@"dir_name"];
            fileName = self.allSongsArr[index][0][@"filename"];
            albumName = self.allSongsArr[index][0][@"album_name"];
           // categoryID = self.currentSongData[0][@"category_id"];
//            self.songName.text = [[_allSongsArr objectAtIndex:index] valueForKey:@"name"];    ///self.allSongsArr[index][@"name"];
//            self.artistName.hidden=self.allSongsArr[1];
//            self.genreName.hidden=YES; //self.allSongsArr[2];
//            
//            dirName = [[[_allSongsArr objectAtIndex:index] objectAtIndex:0] valueForKey:@"dir_name"];//self.allSongsArr[index][@"dir_name"];
//           fileName =[[[_allSongsArr objectAtIndex:index] objectAtIndex:0] valueForKey:@"filename"];   // self.allSongsArr[index][@"filename"];
//            albumName =  [[[_allSongsArr objectAtIndex:index] objectAtIndex:0] valueForKey:@"album_name"]; ///self.allSongsArr[index][@"album_name"];
            categoryID = [[[_allSongsArr objectAtIndex:index] objectAtIndex:0] valueForKey:@"category_id"]; ///self.allSongsArr[index][@"category_id"];
            
            
            

        }
        if (self.isTrending) {
            
            self.songURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/admin/media/%@/%@/music/%@",categoryID,albumName,fileName];
        }
        else if (_isStreamedSongs) {
            self.songURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/admin/media/%@/%@/%@/music/%@",categoryID,albumName,songName,fileName];
        }
        else
        {
            
            self.songURL = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/media/albums/%@/%@/music/%@",dirName,albumName,fileName];
        }
        NSString *urlstr1=  [self.songURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url1=[NSURL URLWithString:urlstr1];
        NSLog(@"SONG URL:%@",url1);
        
        /*
         
         self.audioPlayer = [[AVPlayer alloc]initWithPlayerItem:item];
         
         [self playButtonPressed:nil];
         */
        
        
        AVPlayerItem * item = [[AVPlayerItem alloc]initWithURL:url1];
        _appdel.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[_appdel.player currentItem]];
        // Set AVAudioSession
        NSError *sessionError = nil;
        [[AVAudioSession sharedInstance] setDelegate:self];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        // Change the default output audio route
        UInt32 doChangeDefaultRoute = 1;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                                sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
        
        NSArray *queue = @[item];
        
        _appdel.player = [[AVQueuePlayer alloc] initWithItems:queue];
        _appdel.player.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
        
        [_appdel.player addObserver:self
                      forKeyPath:@"currentItem"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
        void (^observerBlock)(CMTime time) = ^(CMTime time) {
            NSString *timeString = [NSString stringWithFormat:@"%02.2f", ((float)time.value / (float)time.timescale)/60];
            AVPlayerItem *currentItem = _appdel.player.currentItem;
            NSTimeInterval currentTime = CMTimeGetSeconds(currentItem.currentTime);
            NSLog(@" Capturing Time :%f ",currentTime);
            //             NSString *timeString = [NSString stringWithFormat:@"%d",currentTime.timescale];
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                self.currentTrackTime.text = timeString;
                NSLog(@"%@ hhh",timeString);
            } else {
                NSLog(@"App is backgrounded. Time is: %@", timeString);
            }
        };
        
        self.timeObserver = [_appdel.player addPeriodicTimeObserverForInterval:CMTimeMake(10, 1000)
                                                                      queue:dispatch_get_main_queue()
                                                                 usingBlock:observerBlock];
        
        
    }
    [_appdel.player play];
}
#pragma mark - Player

- (IBAction)backwardSong:(UIButton *)sender {
    //self.currentPlaybackTime -= 5.0f;
    if (_allSongsArr.count>0  && _indexBackward>0) {
        _indexBackward--;
        [self playSongatIndex:_indexBackward];
    }
    else
    {
        //_indexBackward=0;
        //[self playSongatIndex:_indexBackward];
    }
    
    
}

- (IBAction)forwardSong:(UIButton *)sender {
    //self.currentPlaybackTime += 5.0f;
    if (_allSongsArr.count>0 && _indexBackward<_allSongsArr.count-1) {
        _indexBackward++;
        [self playSongatIndex:_indexBackward];
    }
    else
    {
        //_indexBackward=;
        
    }
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentItem"]) {
        
        AVPlayerItem *item = ((AVPlayer *)object).currentItem;
        
//        self.lblMusicName.text = ((AVURLAsset*)item.asset).URL.pathComponents.lastObject;
//        NSLog(@"New music name: %@", self.lblMusicName.text);
    }
}

- (IBAction)addSongToFav:(UIButton *)sender {
    NSString * dirName = self.currentSongData[0][@"dir_name"];
    NSString * fileName = self.currentSongData[0][@"filename"];
    NSString * albumName = self.currentSongData[0][@"album_name"];
    NSString * categoryID = self.currentSongData[0][@"category_id"];

    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@ heeeee",_appdel.player);
//    [self.player pause];
//    self.player = nil;
}




- (IBAction)playButtonPressed:(id)sender {
    UIButton * button  = (UIButton*)sender;
    button.selected = !button.selected;
    if (button.selected) {
        [_appdel.player play];
        [button setBackgroundImage:[UIImage imageNamed:kSTOP] forState:UIControlStateNormal];

    }
    else
    {
        [button setBackgroundImage:[UIImage imageNamed:kPLAY] forState:UIControlStateNormal];
        [_appdel.player pause];

    }

    /*
    
    UIButton * button = (UIButton *)sender;
    if (isPlaying){
        // stop the player
        [button setImage:[UIImage imageNamed:kPLAY] forState:UIControlStateNormal];
        [self.audioPlayer pause];
        isPlaying = NO;
    }
    else {
        // play the song
        [self.audioPlayer play];
        [button setImage:[UIImage imageNamed:kSTOP] forState:UIControlStateNormal];
        isPlaying = YES;
    }
     */
}

//
//- (IBAction)playButtonPressed:(id)sender {
//    NSLog(@"%s",__PRETTY_FUNCTION__);
//    [[HysteriaPlayer sharedInstance]play];
//    /*
//    switch ([self.hysteriaPlayer getHysteriaPlayerStatus]) {
//        case HysteriaPlayerStatusUnknown:
//            break;
//        case HysteriaPlayerStatusForcePause:
//            [self.hysteriaPlayer play];
//            break;
//        case HysteriaPlayerStatusBuffering:
//            
//            break;
//        case HysteriaPlayerStatusPlaying:
//            [self.hysteriaPlayer pause];
//        default:
//            break;
//    }
//     */
//}



- (NSTimeInterval)currentPlaybackTime
{
    return CMTimeGetSeconds(_appdel.player.currentItem.currentTime);
}


- (void)setCurrentPlaybackTime:(NSTimeInterval)time {

    CMTime cmTime = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
    
    [_appdel.player.currentItem seekToTime:cmTime];
}


- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end
