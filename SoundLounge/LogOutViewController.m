//
//  LogOutViewController.m
//  Fix it
//
//  Created by Test User on 29/03/2016.
//  Copyright © 2016 SMaq Tech. All rights reserved.
//

#import "LogOutViewController.h"
#import "Splash.h"
@interface LogOutViewController ()

@end

@implementation LogOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)viewWillAppear:(BOOL)animated
{
    [LocalStorage saveNewUser:@"" type:kUserTypeLogOut];
    // UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"nav"];
    NSLog(@"hello navigati");
    Splash *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"splash"];
    [self.navigationController pushViewController:vc animated:NO];
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

@end
