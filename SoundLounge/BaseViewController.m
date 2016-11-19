//
//  BaseViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/24/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "BaseViewController.h"
#import "HotBoxNotification.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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


-(void)moveToViewControllerWithIdentifier:(NSString *)identifier{
    
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
    if (viewController != nil) {
        delegate.window.rootViewController = viewController;
        [delegate.window makeKeyAndVisible];
    }
    else {
        NSLog(@"Error navigating.. view controller is nil");
    }
    
}

+(void)moveToViewControllerWithIdentifier:(NSString *)identifier {
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
    if (viewController != nil) {
        delegate.window.rootViewController = viewController;
        [delegate.window makeKeyAndVisible];
    }
    else {
        NSLog(@"Error navigating.. view controller is nil");
    }
    
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Error: %@",error);
        if (!error) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            completionBlock(YES,image);
        }
        else {
            completionBlock(YES,[self imageFromColor:[UIColor blackColor]]);
        }
    }]resume];
    
    /*
     
     
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     [NSURLConnection sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
     if ( !error )
     {
     UIImage *image = [[UIImage alloc] initWithData:data];
     completionBlock(YES,image);
     } else{
     completionBlock(NO,nil);
     }
     }];
     
     */
    
}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



@end