//
//  SignUp.m
//  SoundLounge
//
//  Created by Apple on 26/04/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "SignUp.h"
#import "SLGlowingTextField.h"
#import "BAAlertController.h"
#import "HotBoxNotification.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
@interface SignUp ()

@end

@implementation SignUp

- (void)viewDidLoad {
    if (_checkUserType==1)
    {
        _bgImageView.image=[UIImage imageNamed:@"artRegBack-1"];
        _titleLbltext.hidden=YES;
        _descriprionLbltxt.hidden=YES;
        _titleartistTxt.hidden=NO;
        _descArtistTxt.hidden=NO;
        _titleartistTxt.text=@"Artists";
        _descArtistTxt.text=@"Registration page for those who wanna just play.";
        _bmiText.hidden=NO;
        _paypalEmailText.hidden=NO;
    }
    else
    {
        _bgImageView.image=[UIImage imageNamed:@"listenerRegBack-1"];
        _titleartistTxt.hidden=YES;
        _descArtistTxt.hidden=YES;
        _titleLbltext.hidden=NO;
        _descriprionLbltxt.hidden=NO;
        _titleLbltext.text=@"Listeners";
        _descriprionLbltxt.text=@"Registration page for those who wanna just listen";
        _bmiText.hidden=YES;
        _paypalEmailText.hidden=YES;
    }
    __scrollview.delegate=self;
    NSLog(@"%ld check",(long)_checkUserType);
    [__scrollview setExclusiveTouch:YES];
    [__scrollview setUserInteractionEnabled:YES];
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(20,0,0,0)];
}
- (void)viewDidLayoutSubviews {
    self._scrollview.contentSize = CGSizeMake(290, 700);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"ArtistSegue"])
    {
        SignUp *vc = [segue destinationViewController];
        vc.checkUserType= 1;
        //vc.subFirmsArray = _subFirmList;
        
    }
    else if ([segue.identifier isEqualToString:@"ListnerSegue"])
    {
        SignUp *vc = [segue destinationViewController];
        vc.checkUserType= 2;
        //vc.subFirmsArray = _subFirmList;
        
    }
    //    else if ([segue.identifier isEqualToString:SEGUE_IntroVC_ToMembersVC])
    //    {
    //        WheelViewController *vc = [segue destinationViewController];
    //        //vc.subFirmsArray = _subFirmList;
    //
    //    }
}
- (IBAction)registerBtnClicked:(id)sender {
    if (_checkUserType==1)
    {
        _bmiText.hidden=NO;
        _paypalEmailText.hidden=NO;
        if (self.userNameText.text != nil &&
            ![self.userNameText.text isEqualToString:@""] && self.firstNameText.text != nil &&
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
            user.firstName=_firstNameText.text;
            user.lastName=_lastNameText.text;
            user.userName=_userNameText.text;
            user.email=_emailText.text;
            user.password=_passwordText.text;
            user.confirmPassword=_confirmPassText.text;
            user.paypalEmail=_paypalEmailText.text;
            user.bio=_bmiText.text;
            if ([_passwordText.text isEqualToString:_confirmPassText.text]) {
                [WebAPI registerArtist:user completionHandler:^(BOOL isError, NSArray * data) {
                    if (isError) {
                        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
                        // [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                        [SVProgressHUD showErrorWithStatus:@"Not Updated Data"];
                        return;
                    }
                    
                    if (data) {
                        [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Artist added Successfully" waitUntilDone:NO];
                        //[self loadAlbumsData];
                        [self performSelectorOnMainThread:@selector(segueToLogin:) withObject:@"registerToLoginView" waitUntilDone:NO];
                        
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
        if (self.userNameText.text != nil &&
            ![self.userNameText.text isEqualToString:@""] && self.firstNameText.text != nil &&
            ![self.firstNameText.text isEqualToString:@""] && self.lastNameText.text != nil &&
            ![self.lastNameText.text isEqualToString:@""]&& self.emailText.text != nil &&
            ![self.emailText.text isEqualToString:@""] && self.passwordText.text != nil &&
            ![self.passwordText.text isEqualToString:@""] && self.confirmPassText.text != nil &&
            ![self.confirmPassText.text isEqualToString:@""]
            
            )
        {
            
            
            [SVProgressHUD show];
            User *user=[[User alloc] init];
            user.firstName=_firstNameText.text;
            user.lastName=_lastNameText.text;
            user.userName=_userNameText.text;
            user.email=_emailText.text;
            user.password=_passwordText.text;
            user.confirmPassword=_confirmPassText.text;
            //        user.=_genderText.text;
            //        user.city=_city.text;
            if ([_passwordText.text isEqualToString:_confirmPassText.text]) {
                [WebAPI registerUser:user completionHandler:^(BOOL isError, NSArray * data) {
                    if (isError) {
                        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
                        // [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                        [SVProgressHUD showErrorWithStatus:@"Not Updated Data"];
                        return;
                    }
                    
                    if (data) {
                        [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Listner added Successfully" waitUntilDone:NO];
                        //[self loadAlbumsData];
                        [self performSelectorOnMainThread:@selector(segueToLogin:) withObject:@"registerToLoginView" waitUntilDone:NO];
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
-(void)segueToLogin:(NSString *)text {
    NSAttributedString * message = [[NSAttributedString alloc] initWithString:text];
    [self performSegueWithIdentifier:text sender:self];
    
}
-(void)loadAlbumsData {
    
    // [self showProgressHUD];
    [WebAPI getAlbumsWithCompletionHandler:^(BOOL isError, NSArray *data) {
        if (!isError) {
            if (data) {
                NSLog(@"Albums %@",data);
//                _albumsDataArr=[[NSArray alloc] init];
//                _albumsDataArr=data;
//                _albumsNameArr=[[NSArray alloc] init];
                NSArray* albums=[data valueForKey:@"albums"];
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
@end
