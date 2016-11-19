//
//  DownloadsViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "DownloadsViewController.h"
#import "SWRevealViewController.h"
#import <Social/Social.h>
#define kPLAY @"play-.png"
#define kSTOP @"stop.png"

#import "SongsCell.h"


@import AVFoundation;

@interface DownloadsViewController () <UITableViewDelegate, UITableViewDataSource,SongsCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sideBarButton;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *genreName;
@property (nonatomic, strong) AVQueuePlayer *player;
@property (nonatomic, strong) id timeObserver;

@property NSArray <Song*> * songsData;


@end

@implementation DownloadsViewController

- (IBAction)search:(UIButton *)sender {
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _showHidPopUp.hidden=YES;
    self.songsData = [LocalStorage listOfAllSavedSongs];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SongsCell" bundle:nil] forCellReuseIdentifier:@"AlbumDetail"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
}

-(void)setupPlayer:(NSString *)songPath{
    _appdel=[[AppDelegate alloc]init];
    _appdel=[[UIApplication sharedApplication] delegate];
    [_appdel setPlayer];
    [_appdel pauseSong];
    // NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:songPath]];
   // AVPlayerItem * item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:songPath]];
    //[/*name of NSData*/ writeToFile:/*save file path*/ atomically: YES];
    //NSString *path = [songPath path];
//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:songPath];
//    NSURL *filepath = [NSURL nsda:songPath];
//    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:data];
    //AVPlayerItem * item = [[AVPlayerItem alloc] initwit];
    NSURL *url=[[NSURL alloc]initWithString:songPath ];
    NSURL *url1=[NSURL fileURLWithPath:songPath];
    NSLog(@"%@ new url",url1);
    //player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL];
     AVPlayerItem * item = [[AVPlayerItem alloc]initWithURL:url1];
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
    //_appdel.player.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
    _appdel.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[_appdel.player currentItem]];
   // [_appdel.player addObserver:self
//                  forKeyPath:@"currentItem"
//                     options:NSKeyValueObservingOptionNew
//                     context:nil];
    void (^observerBlock)(CMTime time) = ^(CMTime time) {
        NSString *timeString = [NSString stringWithFormat:@"%02.2f", (float)time.value / (float)time.timescale];
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            //                self.lblMusicTime.text = timeString;
            NSLog(@"%@",timeString);
        } else {
            NSLog(@"App is backgrounded. Time is: %@", timeString);
        }
    };
    
    self.timeObserver = [_appdel.player addPeriodicTimeObserverForInterval:CMTimeMake(10, 1000)
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:observerBlock];

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
            if (_songsData.count>0 && _indexCheck<_songsData.count-1) {
                _indexCheck++;
                _artistName.text=[NSString stringWithFormat:@"%@",[_songsData objectAtIndex:_indexCheck]];
                
                //load the file for playing
                NSString *FileNamePath = [NSString stringWithFormat:@"%@",[_songsData objectAtIndex:_indexCheck]];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *appSettingsPath = [documentsDirectory stringByAppendingPathComponent:FileNamePath];
                NSLog(@"file path iss %@", appSettingsPath);
                ////////
                //[self.player play];
                [self setupPlayer:appSettingsPath];
                [_appdel.player play];
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
            if (_songsData.count>0 && _indexCheck<_songsData.count-1) {
                _indexCheck++;
                _artistName.text=[NSString stringWithFormat:@"%@",[_songsData objectAtIndex:_indexCheck]];
                
                //load the file for playing
                NSString *FileNamePath = [NSString stringWithFormat:@"%@",[_songsData objectAtIndex:_indexCheck]];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *appSettingsPath = [documentsDirectory stringByAppendingPathComponent:FileNamePath];
                NSLog(@"file path iss %@", appSettingsPath);
                ////////
                //[self.player play];
                [self setupPlayer:appSettingsPath];
                [_appdel.player play];
            }
            else
            {
                //_indexBackward=;
                
                [_appdel.player pause];
                
            }
                //_indexBackward=0;
                //[self playSongatIndex:_indexBackward];
            
        }
    }
}
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    NSLog(@"ply hello");
    // start your next song here
    if (_songsData.count>0 && _indexCheck<_songsData.count-1) {
        _indexCheck++;
        _artistName.text=[NSString stringWithFormat:@"%@",[_songsData objectAtIndex:_indexCheck]];
        
        //load the file for playing
        NSString *FileNamePath = [NSString stringWithFormat:@"%@",[_songsData objectAtIndex:_indexCheck]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appSettingsPath = [documentsDirectory stringByAppendingPathComponent:FileNamePath];
        NSLog(@"file path iss %@", appSettingsPath);
        ////////
        //[self.player play];
        [self setupPlayer:appSettingsPath];
        [_appdel.player play];
    }
    else
    {
        //_indexBackward=;
        [_appdel.player pause];
        
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentItem"])
    {
        AVPlayerItem *item = ((AVPlayer *)object).currentItem;
        
        //        self.lblMusicName.text = ((AVURLAsset*)item.asset).URL.pathComponents.lastObject;
        //        NSLog(@"New music name: %@", self.lblMusicName.text);
    }
}



- (IBAction)playPausePressed:(UIButton *)sender {
    UIButton * button  = (UIButton*)sender;
    button.selected = !button.selected;
    if (button.selected)
    {
        [_appdel.player play];
        [button setImage:[UIImage imageNamed:kSTOP] forState:UIControlStateNormal];
        
    }
    else
    {
        [button setImage:[UIImage imageNamed:kPLAY] forState:UIControlStateNormal];
        [_appdel.player pause];
        
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songsData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Song * song = self.songsData[indexPath.row];
    
    SongsCell * cell = (SongsCell*)[tableView dequeueReusableCellWithIdentifier:@"AlbumDetail"];
    
    if (cell == nil) {
        cell = [[SongsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlbumDetail"];
    }
    
    cell.songTitle.text = [NSString stringWithFormat:@"%@",[_songsData objectAtIndex:indexPath.row]];
    cell.clockButton.tag=indexPath.row;
    cell.playButton.tag = indexPath.row;
    
    cell.delegate = self;
    return cell;
}
-(void)playButtonPressedWithTag:(int)tag {
    SongsCell * cell = (SongsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    _artistName.text=[NSString stringWithFormat:@"%@",[_songsData objectAtIndex:tag]];
    
    //load the file for playing
    NSString *FileNamePath = [NSString stringWithFormat:@"%@",[_songsData objectAtIndex:tag]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appSettingsPath = [documentsDirectory stringByAppendingPathComponent:FileNamePath];
   NSLog(@"file path iss %@", appSettingsPath);
    ////////
    //[self.player play];
    [self setupPlayer:appSettingsPath];
    [_appdel.player play];
    //[self performSegueWithIdentifier:@"showPlayer" sender:cell.playButton];
}
-(void)clockButtonPressedWithTag:(int)tag {
    SongsCell * cell = (SongsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    _showHidPopUp.hidden=NO;

    
}
//NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[filePathsArray objectAtIndex:0]];
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setupPlayer:self.songsData[indexPath.row].songLocalURL];
    _indexCheck=indexPath.row;
}
- (IBAction)closeBtnClicked:(id)sender {
    _showHidPopUp.hidden=YES;
}

- (IBAction)nextBtnClicked:(id)sender {
    if (_songsData.count>0 && _indexCheck<_songsData.count-1) {
        _indexCheck++;
        _artistName.text=[NSString stringWithFormat:@"%@",[_songsData objectAtIndex:_indexCheck]];
        
        //load the file for playing
        NSString *FileNamePath = [NSString stringWithFormat:@"%@",[_songsData objectAtIndex:_indexCheck]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appSettingsPath = [documentsDirectory stringByAppendingPathComponent:FileNamePath];
        NSLog(@"file path iss %@", appSettingsPath);
        ////////
        //[self.player play];
        [self setupPlayer:appSettingsPath];
        [_appdel.player play];
    }
    else
    {
        //_indexBackward=;
        
    }
    
}

- (IBAction)previousBtnClicked:(id)sender {
    if (_songsData.count>0  && _indexCheck>0) {
        _indexCheck--;
        _artistName.text=[NSString stringWithFormat:@"%@",[_songsData objectAtIndex:_indexCheck]];
        
        //load the file for playing
        NSString *FileNamePath = [NSString stringWithFormat:@"%@",[_songsData objectAtIndex:_indexCheck]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appSettingsPath = [documentsDirectory stringByAppendingPathComponent:FileNamePath];
        NSLog(@"file path iss %@", appSettingsPath);
        ////////
        //[self.player play];
        [self setupPlayer:appSettingsPath];
        [_appdel.player play];
    }
    else
    {
        //_indexBackward=0;
        //[self playSongatIndex:_indexBackward];
    }
}
#pragma mark - Social

//- (IBAction)shareButtonPressed:(UIButton *)sender {
//    UIAlertController * shareAlert = [UIAlertController alertControllerWithTitle:@"Choose Social Network" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    [shareAlert addAction:[UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        [self performSelectorOnMainThread:@selector(shareOnTwitter) withObject:nil waitUntilDone:NO];
//        
//    }]];
//    
//    [shareAlert addAction:[UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        [self performSelectorOnMainThread:@selector(shareOnFacebook) withObject:nil waitUntilDone:NO];
//        
//    }]];
//    
//    [shareAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
//    
//    [self presentViewController:shareAlert animated:YES completion:nil];
//    
//    
//}
//
//
//
//
//-(void)shareOnTwitter {
//    NSLog(@"%s",__PRETTY_FUNCTION__);
//    
//    NSString * message = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/album/%@/music",_albumName];
//    
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//        
//        SLComposeViewController *tweetSheet = [SLComposeViewController
//                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
//        [tweetSheet setInitialText:message];
//        
//        [self presentViewController:tweetSheet animated:YES completion:nil];
//    }
//    else {
//        UIAlertController * error = [UIAlertController alertControllerWithTitle:@"Twitter Account Not Found" message:@"It seems that you have not configured twitter account with your iPhone. Please go to Settings and add twitter account details." preferredStyle:UIAlertControllerStyleAlert];
//        [error addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }]];
//        [error addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:error animated:YES completion:nil];
//        
//        NSLog(@"twitter account not found");
//    }
//}
//
//-(void)shareOnFacebook {
//    
//    NSLog(@"%s",__PRETTY_FUNCTION__);
//    
//    NSString * message = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/album/%@/music",_albumName];
//    
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        
//        [controller setInitialText:message];
//        [self presentViewController:controller animated:YES completion:Nil];
//    }
//    else {
//        UIAlertController * error = [UIAlertController alertControllerWithTitle:@"Facebook Account Not Found" message:@"It seems that you have not configured facebook account with your iPhone. Please go to Settings and add facebook account details." preferredStyle:UIAlertControllerStyleAlert];
//        [error addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }]];
//        [error addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
//        [self presentViewController:error animated:YES completion:nil];
//        NSLog(@"Facebook account not found");
//    }
//}
- (IBAction)shareBtnClicked:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self shareButtonPressed:sender];
        
    });
    
}
@end
