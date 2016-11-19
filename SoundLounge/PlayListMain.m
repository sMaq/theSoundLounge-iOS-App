//
//  PlayListMain.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/26/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "PlayListMain.h"
#import "SWRevealViewController.h"

@interface PlayListMain()
@property (weak, nonatomic) IBOutlet UIButton *sideBarButton;

@end

@implementation PlayListMain

-(void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

}

@end
