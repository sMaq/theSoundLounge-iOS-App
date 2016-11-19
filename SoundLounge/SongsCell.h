//
//  SongsCell.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SongsCellDelegate <NSObject>
-(void)playButtonPressedWithTag:(int)tag;
@optional
-(void)clockButtonPressedWithTag:(int)tag;
@end

@interface SongsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *clockButton;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *songGenre;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *songDuration;
@property id<SongsCellDelegate> delegate;

@end
