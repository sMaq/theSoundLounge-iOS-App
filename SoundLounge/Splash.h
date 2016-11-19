//
//  ViewController.h
//  SoundLounge
//
//  Created by Apple on 24/04/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"

@interface Splash : BaseViewController

@property (nonatomic,weak) IBOutlet SMPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *backgoungImg;
@property (weak, nonatomic) IBOutlet UIButton *loginSlide3;
@property (weak, nonatomic) IBOutlet UILabel *orSlide3;
@property (weak, nonatomic) IBOutlet UIButton *signupSlide3;
@property (weak, nonatomic) IBOutlet UIButton *signUpSLide1;
@property (weak, nonatomic) IBOutlet UILabel *doYOuHaveSlide1;
@property (weak, nonatomic) IBOutlet UIButton *loginSlide2;

@end