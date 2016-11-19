//
//  Register.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/24/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "Register.h"
#import "SignUp.h"
@interface Register ()

@end

@implementation Register

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ArtistSegue"])
    {
        SignUp *vc = [segue destinationViewController];
        vc.checkUserType= 1;
        //vc.subFirmsArray = _subFirmList;
        
    }
    else if ([segue.identifier isEqualToString:@"ListnerSegue"])
        {
            SignUp *vc = [segue destinationViewController];
            vc.checkUserType= 2;
            //vc.subFirmsArray = _subFirmList;
            
        }
    //    else if ([segue.identifier isEqualToString:SEGUE_IntroVC_ToMembersVC])
    //    {
    //        WheelViewController *vc = [segue destinationViewController];
    //        //vc.subFirmsArray = _subFirmList;
    //
    //    }
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
