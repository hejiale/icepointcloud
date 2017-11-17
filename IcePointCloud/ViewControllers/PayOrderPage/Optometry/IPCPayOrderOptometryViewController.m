//
//  IPCPayOrderOptometryViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOptometryViewController.h"
#import "IPCPayOrderOptometryHeadView.h"
#import "IPCPayOrderOptometryInfoView.h"
#import "IPCPayOrderOptometryMemoView.h"

#import "IPCPayOrderInputOptometryHeadView.h"
#import "IPCPayOrderInputOptometryView.h"
#import "IPCPayOrderInputOptometryMemoView.h"

@interface IPCPayOrderOptometryViewController ()

@end

@implementation IPCPayOrderOptometryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    IPCPayOrderInputOptometryHeadView * headView = [[IPCPayOrderInputOptometryHeadView alloc]initWithFrame:CGRectMake(0, 20, self.view.jk_width-20, 150)];
    [self.view addSubview:headView];
    
    /*IPCPayOrderOptometryHeadView * headView = [[IPCPayOrderOptometryHeadView alloc]initWithFrame:CGRectMake(20, 20, self.view.jk_width-40, 150)];
    [self.view addSubview:headView];
    IPCPayOrderOptometryInfoView * infoView = [[IPCPayOrderOptometryInfoView alloc]initWithFrame:CGRectMake(20, headView.jk_bottom+20, self.view.jk_width-40, 375)];
    [self.view addSubview:infoView];
    IPCPayOrderOptometryMemoView * memoView = [[IPCPayOrderOptometryMemoView alloc]initWithFrame:CGRectMake(20, infoView.jk_bottom+20, self.view.jk_width-40, 60)];
    [self.view addSubview:memoView];*/

    
    IPCPayOrderInputOptometryView * infoView = [[IPCPayOrderInputOptometryView alloc]initWithFrame:CGRectMake(0, headView.jk_bottom+20, self.view.jk_width-20, 375)];
    [self.view addSubview:infoView];
    
    IPCPayOrderInputOptometryMemoView * memoView = [[IPCPayOrderInputOptometryMemoView alloc]initWithFrame:CGRectMake(0, infoView.jk_bottom+20, self.view.jk_width-20, 60)];
    [self.view addSubview:memoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
