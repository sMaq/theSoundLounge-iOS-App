//
//  UploadSongViewController.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/15/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "UploadSongViewController.h"
#import "SWRevealViewController.h"

@interface UploadSongViewController ()

@end

@implementation UploadSongViewController

- (IBAction)search:(UIButton *)sender {
    UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];
    [self presentViewController:viewController animated:YES completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController * revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
