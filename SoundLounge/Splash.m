//
//  ViewController.m
//  SoundLounge
//
//  Created by Apple on 24/04/2016.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "Splash.h"
#import "SMPageControl.h"
@interface Splash ()

@end

@implementation Splash

@synthesize pageControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{

    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    _orSlide3.hidden=YES;
    _loginSlide3.hidden=YES;
    _signupSlide3.hidden=YES;
    _loginSlide2.hidden=YES;
    _backgoungImg.image=[UIImage imageNamed:@"slide1back-1"];
    pageControl.numberOfPages = 3;
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"slide"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"active-slider"];
    
    [self.pageControl addTarget:self action:@selector(pageControl:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"%ld current page ",(long)pageControl.currentPage);
    
    
}
- (void)pageControl:(id)sender
{
    NSLog(@"Current Page (UIPageControl) : %li", (long)self.pageControl.currentPage);
    if (self.pageControl.currentPage==0)
    {
        _backgoungImg.image=[UIImage imageNamed:@"slide1back-1"];
        _orSlide3.hidden=YES;
        _loginSlide3.hidden=YES;
        _signupSlide3.hidden=YES;
        _loginSlide2.hidden=YES;
        _signUpSLide1.hidden=NO;
        _doYOuHaveSlide1.hidden=NO;
    }
    else if (self.pageControl.currentPage==1)
    {
        _backgoungImg.image=[UIImage imageNamed:@"slide2back-1"];
        _orSlide3.hidden=YES;
        _loginSlide3.hidden=YES;
        _signupSlide3.hidden=YES;
        _loginSlide2.hidden=NO;
        _signUpSLide1.hidden=YES;
        _doYOuHaveSlide1.hidden=YES;
    }
    else if (self.pageControl.currentPage==2)
    {
        _backgoungImg.image=[UIImage imageNamed:@"slide3back-1"];
        _orSlide3.hidden=NO;
        _loginSlide3.hidden=NO;
        _signupSlide3.hidden=NO;
        _loginSlide2.hidden=YES;
        _signUpSLide1.hidden=YES;
        _doYOuHaveSlide1.hidden=YES;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
