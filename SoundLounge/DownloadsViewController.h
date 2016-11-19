//
//  DownloadsViewController.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
@interface DownloadsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *showHidPopUp;
@property (nonatomic, strong) AppDelegate *appdel;

- (IBAction)shareBtnClicked:(id)sender;
- (IBAction)artistProfileBtnCLicked:(id)sender;
- (IBAction)closeBtnClicked:(id)sender;
- (IBAction)nextBtnClicked:(id)sender;
- (IBAction)previousBtnClicked:(id)sender;
@property(nonatomic) NSInteger indexCheck;

@end
