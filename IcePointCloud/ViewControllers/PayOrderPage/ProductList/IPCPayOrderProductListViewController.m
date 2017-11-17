//
//  IPCPayOrderProductListViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderProductListViewController.h"
#import "IPCShoppingCartView.h"


@interface IPCPayOrderProductListViewController ()

@end

@implementation IPCPayOrderProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    IPCShoppingCartView * shopCartView = [[IPCShoppingCartView alloc]initWithFrame:CGRectMake(0, 0, 490, self.view.jk_height) Complete:nil];
    [self.view addSubview:shopCartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
