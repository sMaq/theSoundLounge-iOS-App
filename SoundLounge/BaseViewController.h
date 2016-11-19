//
//  BaseViewController.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/24/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAlertError @"Error"
#define kAlertWarning @"Warning"
#define kAlertSuccess @"Success"

@interface BaseViewController : UIViewController

-(void)showSuccessAlert:(NSString *)text;

-(void)showErrorAlert:(NSString*)text;

-(void)showProgressHUD;

-(void)hideProgressHUB;

-(void)showInfoAlert:(NSString*)text;

-(void)moveToViewControllerWithIdentifier:(NSString *)identifier;

+(void)moveToViewControllerWithIdentifier:(NSString *)identifier;

- (UIImage *)imageFromColor:(UIColor *)color;

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

@end
