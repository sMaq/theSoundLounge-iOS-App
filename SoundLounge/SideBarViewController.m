//
//  SideBarViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/14/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "SideBarViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "LogOutViewController.h"

@interface SideBarViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *createAlbum;
@property (weak, nonatomic) IBOutlet UITableViewCell *createEventCell;

@end

@implementation SideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    _createAlbum.hidden=YES;
    _createEventCell.hidden=YES;
    User * user = [LocalStorage getCurrentSavedUser];
    NSLog(@"Saved User ID: %@",user.userID);
    NSLog(@"Saved user type: %@",[LocalStorage getSaveUserType]== kUserTypeArtist ? @"artist":@"listener");
    _usernameTextField.text=user.userName;
    //_userProfileImageView.image=[UIImage imageNamed:user.logo];
//    if (([LocalStorage getSaveUserType]== kUserTypeArtist)) {
//        _createAlbum.hidden=NO;
//        _createEventCell.hidden=NO;
//    }
//    else{
//        _createAlbum.hidden=YES;
//        _createEventCell.hidden=YES;
//    }
    
}
- (IBAction)logoutButtonPressed:(UIButton *)sender {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        
        [revealViewController revealToggle:nil];
        
        AppDelegate * delegate = [UIApplication sharedApplication].delegate;
        
        UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        
        [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        
        [delegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
    }
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
   // destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"logout"]) {
        UINavigationController *navController = segue.destinationViewController;
        LogOutViewController *saveParkingController = [navController childViewControllers].firstObject;
        // NSString *photoFilename = [NSString stringWithFormat:@"%@_photo", [menuItems objectAtIndex:indexPath.row]];
        //photoController.photoFilename = photoFilename;
    }
}
@end
