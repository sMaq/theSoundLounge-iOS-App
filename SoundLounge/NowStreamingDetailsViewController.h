//
//  NowStreamingDetailsViewController.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "BaseViewController.h"

@interface NowStreamingDetailsViewController : BaseViewController
@property NSInteger selectedIndex;
@property NSArray * genreData;
@property (nonatomic,strong) NSString * UrlStr;
@end
