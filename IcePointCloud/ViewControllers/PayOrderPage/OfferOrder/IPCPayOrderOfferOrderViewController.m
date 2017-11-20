//
//  IPCPayOrderProductListViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOfferOrderViewController.h"
#import "IPCShoppingCartView.h"
#import "IPCPayOrderOfferOrderInfoView.h"

@interface IPCPayOrderOfferOrderViewController ()

@property (nonatomic, strong) IPCShoppingCartView * shopCartView ;

@end

@implementation IPCPayOrderOfferOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _shopCartView = [[IPCShoppingCartView alloc]initWithFrame:CGRectMake(0, 0, 490, self.view.jk_height) Complete:^{
        
    }];
    [self.view addSubview:_shopCartView];
    
    IPCPayOrderOfferOrderInfoView * offerInfoView = [[IPCPayOrderOfferOrderInfoView alloc]initWithFrame:CGRectMake(self.shopCartView.jk_right+10, 10, 428, 290)];
    [self.view addSubview:offerInfoView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.shopCartView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
