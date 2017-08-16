//
//  IPCLandscapeViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/8/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPortraitViewController.h"

@interface IPCPortraitViewController ()

@end

@implementation IPCPortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
