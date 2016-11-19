//
//  AppDelegate.h
//  SoundLounge
//
//  Created by Apple on 24/04/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AVQueuePlayer *player;
@property (nonatomic, strong) AVPlayer *avplayer;
-(void)setPlayer;
-(void)PlaySong;
-(void)pauseSong;
-(void)isplayerNo;
-(void)isplayerYes;
@property (nonatomic) BOOL isPlaying;
@end

