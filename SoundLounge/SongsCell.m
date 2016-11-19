//
//  SongsCell.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "SongsCell.h"

@interface SongsCell()

@end

@implementation SongsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playButtonPressed:(id)sender {
    [self.delegate playButtonPressedWithTag:(int)((UIButton*)sender).tag];
}

- (IBAction)clockButtonPressed:(UIButton *)sender {
    [self.delegate clockButtonPressedWithTag:(int)sender.tag];
}

@end
