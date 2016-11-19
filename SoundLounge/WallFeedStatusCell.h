//
//  WallFeedStatusCell.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/16/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WallFeedStatusCellDelegate <NSObject>

-(void)selectImageButtonPressed;
-(void)postButtonPressed:(NSString *)text;

@end

@interface WallFeedStatusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;

@property id<WallFeedStatusCellDelegate> delegate;

@end
