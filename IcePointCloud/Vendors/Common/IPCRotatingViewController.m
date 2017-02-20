//
//  CustomViewController.m
//  IcePointCloud
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRotatingViewController.h"

@interface IPCRotatingViewController ()

@end

@implementation IPCRotatingViewController

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
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return  UIInterfaceOrientationPortrait;
}

@end
