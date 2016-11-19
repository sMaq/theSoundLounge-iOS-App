//
//  AlbumDetailPopover.m
//  SoundLounge
//
//  Created by Apple on 30/04/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "AlbumDetailPopover.h"

@interface AlbumDetailPopover ()

@end

@implementation AlbumDetailPopover

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
