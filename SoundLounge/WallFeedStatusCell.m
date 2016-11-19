//
//  WallFeedStatusCell.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/16/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "WallFeedStatusCell.h"
@interface WallFeedStatusCell()

@end

@implementation WallFeedStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)postButtonPressed:(id)sender {
    NSString * text = self.statusTextField.text;
    [self.delegate postButtonPressed:text];
}
- (IBAction)selectImageButtonPressed:(id)sender {
    [self.delegate selectImageButtonPressed];
}

@end
