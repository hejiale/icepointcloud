//
//  IPCPayOrderProductListViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOfferOrderViewController.h"
#import "IPCPayOrderShoppingCartView.h"
#import "IPCPayOrderOfferOrderInfoView.h"

@interface IPCPayOrderOfferOrderViewController ()

@property (nonatomic, strong) IPCPayOrderShoppingCartView * shopCartView ;
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
    
    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[IPCTextFiledControl instance] clearPreTextField];
}

#pragma mark //Set UI
- (IPCPayOrderOfferOrderInfoView *)offerInfoView{
    __weak typeof(self) weakSelf = self;
    if (!_offerInfoView) {
        _offerInfoView = [[IPCPayOrderOfferOrderInfoView alloc]initWithFrame:CGRectMake(self.shopCartView.jk_right+10, 10, 408, 290)
                                                                  EndEditing:^{
                                                                      __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                      [strongSelf.shopCartView reload];
                                                                  }];
    }
    return _offerInfoView;
}

- (IPCPayOrderShoppingCartView *)shopCartView
{
    if (!_shopCartView) {
        __weak typeof(self) weakSelf = self;
        _shopCartView = [[IPCPayOrderShoppingCartView alloc]initWithFrame:CGRectMake(0, 0, 490, self.view.jk_height) Complete:^{
            [weakSelf updateUI];
        }];
        _shopCartView.keyboard = self.keyboard;
    }
    return _shopCartView;
}

- (IPCCustomKeyboard *)keyboard{
    if (!_keyboard)
        _keyboard = [[IPCCustomKeyboard alloc]initWithFrame:CGRectMake(self.shopCartView.jk_right+10, self.offerInfoView.jk_bottom+10, 408, 335)];
    return _keyboard;
}

#pragma mark //Clicked Events
- (void)updateUI
{
    [[IPCPayOrderManager sharedManager] calculatePayAmount];
    [self.offerInfoView updateOrderInfo];
    [self.shopCartView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window){
        self.view = nil;
        self.shopCartView = nil;
        self.offerInfoView = nil;
        self.keyboard = nil;
        [IPCHttpRequest cancelAllRequest];
    }
}




@end
