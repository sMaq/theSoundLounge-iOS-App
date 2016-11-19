//
//  ContactUs.m
//  SoundLounge
//
//  Created by Apple on 01/05/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "ContactUs.h"
#import "SWRevealViewController.h"
#import "BAAlertController.h"
#import "HotBoxNotification.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
@interface ContactUs ()
@property (weak, nonatomic) IBOutlet UIButton *sideBarButton;

@end

@implementation ContactUs

- (IBAction)search:(UIButton *)sender {
    
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    
    [self.view viewWithTag:1].layer.borderColor = [UIColor colorWithWhite:.85 alpha:1].CGColor;
    
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)submitBtnClicked:(id)sender {
    if (self.name.text != nil &&
        ![self.name.text isEqualToString:@""] && self.email.text != nil &&
        ![self.email.text isEqualToString:@""] && self.message.text != nil &&
        ![self.message.text isEqualToString:@""]
        
        )
    {
        
        
        [SVProgressHUD show];
        
        [WebAPI  contactUSWithName:_name.text email:_email.text message:_message.text  CompletionHandler:^(BOOL isError, NSArray * data) {
            if (isError) {
                [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:kError_Network waitUntilDone:NO];
                // [self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
                [SVProgressHUD showErrorWithStatus:@"Message not sended"];
                return;
            }
            
            if (data) {
                [self performSelectorOnMainThread:@selector(showSuccessAlert:) withObject:@"Message sended Successfully" waitUntilDone:NO];
               
            }
            [SVProgressHUD showSuccessWithStatus:@"Message sended Successfully"];
            //[self performSelectorOnMainThread:@selector(hideProgressHUB) withObject:nil waitUntilDone:NO];
            
        }];
        
        
        
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"All fields must be filled." waitUntilDone:NO];
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
