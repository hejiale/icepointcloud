//
//  IPCPayOrderViewNormalSellCellMode.m
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewNormalSellCellMode.h"
#import "IPCCustomerOptometryCell.h"
#import "IPCCustomerAddressCell.h"
#import "IPCPayOrderTitleCell.h"
#import "IPCPayOrderCustomerCell.h"
#import "IPCPayOrderProductCell.h"
#import "IPCPayAmountStyleCell.h"

static NSString * const payOrderCartItemIdentifier = @"payOrderProductCellIdentifier";
static NSString * const ContactIdentifier    = @"ShoppingCustomerCellIdentifier";
static NSString * const opometryIdentifier = @"HistoryOptometryCellIdentifier";
static NSString * const addressIdentifier    = @"CustomerAddressListCellIdentifier";
static NSString * const titleIdentifier          = @"IPCOrderTopTableViewCellIdentifier";
static NSString * const payTypeIdentifier   = @"IPCOrderPayTypeCellIdentifier";
static NSString * const payStyleIdentifier   = @"IPCOrderPayStyleCellIdentifier";
static NSString * const payAmountStyleIdentifier = @"IPCPayAmountStyleCellIdentifier";


@implementation IPCPayOrderViewNormalSellCellMode

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 5)
        return 1;
    else if (section == 3)
        return  [[IPCShoppingCart sharedCart] selectedItemsCount];
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        IPCPayOrderCustomerCell * cell = [tableView dequeueReusableCellWithIdentifier:ContactIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPayOrderCustomerCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        cell.currentCustomer = [IPCCurrentCustomerOpometry sharedManager].currentCustomer;
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            IPCPayOrderTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPayOrderTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"历史验光信息"];
            return cell;
        }else{
            IPCCustomerOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:opometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setOptometryMode:[IPCCurrentCustomerOpometry sharedManager].currentOpometry];
            return cell;
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            IPCPayOrderTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPayOrderTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"收货地址信息"];
            return cell;
        }else{
            IPCCustomerAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerAddressCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
//            [cell.contactNameLabel setText:[NSString stringWithFormat:@"收货人:%@",[IPCCurrentCustomerOpometry sharedManager].currentAddress.contactName]];
//            [cell.addressLabel setText:[NSString stringWithFormat:@"收货地址:%@",[IPCCurrentCustomerOpometry sharedManager].currentAddress.detailAddress]];
//            [cell.contactPhoneLabel setText:[NSString stringWithFormat:@"联系电话:%@",[IPCCurrentCustomerOpometry sharedManager].currentAddress.phone]];
            return cell;
        }
    }else if(indexPath.section == 3){
        IPCPayOrderProductCell * cell = [tableView dequeueReusableCellWithIdentifier:payOrderCartItemIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPayOrderProductCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] selectedItemAtIndex:indexPath.row] ;
        if (cartItem){
            [cell setCartItem:cartItem];
        }
        return cell;
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            IPCPayOrderTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPayOrderTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"选择支付方式"];
            return cell;
        }else{
            IPCPayAmountStyleCell * cell = [tableView dequeueReusableCellWithIdentifier:payAmountStyleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPayAmountStyleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell updateUI:^{
                if ([self.delegate respondsToSelector:@selector(reloadPayOrderView)]) {
                    [self.delegate reloadPayOrderView];
                }
            }];
            if ([[IPCShoppingCart sharedCart] selectedPreSellItemsCount] == 0) {
                cell.isPreSell = YES;
            }else{
                cell.isPreSell = NO;
            }
            return cell;
        }
    }else{
        IPCPayOrderTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPayOrderTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        [cell.topTitleLabel setText:@"员工打折"];
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return 285;
    }else if (indexPath.section == 1 && indexPath.row > 0){
        return 180;
    }else if ((indexPath.section == 2 && indexPath.row > 0) || (indexPath.section == 4 && indexPath.row > 0) ){
        return 70;
    }else if (indexPath.section == 3) {
        return 135;
    }
    return 60;
}


@end
