//
//  IPCPayOrderViewNormalSellCellMode.m
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewMode.h"
#import "IPCCustomerTopTitleCell.h"
#import "IPCCustomerDetailCell.h"
#import "IPCPayOrderProductCell.h"
#import "IPCCustomerAddressCell.h"
#import "IPCCustomerOptometryCell.h"
#import "IPCPayOrderEmployeeCell.h"
#import "IPCPayOrderSettlementCell.h"
#import "IPCCustomsizedProductCell.h"
#import "IPCCustomsizedRightParameterCell.h"
#import "IPCCustomsizedLeftParameterCell.h"
#import "IPCPayOrderViewCellMode.h"

static NSString * const payOrderCartItemIdentifier = @"payOrderProductCellIdentifier";
static NSString * const customerIdentifier              = @"IPCCustomerDetailCellIdentifier";
static NSString * const opometryIdentifier              = @"HistoryOptometryCellIdentifier";
static NSString * const addressIdentifier                = @"CustomerAddressListCellIdentifier";
static NSString * const titleIdentifier                      = @"IPCOrderTopTableViewCellIdentifier";
static NSString * const employeeIdentifier             = @"IPCPayOrderEmployeeCellIdentifier";
static NSString * const settlementIdentifier           = @"IPCPayOrderSettlementCellIdentifier";
static NSString * const customsizedProIdentifier   = @"IPCCustomsizedProductCellIdentifier";
static NSString * const rightEyeIdentifier               = @"IPCCustomsizedRightParameterCellIdentifier";
static NSString * const leftEyeIdentifier                  = @"IPCCustomsizedLeftParameterCellIdentifier";

@interface IPCPayOrderViewMode()<IPCPayOrderSubViewDelegate>

@property (nonatomic, strong) IPCPayOrderViewCellMode * cellMode;

@end

@implementation IPCPayOrderViewMode

- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellMode = [[IPCPayOrderViewCellMode alloc] init];
    }
    return self;
}

#pragma mark //Request Data
- (void)requestTradeOrExchangeStatus{
    [IPCCustomUI show];
    [IPCPayOrderRequestManager getStatusTradeOrExchangeWithSuccessBlock:^(id responseValue) {
        [IPCPayOrderMode sharedManager].isTrade = [responseValue boolValue];
        
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(reloadPayOrderView)]) {
                [self.delegate reloadPayOrderView];
            }
        }
        [IPCCustomUI hiden];
    } FailureBlock:^(NSError *error) {
        [IPCCustomUI showError:error.domain];
    }];
}

- (void)requestOrderPointPrice:(NSInteger)point
{
    [IPCPayOrderRequestManager getIntegralRulesWithCustomerID:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerID
                                              IsPresellStatus:([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount ? @"false":@"true")
                                                        Point:point
                                                 SuccessBlock:^(id responseValue)
     {
         IPCPointValueMode * pointValue = [[IPCPointValueMode alloc] initWithResponseObject:responseValue];
         [[IPCPayOrderMode sharedManager] calculatePointValue:pointValue];
         
         if (self.delegate) {
             if ([self.delegate respondsToSelector:@selector(reloadPayOrderView)]) {
                 [self.delegate reloadPayOrderView];
             }
         }
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}


- (void)offerOrder{
    [IPCPayOrderRequestManager offerOrderWithSuccessBlock:^(id responseValue)
     {
         IPCOrder *result = [IPCOrder mj_objectWithKeyValues:responseValue];
         
         if ([self.delegate respondsToSelector:@selector(showPaySuccessViewWithOrderInfo:)]) {
             [self.delegate showPaySuccessViewWithOrderInfo:result];
         }
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}

#pragma mark //DO Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([IPCCurrentCustomerOpometry sharedManager].currentCustomer) {
        return 6;
    }
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ((section == 4 && [IPCCurrentCustomerOpometry sharedManager].currentCustomer) || (![IPCCurrentCustomerOpometry sharedManager].currentCustomer && section == 1))
    {
        if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens)
        {
            if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeUnified)
                return 3 + [IPCCustomsizedItem sharedItem].normalProducts.count;
            return 4 + [IPCCustomsizedItem sharedItem].normalProducts.count;
        }
        return  [[IPCShoppingCart sharedCart] selectPayItemsCount] + 1;
    }
    else if ((![IPCCurrentCustomerOpometry sharedManager].currentCustomer && section == 2) || ([IPCCurrentCustomerOpometry sharedManager].currentCustomer && section == 5))
        return 1;
    else if ( ((![IPCCurrentCustomerOpometry sharedManager].currentCustomer && section == 0) || ([IPCCurrentCustomerOpometry sharedManager].currentCustomer && section == 3)) && [IPCPayOrderMode sharedManager].employeeResultArray.count == 0 )
        return 1;
    else if (![IPCCurrentCustomerOpometry sharedManager].currentAddress && section == 1 && [IPCCurrentCustomerOpometry sharedManager].currentCustomer)
        return 0;
    else if (![IPCCurrentCustomerOpometry sharedManager].currentOpometry && section == 2 && [IPCCurrentCustomerOpometry sharedManager].currentCustomer)
        return 0;
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && [IPCCurrentCustomerOpometry sharedManager].currentCustomer)
    {
        if (indexPath.row == 0) {
            IPCCustomerTopTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerTopTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setTopTitle:@"客户基本信息"];
            return cell;
        }else{
            IPCCustomerDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:customerIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerDetailCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.currentCustomer = [IPCCurrentCustomerOpometry sharedManager].currentCustomer;
            return cell;
        }
    }else if (indexPath.section == 1 && [IPCCurrentCustomerOpometry sharedManager].currentAddress && [IPCCurrentCustomerOpometry sharedManager].currentCustomer)
    {
        if (indexPath.row == 0) {
            IPCCustomerTopTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerTopTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setTopTitle:@"收货地址"];
            return cell;
        }else{
            IPCCustomerAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerAddressCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.addressMode = [IPCCurrentCustomerOpometry sharedManager].currentAddress;
            [cell.defaultButton setHidden:YES];
            return cell;
        }
    }else if(indexPath.section == 2 && [IPCCurrentCustomerOpometry sharedManager].currentOpometry && [IPCCurrentCustomerOpometry sharedManager].currentCustomer){
        if (indexPath.row == 0) {
            IPCCustomerTopTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerTopTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setTopTitle:@"验光单"];
            return cell;
        }else{
            IPCCustomerOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:opometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.optometryMode = [IPCCurrentCustomerOpometry sharedManager].currentOpometry;
            [cell.defaultButton setHidden:YES];
            return cell;
        }
    }else if((indexPath.section == 3 && [IPCCurrentCustomerOpometry sharedManager].currentCustomer) || (indexPath.section == 0 && ![IPCCurrentCustomerOpometry sharedManager].currentCustomer)){
        if (indexPath.row == 0) {
            IPCCustomerTopTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerTopTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setInsertTitle:@"选择员工"];
            [[cell rac_signalForSelector:@selector(insertAction:)] subscribeNext:^(id x) {
                if ([self.delegate respondsToSelector:@selector(showEmployeeView)]) {
                    [self.delegate showEmployeeView];
                }
            }];
            return cell;
        }else{
            IPCPayOrderEmployeeCell * cell = [tableView dequeueReusableCellWithIdentifier:employeeIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPayOrderEmployeeCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell updateUI:^{
                [tableView reloadData];
            }];
            return cell;
        }
    }else if((indexPath.section == 4 && [IPCCurrentCustomerOpometry sharedManager].currentCustomer) || (indexPath.section == 1 && ![IPCCurrentCustomerOpometry sharedManager].currentCustomer))
    {
        if (indexPath.row == 0) {
            IPCCustomerTopTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerTopTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeNormal || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeVlaueCard) {
                [cell setTopTitle:@"购买列表"];
            }else{
                [cell setInsertTitle:@"购买列表"];
                [[cell rac_signalForSelector:@selector(insertAction:)] subscribeNext:^(RACTuple * _Nullable x) {
                    if ([self.delegate respondsToSelector:@selector(selectNormalGlasses)]) {
                        [self.delegate selectNormalGlasses];
                    }
                }];
            }
            return cell;
        }else{
            if (([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens) && indexPath.row < ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeUnified ? 3 : 4)) {
                if (indexPath.row == 1) {
                    IPCCustomsizedProductCell * cell = [tableView dequeueReusableCellWithIdentifier:customsizedProIdentifier];
                    if (!cell) {
                        cell = [[UINib nibWithNibName:@"IPCCustomsizedProductCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                    }
                    cell.customsizedProduct = [IPCCustomsizedItem sharedItem].customsizedProduct;
                    return cell;
                }else if(indexPath.row == 2){
                    IPCCustomsizedRightParameterCell * cell = [tableView dequeueReusableCellWithIdentifier:rightEyeIdentifier];
                    if (!cell) {
                        cell = [[UINib nibWithNibName:@"IPCCustomsizedRightParameterCell" bundle:nil] instantiateWithOwner:nil options:nil][0];
                    }
                    [cell reloadUI:^{
                        [tableView reloadData];
                    }];
                    return cell;
                }else{
                    IPCCustomsizedLeftParameterCell * cell = [tableView dequeueReusableCellWithIdentifier:leftEyeIdentifier];
                    if (!cell) {
                        cell = [[UINib nibWithNibName:@"IPCCustomsizedLeftParameterCell" bundle:nil] instantiateWithOwner:nil options:nil][0];
                    }
                    [cell reloadUI:^{
                        [tableView reloadData];
                    }];
                    return cell;
                }
            }else{
                IPCPayOrderProductCell * cell = [tableView dequeueReusableCellWithIdentifier:payOrderCartItemIdentifier];
                if (!cell) {
                    cell = [[UINib nibWithNibName:@"IPCPayOrderProductCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                    cell.delegate = self;
                }
                if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens)
                {
                    IPCShoppingCartItem * cartItem = nil;
                    if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeUnified) {
                        cartItem = [IPCCustomsizedItem sharedItem].normalProducts[indexPath.row-3];
                    }else{
                        cartItem = [IPCCustomsizedItem sharedItem].normalProducts[indexPath.row-4];
                    }
                    if (cartItem){
                        [cell setCartItem:cartItem];
                    }
                }else{
                    IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] selectedPayItemAtIndex:indexPath.row-1] ;
                    if (cartItem){
                        [cell setCartItem:cartItem];
                    }
                }
                return cell;
            }
        }
    }else{
        IPCPayOrderSettlementCell * cell = [tableView dequeueReusableCellWithIdentifier:settlementIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPayOrderSettlementCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate = self;
        }
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([IPCCurrentCustomerOpometry sharedManager].currentCustomer) {
        if (indexPath.section == 0 && indexPath.row > 0){
            return 345;
        }else if (indexPath.section == 1 && indexPath.row > 0){
            return 70;
        }else if (indexPath.section == 2 && indexPath.row > 0 ){
            return 160;
        }
    }
    if ((indexPath.section == 0 && indexPath.row > 0 && ![IPCCurrentCustomerOpometry sharedManager].currentCustomer) || ([IPCCurrentCustomerOpometry sharedManager].currentCustomer && indexPath.section == 3 && indexPath.row > 0))
    {
        return 130;
    }else if ((indexPath.section == 1 && indexPath.row > 0 && ![IPCCurrentCustomerOpometry sharedManager].currentCustomer) || ([IPCCurrentCustomerOpometry sharedManager].currentCustomer && indexPath.section == 4 && indexPath.row > 0))
    {
        return [self.cellMode buyProductCellHeight:indexPath];
    }else if ((indexPath.section == 2 && ![IPCCurrentCustomerOpometry sharedManager].currentCustomer) || ([IPCCurrentCustomerOpometry sharedManager].currentCustomer && indexPath.section == 5))
    {
        return 235;
    }
    return 50;
}

#pragma mark //IPCPayOrderSubViewDelegate
- (void)reloadUI
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadPayOrderView)]) {
            [self.delegate reloadPayOrderView];
        }
    }
}

- (void)getPointPrice:(NSInteger)point{
    if ([IPCCurrentCustomerOpometry sharedManager].currentCustomer) {
        [self requestOrderPointPrice:point];
    }
}

@end
