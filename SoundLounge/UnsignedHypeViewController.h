//
//  UnsignedHypeViewController.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "BaseViewController.h"

@interface UnsignedHypeViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMain;
@property(nonatomic) NSMutableArray* imagesArr;
@end
