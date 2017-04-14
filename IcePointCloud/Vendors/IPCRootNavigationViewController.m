//
//  IPCRootNavigationViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCRootNavigationViewController.h"

@interface IPCRootNavigationViewController ()

@end

@implementation IPCRootNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setNavigationBarStatus:(BOOL)isHiden
{
    self.navigationController.navigationBarHidden = isHiden;
    
    if (!isHiden) {
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0, 0, 80, 40)];
        [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [backButton setAdjustsImageWhenHighlighted:NO];
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"icon_navigationBar"] forBarMetrics:UIBarMetricsDefault];
    }
}


- (void)setRightItem:(NSString *)itemImageName Selection:(SEL)selection
{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 80, 40)];
    [rightButton setImage:[UIImage imageNamed:itemImageName] forState:UIControlStateNormal];
    [rightButton setAdjustsImageWhenHighlighted:NO];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:selection forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


#pragma mark //Clicked Events
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
