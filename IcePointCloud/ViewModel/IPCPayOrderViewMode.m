//
//  IPCPayOrderViewNormalSellCellMode.m
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewMode.h"
#import "IPCCustomTopCell.h"
#import "IPCCustomerDetailCell.h"
#import "IPCPayOrderProductCell.h"
#import "IPCCustomerAddressCell.h"
#import "IPCCustomerOptometryCell.h"
#import "IPCPayOrderEmployeeCell.h"
#import "IPCPayOrderSettlementCell.h"
#import "IPCCustomsizedProductCell.h"
#import "IPCCustomsizedRightParameterCell.h"
#import "IPCCustomsizedLeftParameterCell.h"
#import "IPCPayOrderMemoCell.h"
#import "IPCPayOrderViewCellHeight.h"
#import "IPCPayTypeRecordCell.h"

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
static NSString * const memoIdentifier                  = @"IPCPayOrderMemoCellIdentifier";
static NSString * const recordIdentifier                 = @"IPCPayTypeRecordCellIdentifier";

@interface IPCPayOrderViewMode()<IPCPayOrderViewCellDelegate>

@property (nonatomic, strong) IPCPayOrderViewCellHeight * cellHeight;

@end

@implementation IPCPayOrderViewMode

- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellHeight = [[IPCPayOrderViewCellHeight alloc] init];
        //判断选择用户页面的确定按钮是否显示
        [IPCPayOrderManager sharedManager].isPayOrderStatus = YES;
        
        if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens)
        {
            [IPCCustomsizedItem sharedItem].customsizdType = IPCCustomsizedTypeUnified;
            [IPCCustomsizedItem sharedItem].rightEye = [[IPCCustomsizedEye alloc]init];
            [IPCCustomsizedItem sharedItem].rightEye.customsizedCount = 1;
            [IPCCustomsizedItem sharedItem].leftEye = [[IPCCustomsizedEye alloc]init];
            [IPCCustomsizedItem sharedItem].leftEye.customsizedCount = 1;
        }
    }
    return self;
}

#pragma mark //Request Data
- (void)requestTradeOrExchangeStatus{
    [IPCCustomUI show];
    [IPCPayOrderRequestManager getStatusTradeOrExchangeWithSuccessBlock:^(id responseValue) {
        [IPCPayOrderManager sharedManager].isTrade = [responseValue boolValue];
        [self reload];
        [IPCCustomUI hiden];
        
    } FailureBlock:^(NSError *error) {
        [IPCCustomUI showError:error.domain];
    }];
}

- (void)requestOrderPointPrice:(NSInteger)point
{
    [IPCPayOrderRequestManager getIntegralRulesWithCustomerID:[IPCCurrentCustomer sharedManager].currentCustomer.customerID
                                                        Point:point
                                                 SuccessBlock:^(id responseValue)
     {
         IPCPointValueMode * pointValue = [[IPCPointValueMode alloc] initWithResponseObject:responseValue];
         [[IPCPayOrderManager sharedManager] calculatePointValue:pointValue];
         [self reload];
         
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}


- (void)offerOrder{
    [IPCPayOrderRequestManager offerOrderWithSuccessBlock:^(id responseValue)
     {
         if (self.delegate) {
             if ([self.delegate respondsToSelector:@selector(successPayOrder)]) {
                 [self.delegate successPayOrder];
             }
         }
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
         if (self.delegate) {
             if ([self.delegate respondsToSelector:@selector(failPayOrder)]) {
                 [self.delegate failPayOrder];
             }
         }
     }];
}

- (void)queryCustomerDetailWithCustomerId:(NSString *)customerId
{
    [IPCCustomerRequestManager queryCustomerDetailInfoWithCustomerID:customerId
                                                        SuccessBlock:^(id responseValue)
     {
         [[IPCCurrentCustomer sharedManager] loadCurrentCustomer:responseValue];
         [self reload];
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}

#pragma mark //Clicked Events
- (void)resetPayInfoData
{
    [[IPCCurrentCustomer sharedManager] clearData];
    [[IPCPayOrderManager sharedManager] resetData];
    [[IPCShoppingCart sharedCart] clearAllItemPoint];
    [[IPCShoppingCart sharedCart] removeAllValueCardCartItem];
    [[IPCCustomsizedItem sharedItem] resetData];
    [[IPCShoppingCart sharedCart] resetSelectCartItemPrice];
}

- (void)reload{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadPayOrderView)]) {
            [self.delegate reloadPayOrderView];
        }
    }
}

#pragma mark //DO Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([IPCCurrentCustomer sharedManager].currentCustomer) {
        return 8;
    }
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ((section == 5 && [IPCCurrentCustomer sharedManager].currentCustomer) || (![IPCCurrentCustomer sharedManager].currentCustomer && section == 1))
    {
        if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens)
        {
            if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeUnified)
                return 3 + [IPCCustomsizedItem sharedItem].normalProducts.count;
            return 4 + [IPCCustomsizedItem sharedItem].normalProducts.count;
        }
        return  [[IPCShoppingCart sharedCart] selectPayItemsCount] + 1;
    }
    else if ([self.cellHeight tableViewCell:section])
        return 1;
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && [IPCCurrentCustomer sharedManager].currentCustomer)
    {
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setLeftTitle:@"客户基本信息"];
            return cell;
        }else{
            IPCCustomerDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:customerIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerDetailCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.currentCustomer = [IPCCurrentCustomer sharedManager].currentCustomer;
            return cell;
        }
    }else if (indexPath.section == 1 && [IPCCurrentCustomer sharedManager].currentCustomer){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setLeftTitle:@"订单备注"];
            return cell;
        }else{
            IPCPayOrderMemoCell * cell = [tableView dequeueReusableCellWithIdentifier:memoIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPayOrderMemoCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.memoTextView setText:[IPCPayOrderManager sharedManager].remark];
            return cell;
        }
    }else if (indexPath.section == 2 &&  [IPCCurrentCustomer sharedManager].currentCustomer)
    {
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"收货地址" ButtonTitle:@"选择" ButtonImage:nil];
            if (![IPCCurrentCustomer sharedManager].currentAddress) {
                [cell.bottomLine setHidden:YES];
            }else{
                [cell.bottomLine setHidden:NO];
            }
            __weak typeof(self) weakSelf = self;
            [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(RACTuple * _Nullable x) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if ([strongSelf.delegate respondsToSelector:@selector(managerAddressView)]) {
                    [strongSelf.delegate managerAddressView];
                }
            }];
            return cell;
        }else{
            IPCCustomerAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerAddressCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.addressMode = [IPCCurrentCustomer sharedManager].currentAddress;
            [cell.bottomLine setHidden:YES];
            return cell;
        }
    }else if(indexPath.section == 3 && [IPCCurrentCustomer sharedManager].currentCustomer){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"验光单" ButtonTitle:@"选择" ButtonImage:nil];
            if (![IPCCurrentCustomer sharedManager].currentOpometry) {
                [cell.bottomLine setHidden:YES];
            }else{
                [cell.bottomLine setHidden:NO];
            }
            __weak typeof(self) weakSelf = self;
            [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(RACTuple * _Nullable x) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if ([strongSelf.delegate respondsToSelector:@selector(managerOptometryView)]) {
                    [strongSelf.delegate managerOptometryView];
                }
            }];
            return cell;
        }else{
            IPCCustomerOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:opometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.optometryMode = [IPCCurrentCustomer sharedManager].currentOpometry;
            [cell.bottomLine setHidden:YES];
            return cell;
        }
    }else if((indexPath.section == 4 && [IPCCurrentCustomer sharedManager].currentCustomer) || (indexPath.section == 0 && ![IPCCurrentCustomer sharedManager].currentCustomer)){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"选择员工" ButtonTitle:nil ButtonImage:@"icon_insert_btn"];
            if ([IPCPayOrderManager sharedManager].employeeResultArray.count) {
                [cell.bottomLine setHidden:NO];
            }else{
                [cell.bottomLine setHidden:YES];
            }
            [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(id x) {
                if ([self.delegate respondsToSelector:@selector(showEmployeeView)]) {
                    [self.delegate showEmployeeView];
                }
            }];
            return cell;
        }else{
            IPCPayOrderEmployeeCell * cell = [tableView dequeueReusableCellWithIdentifier:employeeIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPayOrderEmployeeCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                cell.delegate = self;
            }
            return cell;
        }
    }else if((indexPath.section == 5 && [IPCCurrentCustomer sharedManager].currentCustomer) || (indexPath.section == 1 && ![IPCCurrentCustomer sharedManager].currentCustomer))
    {
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeNormal || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeVlaueCard) {
                [cell setLeftTitle:@"购买列表"];
            }else{
                [cell setRightOperation:@"购买列表" ButtonTitle:nil ButtonImage:@"icon_insert_btn"];
                [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(RACTuple * _Nullable x) {
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
                        cell.delegate = self;
                    }
                    return cell;
                }else{
                    IPCCustomsizedLeftParameterCell * cell = [tableView dequeueReusableCellWithIdentifier:leftEyeIdentifier];
                    if (!cell) {
                        cell = [[UINib nibWithNibName:@"IPCCustomsizedLeftParameterCell" bundle:nil] instantiateWithOwner:nil options:nil][0];
                        cell.delegate = self;
                    }
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
    }else if((indexPath.section == 6 && [IPCCurrentCustomer sharedManager].currentCustomer) || (indexPath.section == 2 && ![IPCCurrentCustomer sharedManager].currentCustomer)){
        IPCPayOrderSettlementCell * cell = [tableView dequeueReusableCellWithIdentifier:settlementIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPayOrderSettlementCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate = self;
        }
        return cell;
    }else{
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setLeftTitle:@"收款记录"];
            NSString * remainAmountText = [NSString stringWithFormat:@"剩余应收  ￥%.2f", [IPCPayOrderManager sharedManager].remainAmount];
            NSAttributedString * str = [IPCCustomUI subStringWithText:remainAmountText BeginRang:6 Rang:remainAmountText.length - 6 Font:[UIFont systemFontOfSize:14 weight:UIFontWeightThin] Color:COLOR_RGB_RED];
            [cell setRightTitle:str];
            
            return cell;
        }else {
            IPCPayTypeRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:recordIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPayTypeRecordCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                cell.delegate = self;
            }
            return cell;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellHeight cellHeightForIndexPath:indexPath];
}

#pragma mark //IPCPayOrderSubViewDelegate
- (void)reloadUI
{
    [self reload];
}

- (void)getPointPrice:(NSInteger)point{
    if ([IPCCurrentCustomer sharedManager].currentCustomer) {
        [self requestOrderPointPrice:point];
    }
}


@end