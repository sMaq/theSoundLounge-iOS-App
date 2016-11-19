//
//  EditProfileViewController.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/16/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "BaseViewController.h"

@interface EditProfileViewController : BaseViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic,strong) NSArray*cityArr;
@property (nonatomic,strong) NSArray*countryArr;
@property (nonatomic,strong) NSArray*stateArr;
@property (nonatomic,strong) NSMutableArray*cityOrigArr;
@property (nonatomic,strong) NSMutableArray*countryOrigArr;
@property (nonatomic,strong) NSMutableArray*stateOrigArr;
@property (nonatomic,strong) NSArray*genderArr;
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
@property (weak, nonatomic) IBOutlet UIPickerView *countryPikerView;
@property (weak, nonatomic) IBOutlet UIPickerView *statePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *cityPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *genderPickerView;
@end
