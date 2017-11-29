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
#import "IPCCustomKeyboard.h"

@interface IPCPayOrderOfferOrderViewController ()

@property (nonatomic, strong) IPCShoppingCartView * shopCartView ;
@property (nonatomic, strong) IPCPayOrderOfferOrderInfoView * offerInfoView;
@property (nonatomic, strong) IPCCustomKeyboard * keyboard;

@end

@implementation IPCPayOrderOfferOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.shopCartView];
    [self.view addSubview:self.offerInfoView];
    [self.view addSubview:self.keyboard];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.shopCartView reload];
    [self updateUI];
}

#pragma mark //Set UI
- (IPCPayOrderOfferOrderInfoView *)offerInfoView{
    __weak typeof(self) weakSelf = self;
    if (!_offerInfoView) {
        _offerInfoView = [[IPCPayOrderOfferOrderInfoView alloc]initWithFrame:CGRectMake(self.shopCartView.jk_right+10, 10, 428, 290)
                                                                  EndEditing:^{
                                                                      __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                      [[IPCShoppingCart sharedCart] updateAllCartUnitPrice];
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
            [IPCPayOrderManager sharedManager].payAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrice];
            [strongSelf updateUI];
        }];
        _shopCartView.keyboard = self.keyboard;
    }
    return _shopCartView;
}

- (IPCCustomKeyboard *)keyboard
{
    if (!_keyboard) {
        _keyboard = [[IPCCustomKeyboard alloc]initWithFrame:CGRectMake(self.shopCartView.jk_right+10, self.offerInfoView.jk_bottom+10, 428, 335)];
    }
    return _keyboard;
}

#pragma mark //Clicked Events
- (void)updateUI
{
    if ([IPCPayOrderManager sharedManager].customDiscount > -1) {
        [IPCPayOrderManager sharedManager].payAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] * (double)([IPCPayOrderManager sharedManager].customDiscount/100);
        [IPCPayOrderManager sharedManager].discountAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] - [IPCPayOrderManager sharedManager].payAmount;
        [[IPCShoppingCart sharedCart] updateAllCartUnitPrice];
    }else{
        [IPCPayOrderManager sharedManager].discountAmount = [[IPCShoppingCart sharedCart] allGlassesTotalPrePrice] - [[IPCShoppingCart sharedCart] allGlassesTotalPrice];
        [IPCPayOrderManager sharedManager].discount = [[IPCPayOrderManager sharedManager] calculateDiscount];
    }
    
    [self.offerInfoView updateOrderInfo];
    [self.shopCartView reload];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
