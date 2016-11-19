//
//  SearchViewController.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/17/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "BaseViewController.h"
#import "SongsCell.h"
@interface SearchViewController : BaseViewController<SongsCellDelegate>
@property NSString * artistID;

@end
