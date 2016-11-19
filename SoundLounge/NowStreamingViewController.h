//
//  NowStreamingViewController.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "BaseViewController.h"

@interface NowStreamingViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
