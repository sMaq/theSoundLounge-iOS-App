//
//  Playlists.h
//  SoundLounge
//
//  Created by Apple on 01/05/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Playlists : BaseViewController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) IBOutlet UITableView * albumDetailTableView;

@end
