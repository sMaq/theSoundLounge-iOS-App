//
//  Login.m
//  SoundLounge
//
//  Created by Apple on 29/04/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "Login.h"
#import "SLGlowingTextField.h"
#import "DLRadioButton.h"

@interface Login ()
@property (weak, nonatomic) IBOutlet SLGlowingTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet SLGlowingTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet DLRadioButton *userTypeButton;

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    if (self.userNameTextField.text != nil &&
        self.passwordTextField.text != nil) {
        NSString * type = self.userTypeButton.selectedButton.titleLabel.text;
        NSLog(@"type: %@",type);
        if ([type isEqualToString:@"Artist"]) {
            [WebAPI loginArtistWithEmail:self.userNameTextField.text password:self.passwordTextField.text completionHandler:^(BOOL isError, NSArray *data) {
                if (!isError) {
                    
                    NSDictionary * tempData = (NSDictionary *)data;
                    NSLog(@"msg: %@",tempData[@"msg"]);
                    if (tempData[@"msg"] == nil) {
                        Artist * artist = [Artist parseArtistFromDictionary:tempData];
                        [LocalStorage saveNewUser:artist type:kUserTypeArtist];
                        [self performSelectorOnMainThread:@selector(moveToViewControllerWithIdentifier:) withObject:@"main" waitUntilDone:NO];

                    }
                    else {
                        NSString * msg = tempData[@"msg"];
                        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:msg waitUntilDone:NO];
                    }
                }
                else {
                    [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"There was an error.. Please try again" waitUntilDone:NO];
                }
            }];
        }
        else {
            [WebAPI loginListenerWithEmail:self.userNameTextField.text password:self.passwordTextField.text completionHandler:^(BOOL isError, NSArray *data) {
                if (!isError) {
                    
                    NSDictionary * tempData = (NSDictionary *)data;
                    if (tempData[@"msg"] == nil) {
                        User * listener = [User parseUserFromDictionary:tempData];
                        [LocalStorage saveNewUser:listener type:kUserTypeListener];
                        [self performSelectorOnMainThread:@selector(moveToViewControllerWithIdentifier:) withObject:@"main" waitUntilDone:NO];
                        
                    }
                    else {
                        NSString * msg = tempData[@"msg"];
                        [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:msg waitUntilDone:NO];
                    }
                }
                else {
                    [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:@"There was an error.. Please try again" waitUntilDone:NO];
                }
            }];
        }
    }
}


-(void)setupUI {
    UIColor * appColor = [UIColor colorWithRed:39.0f/255.0f green:166.0f/255.0f blue:149.0f/255.0f alpha:1];
    
    
    SLGlowingTextField * field = (SLGlowingTextField *)[self.view viewWithTag:1];
    [field setFloatingLabelActiveTextColor:appColor];
    //[field setFloatingLabelTextColor:appColor];
    [field setFloatingLabelYPadding:5.0];
    [field setGlowingColor:appColor];
    [field setTextColor:appColor];
    
    field = (SLGlowingTextField *)[self.view viewWithTag:2];
    [field setFloatingLabelActiveTextColor:appColor];
    //[field setFloatingLabelTextColor:appColor];
    [field setFloatingLabelYPadding:5.0];
    [field setGlowingColor:appColor];
    [field setTextColor:appColor];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
