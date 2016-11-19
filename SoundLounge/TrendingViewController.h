//
//  Home.h
//  SoundLounge
//
//  Created by Apple on 24/04/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDWStatusFlowView.h"
#import "CollectionViewCellHeader.h"
@interface TrendingViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate> 
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,strong)NSString * albumID;
@end
