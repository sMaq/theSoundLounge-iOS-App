//
//  ContactUs.h
//  SoundLounge
//
//  Created by Apple on 01/05/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUs : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextView *message;
- (IBAction)submitBtnClicked:(id)sender;

@end
