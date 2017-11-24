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
@property (nonatomic, strong) IPCPayOrderOfferOrderInfoView * offerInfoView;

@end

@implementation IPCPayOrderOfferOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.shopCartView];
    [self.view addSubview:self.offerInfoView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.shopCartView reload];
    [self reloadOfferOrderInfo];
}

#pragma mark //Set UI
- (IPCPayOrderOfferOrderInfoView *)offerInfoView{
    __weak typeof(self) weakSelf = self;
    if (!_offerInfoView) {
        _offerInfoView = [[IPCPayOrderOfferOrderInfoView alloc]initWithFrame:CGRectMake(self.shopCartView.jk_right+10, 10, 428, 290)
                                                                  EndEditing:^{
                                                                      __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                      [[IPCShoppingCart sharedCart] updateAllCartItemDiscount];
                                                                      [strongSelf.shopCartView reload];
                                                                  }];
    }
    return _offerInfoView;
}

- (IPCShoppingCartView *)shopCartView
{
    __weak typeof(self) weakSelf = self;
    if (!_shopCartView) {
        _shopCartView = [[IPCShoppingCartView alloc]initWithFrame:CGRectMake(0, 0, 490, self.view.jk_height) Complete:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [[IPCPayOrderManager sharedManager] clearPayRecord];
            [strongSelf reloadOfferOrderInfo];
        }];
    }
    return _shopCartView;
}

#pragma mark //Clicked Events
- (void)reloadOfferOrderInfo
{
    [IPCPayOrderManager sharedManager].payAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrice];
    [IPCPayOrderManager sharedManager].discount = [[IPCPayOrderManager sharedManager] calculateDiscount];
    [IPCPayOrderManager sharedManager].discountAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] * ([IPCPayOrderManager sharedManager].discount/100);
    [self.offerInfoView updateOrderInfo];
}

- (void)updateUI
{
    [self.shopCartView reload];
    [self reloadOfferOrderInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
