//
//  WallFeedViewController.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/12/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewArtistViewController : BaseViewController
@property (nonatomic) NSInteger selectedArtistIdFrmTrendingView;
@property (nonatomic) NSString* artist_idFOrAlbum;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UILabel *emaillbl;
- (IBAction)FollowBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *totalsongs;
@property (weak, nonatomic) IBOutlet UILabel *followersLbl;
- (IBAction)dropDownBtnCLicked:(id)sender;
@property (nonatomic) BOOL checkINdexForDD;
@property (nonatomic) BOOL isFromSearchView;
@end
