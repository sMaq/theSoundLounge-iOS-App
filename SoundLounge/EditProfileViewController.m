//
//  EditProfileViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/16/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "EditProfileViewController.h"
#import "SWRevealViewController.h"
#import "SLGlowingTextField.h"
#import "BAAlertController.h"
#import "HotBoxNotification.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"

@interface EditProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *sideBarButton;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _genderArr=[[NSArray alloc] initWithObjects:@"Gender",@"Male",@"Female", nil];
    _countryPikerView.delegate = self;
    _countryPikerView.dataSource = self;
    _cityPickerView.delegate = self;
    _cityPickerView.dataSource = self;
    _statePickerView.delegate = self;
    _statePickerView.dataSource = self;
    _genderPickerView.delegate = self;
    _genderPickerView.dataSource = self;
    [self loadCityCountryState];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    __scrollview.delegate=self;
    [__scrollview setExclusiveTouch:YES];
    [__scrollview setUserInteractionEnabled:YES];
    [self.tableView setContentInset:UIEdgeInsetsMake(20,0,0,0)];
    User * user = [LocalStorage getCurrentSavedUser];
    Artist * artist = [LocalStorage getCurrentSavedUser];
    NSLog(@"Saved User ID: %@",user.userID);
    NSLog(@"Saved user type: %@",[LocalStorage getSaveUserType]== kUserTypeArtist ? @"artist":@"listener");
    if ([LocalStorage getSaveUserType]== kUserTypeArtist)
    {
        _userNameText.text=artist.userName;
        _firstNameText.text=artist.firstName;
        _lastNameText.text=artist.lastName;
        _emailText.text=artist.email;
        _passwordText.text=artist.password;
        _confirmPassText.text=artist.confirmPassword;
        _paypalEmailText.hidden=NO;
        _paypalEmailText.text=artist.paypalEmail;
        _zipText.text=artist.zip;
        _bmiText.text=artist.bio;
        _contactNoText.text=artist.contactNumber;
    }
    else
    {
        _userNameText.text=user.userName;
        _firstNameText.text=user.firstName;
        _lastNameText.text=user.lastName;
        _emailText.text=user.email;
        _passwordText.text=user.password;
        _confirmPassText.text=user.confirmPassword;
        _contactNoText.text=user.contactNumber;

        _paypalEmailText.hidden=YES;
        _zipText.text=user.zip;
        _bmiText.text=user.bio;
    }

}
- (void)viewDidLayoutSubviews {
    self._scrollview.contentSize = CGSizeMake(290, 1250);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}
#pragma mark - helper methods

-(void)showSuccessAlert:(NSString *)text {
    NSAttributedString * message = [[NSAttributedString alloc] initWithString:text];
    [[HotBox sharedInstance]showMessage:message ofType:kAlertSuccess withDelegate:nil duration:3];
    
}

-(void)showInfoAlert:(NSString *)text {
    NSAttributedString * message = [[NSAttributedString alloc] initWithString:text];
    [[HotBox sharedInstance]showMessage:message ofType:kAlertWarning withDelegate:nil duration:3];
}

-(void)showErrorAlert:(NSString*)text{
    NSAttributedString * message = [[NSAttributedString alloc] initWithString:text];
    [[HotBox sharedInstance]showMessage:message ofType:kAlertError withDelegate:nil duration:3];
}


-(void)showProgressHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgressHUB{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)loadCityCountryState {
    
    // [self showProgressHUD];
    [WebAPI getcityStateCountryWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            if (data) {
                NSLog(@"city state country %@",data);
                //                _albumsDataArr=[[NSArray alloc] init];
                //                _albumsDataArr=data;
                //                _albumsNameArr=[[NSArray alloc] init];
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    _cityArr=[data valueForKey:@"city"];
                    _countryArr=[data valueForKey:@"country"];
                    _stateArr=[data valueForKey:@"state"];
                    [_countryPikerView reloadAllComponents];
                    [_cityPickerView reloadAllComponents];
                    [_statePickerView reloadAllComponents];
                    
                });
                //                _albumsNameArr=[albums valueForKey:@"name"];
                //                _albumsIDArr=[albums valueForKey:@"album_id"];
                //                self.updateSelectAlbumPicker.delegate = self;
                //                self.updateSelectAlbumPicker.dataSource = self;
                //                [self.updateSelectAlbumPicker reloadAllComponents];
                //                [_mainscrollView bringSubviewToFront:_updateSelectAlbumPicker];
                //                _updateSelectAlbumPicker.userInteractionEnabled=YES;
                
            }
            
            //[self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
        else {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
            //  [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
        }
    }];
    
}

- (IBAction)registerBtnClicked:(id)sender{
    User * user = [LocalStorage getCurrentSavedUser];
    NSLog(@"Saved User ID: %@",user.userID);
    NSLog(@"Saved user type: %@",[LocalStorage getSaveUserType]== kUserTypeArtist ? @"artist":@"listener");
    NSInteger countryRow;
    
    countryRow = [_countryPikerView selectedRowInComponent:0];
    NSString* countrytxt = [[_countryArr objectAtIndex:countryRow] valueForKey:@"id"];
    NSInteger cityRow;
    
    cityRow = [_cityPickerView selectedRowInComponent:0];
    NSString* citytxt = [[_cityArr objectAtIndex:cityRow] valueForKey:@"id"];
    NSInteger stateRow;
    
    stateRow = [_statePickerView selectedRowInComponent:0];
    NSString* statetxt = [[_stateArr objectAtIndex:stateRow] valueForKey:@"id"];
    NSInteger genderRow;
    
    genderRow = [_genderPickerView selectedRowInComponent:0];
    NSString* gendertxt = [_genderArr objectAtIndex:genderRow];
    if ([LocalStorage getSaveUserType]== kUserTypeArtist)
    {
        
        _bmiText.hidden=NO;
        _paypalEmailText.hidden=NO;
        if (gendertxt != nil &&
            ![gendertxt isEqualToString:@"Gender"] &&![statetxt isEqualToString:@""] && ![citytxt isEqualToString:@""] && ![countrytxt isEqualToString:@""] && self.userNameText.text != nil && ![self.zipText.text isEqualToString:@""] && self.zipText.text != nil &&
           ![self.contactNoText.text isEqualToString:@""] &&self.contactNoText.text != nil && ![self.userNameText.text isEqualToString:@""] &&self.firstNameText.text != nil &&
            ![self.firstNameText.text isEqualToString:@""] && self.lastNameText.text != nil &&
            ![self.lastNameText.text isEqualToString:@""]&& self.emailText.text != nil &&
            ![self.emailText.text isEqualToString:@""] && self.passwordText.text != nil &&
            ![self.passwordText.text isEqualToString:@""] && self.confirmPassText.text != nil &&
            ![self.confirmPassText.text isEqualToString:@""] &&
            ![self.paypalEmailText.text isEqualToString:@""] && self.bmiText.text != nil &&
            ![self.bmiText.text isEqualToString:@""]
            
            )
        {
            
            
            [SVProgressHUD show];
            Artist *user=[[Artist alloc] init];
            user.userName=_userNameText.text;
            user.firstName=_firstNameText.text;
            user.lastName=_lastNameText.text;
            user.email=_emailText.text;
            user.password=_passwordText.text;
            user.confirmPassword=_confirmPassText.text;
            user.paypalEmail=_paypalEmailText.text;
            user.bio=_bmiText.text;
            user.zip=_zipText.text;
            user.gender=[_genderArr objectAtIndex:genderRow];
            user.city=[[_cityArr objectAtIndex:cityRow] valueForKey:@"id"];
            user.country=[[_countryArr objectAtIndex:countryRow] valueForKey:@"id"];
            user.contactNumber=_contactNoText.text;
            user.state=[[_stateArr objectAtIndex:stateRow] valueForKey:@"id"];
            if ([_passwordText.text isEqualToString:_confirmPassText.text]) {
                [WebAPI updateArtist:user completionHandler:^(BOOL isError, NSArray * data) {
                    if (isError) {
                        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
                        // [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                        [SVProgressHUD showErrorWithStatus:@"Not Updated Data"];
                        return;
                    }
                    
                    if (data) {
                        NSDictionary * tempData = (NSDictionary *)data;
                        NSLog(@"msg: %@",tempData[@"msg"]);
                        if (tempData[@"msg"] == nil) {
                            //Artist * artist = [Artist parseArtistFromDictionary:tempData];
                            [LocalStorage saveNewUser:user type:kUserTypeArtist];
                        }
                        [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Artist Updated Successfully" waitUntilDone:NO];
                        //[self loadAlbumsData];
                        
                    }
                    [SVProgressHUD showSuccessWithStatus:@"Artist added Successfully"];
                    
                    
                    
                    //[self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    
                }];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Password not matched." waitUntilDone:NO];
            }
            
            
            
        }
        else
        {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"All fields must be filled." waitUntilDone:NO];
        }
        
    }
    else
    {
        _bmiText.hidden=YES;
        _paypalEmailText.hidden=YES;
        if (gendertxt != nil &&
            ![gendertxt isEqualToString:@"Gender"] &&![statetxt isEqualToString:@""] && ![citytxt isEqualToString:@""] && ![countrytxt isEqualToString:@""] && self.userNameText.text != nil && ![self.zipText.text isEqualToString:@""] && self.zipText.text != nil &&
           ![self.contactNoText.text isEqualToString:@""] &&self.contactNoText.text != nil && ![self.userNameText.text isEqualToString:@""] && self.firstNameText.text != nil &&
            ![self.firstNameText.text isEqualToString:@""] && self.lastNameText.text != nil &&
            ![self.lastNameText.text isEqualToString:@""]&& self.emailText.text != nil &&
            ![self.emailText.text isEqualToString:@""] && self.passwordText.text != nil &&
            ![self.passwordText.text isEqualToString:@""] && self.confirmPassText.text != nil &&
            ![self.confirmPassText.text isEqualToString:@""]
            
            )
        {
            
            
            [SVProgressHUD show];
            User *user=[[User alloc] init];
            user.userName=_userNameText.text;
            user.firstName=_firstNameText.text;
            user.lastName=_lastNameText.text;
            user.email=_emailText.text;
            user.password=_passwordText.text;
            user.confirmPassword=_confirmPassText.text;
            user.zip=_zipText.text;
            user.gender=[_genderArr objectAtIndex:genderRow];
            user.city=[[_cityArr objectAtIndex:cityRow] valueForKey:@"id"];
            user.country=[[_countryArr objectAtIndex:countryRow] valueForKey:@"id"];
            user.state=[[_stateArr objectAtIndex:stateRow] valueForKey:@"id"];
            user.contactNumber=_contactNoText.text;
            if ([_passwordText.text isEqualToString:_confirmPassText.text]) {
                [WebAPI updateUser:user completionHandler:^(BOOL isError, NSArray * data) {
                    if (isError) {
                        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
                        // [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                        [SVProgressHUD showErrorWithStatus:@"Not Updated Data"];
                        return;
                    }
                    
                    if (data) {
                        NSDictionary * tempData = (NSDictionary *)data;
                        if (tempData[@"msg"] == nil) {
                            //User * listener = [User parseUserFromDictionary:tempData];
                            [LocalStorage saveNewUser:user type:kUserTypeListener];
                        }
                        [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Listner updated Successfully" waitUntilDone:NO];
                        //[self loadAlbumsData];
                      
                    }
                    [SVProgressHUD showSuccessWithStatus:@"Listner added Successfully"];
                    //[self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                    
                }];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Password not matched." waitUntilDone:NO];
            }
            
            
            
        }
        else
        {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"All fields must be filled." waitUntilDone:NO];
        }
        
    }
    
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _stateOrigArr=[[NSMutableArray alloc] init];
    _cityOrigArr=[[NSMutableArray alloc] init];
    if (pickerView==_countryPikerView)
    {
        NSInteger countryid=[[[_countryArr objectAtIndex:row] valueForKey:@"id"] integerValue];
        for (int i=0; i<_stateArr.count; i++)
        {
            NSInteger countryidState=[[[_stateArr objectAtIndex:i] valueForKey:@"country_id"]integerValue];

            if (countryid==countryidState) {
                [_stateOrigArr addObject:[_stateArr objectAtIndex:i]];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_statePickerView reloadAllComponents];
            [_statePickerView setUserInteractionEnabled:YES];
        });
    }
    else if (pickerView==_statePickerView)
    {
        NSInteger countryid=[[[_stateArr objectAtIndex:row] valueForKey:@"id"] integerValue];
        for (int i=0; i<_cityArr.count; i++)
        {
            NSInteger stateid=[[[_cityArr objectAtIndex:i] valueForKey:@"state_id"] integerValue];
            if (countryid==stateid) {
                [_cityOrigArr addObject:[_cityArr objectAtIndex:i]];
            }
            
        }
         dispatch_async(dispatch_get_main_queue(), ^{
             [_cityPickerView reloadAllComponents];
             [_cityPickerView setUserInteractionEnabled:YES];
            // [_cityPickerView bringSubviewToFront:_albumNameTextField];
         });
        
    }
    NSLog(@"%@, %@ yesss",_cityOrigArr,_stateOrigArr);
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    return 200;
//}
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 50;
//}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = @"";
    if (pickerView == _countryPikerView)
    {
        returnStr = [[_countryArr objectAtIndex:row] objectForKey:@"name"];
    }
    else if (pickerView == _cityPickerView)
    {
        returnStr = [[_cityOrigArr objectAtIndex:row] objectForKey:@"name"];
    }
    else if (pickerView == _genderPickerView)
    {
        returnStr = [_genderArr objectAtIndex:row];
    }
    else
    {
        returnStr = [[_stateOrigArr objectAtIndex:row] objectForKey:@"name"];
    }
    return returnStr;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    if (pickerView == _countryPikerView)
    {
        return [_countryArr count];
    }
    else if (pickerView == _cityPickerView)
    {
        return [_cityOrigArr count];
    }
    else if (pickerView == _genderPickerView)
    {
        return [_genderArr count];
    }
    else
    {
        return [_stateOrigArr count];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
@end
