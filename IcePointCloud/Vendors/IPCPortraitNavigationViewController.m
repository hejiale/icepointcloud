//
//  CustomNavigationViewController.m
//  IcePointCloud
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPortraitNavigationViewController.h"

@interface IPCPortraitNavigationViewController ()

@end

@implementation IPCPortraitNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark //UIInterfaceOrientation
- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return  UIInterfaceOrientationPortrait;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
