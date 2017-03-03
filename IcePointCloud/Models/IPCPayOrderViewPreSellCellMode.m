//
//  IPCPayOrderViewCellMode.m
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewPreSellCellMode.h"
#import "IPCExpandShoppingCartCell.h"
#import "IPCHistoryOptometryCell.h"
#import "IPCCustomerAddressListCell.h"
#import "IPCOrderTopTableViewCell.h"
#import "IPCCartOrderMemoViewCell.h"
#import "IPCCartOrderCustomerCell.h"
#import "IPCExpandShoppingCartCell.h"
#import "IPCOrderPayTypeCell.h"
#import "IPCOrderPayStyleCell.h"
#import "IPCPayAmountStyleCell.h"

static NSString * const kNewShoppingCartItemName = @"ExpandableShoppingCartCellIdentifier";
static NSString * const ContactIdentifier    = @"ShoppingCustomerCellIdentifier";
static NSString * const opometryIdentifier = @"HistoryOptometryCellIdentifier";
static NSString * const addressIdentifier    = @"CustomerAddressListCellIdentifier";
static NSString * const titleIdentifier          = @"IPCOrderTopTableViewCellIdentifier";
static NSString * const memoIdentifier       = @"OrderMemoViewCellIdentifier";
static NSString * const payTypeIdentifier   = @"IPCOrderPayTypeCellIdentifier";
static NSString * const payStyleIdentifier   = @"IPCOrderPayStyleCellIdentifier";
static NSString * const payAmountStyleIdentifier = @"IPCPayAmountStyleCellIdentifier";

@implementation IPCPayOrderViewPreSellCellMode

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1)
        return 1;
    else if (section == 4)
        return  [[IPCShoppingCart sharedCart] selectNormalItemsCount];
    else if (section == 6){
        return [[IPCShoppingCart sharedCart] selectedPreSellItemsCount];
    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        IPCCartOrderCustomerCell * cell = [tableView dequeueReusableCellWithIdentifier:ContactIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCCartOrderCustomerCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        cell.currentCustomer = [IPCCurrentCustomerOpometry sharedManager].currentCustomer;
        return cell;
    }else if (indexPath.section == 1){
        IPCCartOrderMemoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:memoIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCCartOrderMemoViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        [cell.memoTextView setText:[IPCPayOrderMode sharedManager].orderMemo];
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            IPCOrderTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderTopTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"历史验光单信息"];
            return cell;
        }else{
            IPCHistoryOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:opometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCHistoryOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                [cell.selectButton setHidden:YES];
            }
            [cell setOptometryMode:[IPCCurrentCustomerOpometry sharedManager].currentOpometry];
            return cell;
        }
    }else if(indexPath.section == 3){
        if (indexPath.row == 0) {
            IPCOrderTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderTopTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"收货地址信息"];
            return cell;
        }else{
            IPCCustomerAddressListCell * cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerAddressListCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                [cell.chooseButton setHidden:YES];
                cell.leftLeading.constant = -38;
                cell.contactLeftLeading.constant = -38;
            }
            [cell.contactNameLabel setText:[NSString stringWithFormat:@"收货人:%@",[IPCCurrentCustomerOpometry sharedManager].currentAddress.contactName]];
            [cell.addressLabel setText:[NSString stringWithFormat:@"收货地址:%@",[IPCCurrentCustomerOpometry sharedManager].currentAddress.detailAddress]];
            [cell.contactPhoneLabel setText:[NSString stringWithFormat:@"联系电话:%@",[IPCCurrentCustomerOpometry sharedManager].currentAddress.phone]];
            return cell;
        }
    }else if(indexPath.section == 4 || indexPath.section == 6){
        IPCExpandShoppingCartCell * cell = [tableView dequeueReusableCellWithIdentifier:kNewShoppingCartItemName];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCExpandShoppingCartCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        IPCShoppingCartItem * cartItem = nil;
        if (indexPath.section == 4) {
            cartItem = [[IPCShoppingCart sharedCart] selectedNormalSelltemAtIndex:indexPath.row] ;
        }else{
            cartItem = [[IPCShoppingCart sharedCart] selectedPreSelltemAtIndex:indexPath.row] ;
        }
        
        if (cartItem){
            [cell setIsOrder:YES];
            [cell setCartItem:cartItem Reload:nil];
        }
        return cell;
    }else if (indexPath.section == 5 || indexPath.section == 7){
        if (indexPath.row == 0) {
            IPCOrderTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderTopTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"支付方式"];
            return cell;
        }else{
            IPCPayAmountStyleCell * cell = [tableView dequeueReusableCellWithIdentifier:payAmountStyleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPayAmountStyleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if (indexPath.section == 5) {
                cell.isPreSell = NO;
            }else{
                cell.isPreSell = YES;
            }
            [cell updateUI:^{
                if ([self.delegate respondsToSelector:@selector(reloadPayOrderView)]) {
                    [self.delegate reloadPayOrderView];
                }
            }];
            return cell;
        }
    }else if(indexPath.section == 8){
        if (indexPath.row == 0) {
            IPCOrderTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderTopTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"员工打折"];
            return cell;
        }else{
            IPCOrderPayTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:payTypeIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderPayTypeCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell updateUIWithEmployee:^{
                if ([self.delegate respondsToSelector:@selector(showEmployeeView)]) {
                    [self.delegate showEmployeeView];
                }
            } Update:^{
                if ([self.delegate respondsToSelector:@selector(reloadPayOrderView)]) {
                    [self.delegate reloadPayOrderView];
                }
            }];
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            IPCOrderTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderTopTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"选择结算方式"];
            return cell;
        }else{
            IPCOrderPayStyleCell * cell = [tableView dequeueReusableCellWithIdentifier:payStyleIdentifier];
            if (!cell)
                cell = [[UINib nibWithNibName:@"IPCOrderPayStyleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            [cell updateUIWithUpdate:^{
                [tableView reloadData];
            }];
            return cell;
        }
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        return 280;
    }else if (indexPath.section == 2 && indexPath.row > 0){
        return 180;
    }else if (indexPath.section == 1){
        return 100;
    }else if (indexPath.section == 8 && indexPath.row > 0){
        return 65;
    }else if (indexPath.section == 9 && indexPath.row > 0){
        return 155;
    }else if ((indexPath.section == 3 && indexPath.row > 0) || (indexPath.section == 5 && indexPath.row > 0) || (indexPath.section == 7 && indexPath.row > 0)){
        return 70;
    }else if (indexPath.section == 4 || indexPath.section == 6) {
        return 135;
    }
    return 60;
}


@end
