//
//  WallFeedCell.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/12/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WallFeedCellDelegate <NSObject>
-(void)comntBtnPressedWithTag:(int)tag;
-(void)unlikeBtnPressedWithTag:(int)tag;
@optional
-(void)likeBtnPressedWithTag:(int)tag;
@end
@interface WallFeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *comentsLbl;
@property (weak, nonatomic) IBOutlet UIButton *unlikebtn;
- (IBAction)unlikeBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateTextField;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesTF;
- (IBAction)likebuttonPressed:(id)sender;
@property id<WallFeedCellDelegate> delegate;

@end
