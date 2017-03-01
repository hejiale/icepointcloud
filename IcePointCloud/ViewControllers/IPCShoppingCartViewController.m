//
//  ShoppingCartViewController.m
//  IcePointCloud
//
//  Created by mac on 8/1/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCShoppingCartViewController.h"
#import "IPCExpandShoppingCartCell.h"
#import "IPCCustomerViewController.h"
#import "IPCShoppingCart.h"
#import "IPCCartViewMode.h"
#import "IPCCartItemViewCellMode.h"
#import "IPCPayOrderView.h"
#import "IPCEmployeListView.h"
#import "IPCPaySuccessView.h"

@interface IPCShoppingCartViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton       *selectAllBtn;
@property (nonatomic, weak) IBOutlet UITableView *glassListView;
@property (nonatomic, weak) IBOutlet UILabel        *totalPriceLbl;
@property (nonatomic, weak) IBOutlet UIButton      *checkoutBtn;
@property (nonatomic, weak) IBOutlet UIButton      *checkoutConfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton      *deleteButton;
@property (weak, nonatomic) IBOutlet UIView         *cartBottomView;
@property (strong, nonatomic) IPCPayOrderView    *payOrderView;
@property (strong, nonatomic) IPCCartViewMode    *cartViewMode;
@property (strong, nonatomic) IPCCartItemViewCellMode * cartItemViewCellMode;
@property (strong, nonatomic) IPCEmployeListView * employeView;
@property (strong, nonatomic) IPCPaySuccessView  * paySuccessView;

@end

@implementation IPCShoppingCartViewController




#pragma mark //Offer Order
- (void)offerOrder{
    [self.checkoutConfirmBtn jk_showIndicator];
    
    [self.cartViewMode offerOrderWithCashBlock:^{
        [self successPayOrder];
    } EbuyBlock:^(IPCOrder *result) {
        [self showPopoverOrderBgView:result];
    } Failed:^{
        [self.checkoutConfirmBtn jk_hideIndicator];
    }];
}

#pragma mark //Set UI
- (IPCPayOrderView *)payOrderView{
    __weak typeof (self) weakSelf = self;
    if (!_payOrderView)
        _payOrderView = [[IPCPayOrderView alloc]initWithFrame:self.glassListView.frame SelectEmploye:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf loadEmployeView];
        } UpdateOrder:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.payOrderView reloadData];
            [strongSelf updateTotalPrice];
        }];
    return _payOrderView;
}


- (void)loadPayOrderView{
    [self.view addSubview:self.payOrderView];
    [self.view bringSubviewToFront:self.payOrderView];
}

- (void)loadEmployeView{
    __weak typeof (self) weakSelf = self;
    self.employeView = [[IPCEmployeListView alloc]initWithFrame:self.view.bounds DismissBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.employeView removeFromSuperview];self.employeView = nil;
        [strongSelf.payOrderView reloadData];
        [strongSelf updateTotalPrice];
    }];
    [self.view addSubview:self.employeView];
    [self.view bringSubviewToFront:self.employeView];
}




- (IBAction)onCheckoutBtnTapped:(id)sender
{
    __weak typeof (self) weakSelf = self;
    if ( ! [self.cartViewMode shoppingCartIsEmpty]){
        if ([IPCCurrentCustomerOpometry sharedManager].currentCustomer && [IPCCurrentCustomerOpometry sharedManager].currentAddress &&[IPCCurrentCustomerOpometry sharedManager].currentOpometry)
        {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf loadPayOrderView];
        }else{
            [IPCUIKit showAlert:@"冰点云" Message:@"请先前去验光页面选择客户验光信息!" Owner:self Done:^{
                [IPCUIKit pushToRootIndex:2];
            }];
        }
    }else{
        [IPCUIKit showError:@"购物车中未选中任何商品!"];
    }
}


- (IBAction)onCheckoutConfirmBtnTapped:(id)sender
{
    if (! [IPCPayOrderMode sharedManager].currentEmploye) {
        [IPCUIKit showError:@"请先选择员工"];
    }else if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeNone) {
        [IPCUIKit showError:@"请选择支付方式"];
    }else if ([IPCPayOrderMode sharedManager].payStyle == IPCPayStyleTypeNone){
        [IPCUIKit showError:@"请选择结算方式"];
    }else if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeInstallment && [IPCPayOrderMode sharedManager].prepaidAmount <= 0){
        [IPCUIKit showError:@"请输入预付金额"];
    }else{
        [self offerOrder];
    }
}

- (void)showPopoverOrderBgView:(IPCOrder *)result{
    __weak typeof (self) weakSelf = self;
    self.paySuccessView = [[IPCPaySuccessView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds OrderInfo:result Dismiss:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.paySuccessView removeFromSuperview];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.paySuccessView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.paySuccessView];
    [self successPayOrder];
}


#pragma mark //Reload cart State
- (void)updateUI
{
    [self updateTotalPrice];
    [self.employeView removeFromSuperview];
    [self.selectAllBtn setSelected:[self.cartViewMode judgeCartItemSelectState]];
    [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:IPCShoppingCartCountKey object:nil];
}

- (void)updateTotalPrice
{
    NSString * totalPrice;
    if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount) {
        if ([IPCPayOrderMode sharedManager].currentEmploye && [IPCPayOrderMode sharedManager].isSelectEmploye)
            totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [IPCPayOrderMode sharedManager].employeAmount];
        else
            totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]];
    }else if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeInstallment){
        totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [IPCPayOrderMode sharedManager].prepaidAmount];
    }else{
        totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]];
    }
    [self.totalPriceLbl setAttributedText:[IPCUIKit subStringWithText:totalPrice BeginRang:0 Rang:3 Font:[UIFont systemFontOfSize:14 weight:UIFontWeightThin] Color:[UIColor blackColor]]];
}


- (void)successPayOrder{
    [[IPCShoppingCart sharedCart] removeSelectCartItem];
    [[IPCCurrentCustomerOpometry sharedManager] clearData];
    [self.checkoutConfirmBtn jk_hideIndicator];
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
