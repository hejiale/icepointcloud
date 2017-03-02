//
//  ShoppingCartViewController.m
//  IcePointCloud
//
//  Created by mac on 8/1/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCShoppingCartViewController.h"

@implementation IPCShoppingCartViewController




#pragma mark //Offer Order
//- (void)offerOrder{
//    [self.checkoutConfirmBtn jk_showIndicator];
//    
//    [self.cartViewMode offerOrderWithCashBlock:^{
//        [self successPayOrder];
//    } EbuyBlock:^(IPCOrder *result) {
//        [self showPopoverOrderBgView:result];
//    } Failed:^{
//        [self.checkoutConfirmBtn jk_hideIndicator];
//    }];
//}

#pragma mark //Set UI
//- (IPCPayOrderView *)payOrderView{
//    __weak typeof (self) weakSelf = self;
//    if (!_payOrderView)
//        _payOrderView = [[IPCPayOrderView alloc]initWithFrame:self.glassListView.frame SelectEmploye:^{
//            __strong typeof (weakSelf) strongSelf = weakSelf;
//            [strongSelf loadEmployeView];
//        } UpdateOrder:^{
//            __strong typeof (weakSelf) strongSelf = weakSelf;
//            [strongSelf.payOrderView reloadData];
//            [strongSelf updateTotalPrice];
//        }];
//    return _payOrderView;
//}

//


//
//
//
//
//- (void)showPopoverOrderBgView:(IPCOrder *)result{
//    __weak typeof (self) weakSelf = self;
//    self.paySuccessView = [[IPCPaySuccessView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds OrderInfo:result Dismiss:^{
//        __strong typeof (weakSelf) strongSelf = weakSelf;
//        [strongSelf.paySuccessView removeFromSuperview];
//    }];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.paySuccessView];
//    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.paySuccessView];
//    [self successPayOrder];
//}


#pragma mark //Reload cart State
//- (void)updateUI
//{
//    [self updateTotalPrice];
//    [self.employeView removeFromSuperview];
//    [self.selectAllBtn setSelected:[self.cartViewMode judgeCartItemSelectState]];
//    [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:IPCShoppingCartCountKey object:nil];
//}
//
//- (void)updateTotalPrice
//{
//    NSString * totalPrice;
//    if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount) {
//        if ([IPCPayOrderMode sharedManager].currentEmploye && [IPCPayOrderMode sharedManager].isSelectEmploye)
//            totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [IPCPayOrderMode sharedManager].employeAmount];
//        else
//            totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]];
//    }else if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeInstallment){
//        totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [IPCPayOrderMode sharedManager].prepaidAmount];
//    }else{
//        totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]];
//    }
//    [self.totalPriceLbl setAttributedText:[IPCUIKit subStringWithText:totalPrice BeginRang:0 Rang:3 Font:[UIFont systemFontOfSize:14 weight:UIFontWeightThin] Color:[UIColor blackColor]]];
//}
//
//
//- (void)successPayOrder{
//    [[IPCShoppingCart sharedCart] removeSelectCartItem];
//    [[IPCCurrentCustomerOpometry sharedManager] clearData];
//    [self.checkoutConfirmBtn jk_hideIndicator];
//}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
