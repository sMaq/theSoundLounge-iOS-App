//
//  ForgotPassViewController.m
//  SoundLounge
//
//  Created by Shahzaib Maqbool on 13/07/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "ForgotPassViewController.h"
#import "SVProgressHUD.h"
#import "BAAlertController.h"
#import "HotBoxNotification.h"
#import "Splash.h"
@interface ForgotPassViewController ()

@end

@implementation ForgotPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)RequestPassBtnClicked:(id)sender {
    NSString * type = self.userTypeButton.selectedButton.titleLabel.text;
    if (self.usernameTxt.text != nil && type !=nil) {
        
        NSLog(@"type: %@",type);
        [WebAPI ForgotPassWithEmail:_usernameTxt.text type:type completionHandler:^(BOOL isError, NSArray *data) {
            if (!isError) {
                
                NSDictionary * tempData = (NSDictionary *)data;
                NSLog(@"msg: %@",tempData[@"msg"]);
                if (tempData[@"msg"] == nil) {
                    
                   // Artist * artist = [Artist parseArtistFromDictionary:tempData];
                    //[LocalStorage saveNewUser:artist type:kUserTypeArtist];
                   // [self performSelectorOnMainThread:@selector(moveToViewControllerWithIdentifier:) withObject:@"main" waitUntilDone:NO];
                    
                }
                else {
                    NSString * msg = tempData[@"msg"];
                    [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:msg waitUntilDone:NO];
                     [self performSegueWithIdentifier:@"forgotPassToSplashView" sender:self];
                }
            }
            else {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"There was an error.. Please try again" waitUntilDone:NO];
            }
        }];

    }
    else
    {
        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"Please enter username/type field." waitUntilDone:NO];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"forgotPassToSplashView"]) {
        
        Splash * playerVC = (Splash*)segue.destinationViewController;
        
    
        
    }
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

@end
