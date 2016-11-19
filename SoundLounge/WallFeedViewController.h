//
//  WallFeedViewController.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/16/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "BaseViewController.h"
#import "WallFeedCell.h"
#import "WallFeedStatusCell.h"
@interface WallFeedViewController : BaseViewController<WallFeedCellDelegate,WallFeedStatusCellDelegate>
@property (strong, nonatomic)  UIImage *selectedImage;

@end
