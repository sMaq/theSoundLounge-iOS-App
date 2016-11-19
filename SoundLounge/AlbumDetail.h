//
//  AlbumDetail.h
//  SoundLounge
//
//  Created by Apple on 30/04/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumDetail : BaseViewController <UITableViewDelegate,UITableViewDataSource>
@property NSString * albumID;
@property NSString * MusicID;
@property UIImage * albumImage;
@property NSString * genreID;
@property NSString * artistID;
@property NSString * albumName;
@property NSString * SongsUrlDownload;
@property NSString * SongsName;
@property (weak, nonatomic) IBOutlet UIButton *heartbtn;
@property (weak, nonatomic) IBOutlet UIButton *heartBtnPop;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property BOOL isfromSearch;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property BOOL isfromNowStreaming;
- (IBAction)profileBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *popUPVIew;
- (IBAction)closeBtnClicked:(id)sender;
- (IBAction)artistProfileBtnCLicked:(id)sender;
- (IBAction)addFavourites:(id)sender;
- (IBAction)shareBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *albumnameLbl;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLBltitle;
@property (weak, nonatomic) IBOutlet UILabel *popAlbumNameLbl;
- (IBAction)downloadBtnClicked:(id)sender;
@end
