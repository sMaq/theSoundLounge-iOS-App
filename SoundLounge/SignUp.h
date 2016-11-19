//
//  SignUp.h
//  SoundLounge
//
//  Created by Apple on 26/04/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUp : BaseViewController <UIScrollViewDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic)  NSInteger checkUserType;
@property (weak, nonatomic) IBOutlet UILabel *titleLbltext;
@property (weak, nonatomic) IBOutlet UILabel *descriprionLbltxt;
@property (weak, nonatomic) IBOutlet UILabel *titleartistTxt;
@property (weak, nonatomic) IBOutlet UILabel *descArtistTxt;


@property (weak, nonatomic) IBOutlet UIScrollView *_scrollview;
@property (weak, nonatomic) IBOutlet UITextField *userNameText;

@property (weak, nonatomic) IBOutlet UITextField *firstNameText;

@property (weak, nonatomic) IBOutlet UITextField *lastNameText;

@property (weak, nonatomic) IBOutlet UITextField *emailText;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UITextField *confirmPassText;

@property (weak, nonatomic) IBOutlet UITextField *genderText;

@property (weak, nonatomic) IBOutlet UITextField *city;

@property (weak, nonatomic) IBOutlet UITextField *stateText;

@property (weak, nonatomic) IBOutlet UITextField *countryText;

@property (weak, nonatomic) IBOutlet UITextField *zipText;

@property (weak, nonatomic) IBOutlet UITextField *contactNoText;
@property (nonatomic,strong) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet UITextField *bmiText;
@property (weak, nonatomic) IBOutlet UITextField *paypalEmailText;
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtnClicked;
- (IBAction)registerBtnClicked:(id)sender;
@end
