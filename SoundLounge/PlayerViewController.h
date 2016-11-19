//
//  PlayerViewController.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/27/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "BaseViewController.h"

@interface PlayerViewController : BaseViewController

@property UIImage * coverImage;
@property NSArray * currentSongData;
@property NSArray * allSongsArr;
@property NSArray * allSongsData;
@property NSString *albumname;
@property(nonatomic) NSInteger indexForward;
@property(nonatomic) NSInteger indexBackward;
@property BOOL isTrending;
@property BOOL isSearchedSongs;
@property BOOL isStreamedSongs;
-(void)playSongatIndex:(NSInteger)index;
@end
