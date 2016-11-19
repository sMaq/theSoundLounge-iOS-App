//
//  WallFeedCell.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/12/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "WallFeedCell.h"

@implementation WallFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _artistImageView.layer.cornerRadius = _artistImageView.frame.size.width / 2;
    _artistImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


- (IBAction)commentsButtonPressed:(UIButton *)sender {
    [self.delegate comntBtnPressedWithTag:(int)((UIButton*)sender).tag];
}

- (IBAction)likebuttonPressed:(id)sender {
    [self.delegate likeBtnPressedWithTag:(int)((UIButton*)sender).tag];
}
- (IBAction)unlikeBtnPressed:(id)sender {
    [self.delegate unlikeBtnPressedWithTag:(int)((UIButton*)sender).tag];
}
@end
