//
//  ForgotPassViewController.h
//  SoundLounge
//
//  Created by Shahzaib Maqbool on 13/07/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLGlowingTextField.h"
#import "DLRadioButton.h"
@interface ForgotPassViewController : UIViewController
@property (weak, nonatomic) IBOutlet SLGlowingTextField *usernameTxt;
@property (weak, nonatomic) IBOutlet DLRadioButton *userTypeButton;

- (IBAction)RequestPassBtnClicked:(id)sender;
@end
