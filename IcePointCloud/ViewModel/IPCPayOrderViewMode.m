//
//  IPCPayOrderViewNormalSellCellMode.m
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewMode.h"
#import "IPCCustomTopCell.h"
#import "IPCPayOrderCustomerCell.h"
#import "IPCCustomerAddressCell.h"
#import "IPCPayOrderOptometryCell.h"
#import "IPCPayOrderEmployeeCell.h"
#import "IPCPayOrderSettlementCell.h"
#import "IPCPayOrderMemoCell.h"
#import "IPCPayOrderViewCellHeight.h"
#import "IPCPayTypeRecordCell.h"

static NSString * const customerIdentifier              = @"IPCPayOrderCustomerCellIdentifier";
static NSString * const opometryIdentifier              = @"HistoryOptometryCellIdentifier";
static NSString * const addressIdentifier                = @"CustomerAddressListCellIdentifier";
static NSString * const titleIdentifier                      = @"IPCOrderTopTableViewCellIdentifier";
static NSString * const employeeIdentifier             = @"IPCPayOrderEmployeeCellIdentifier";
static NSString * const settlementIdentifier           = @"IPCPayOrderSettlementCellIdentifier";
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
    }
    return self;
}

#pragma mark //Request Data
- (void)requestOrderPointPrice:(NSInteger)point
{
    [IPCCommonUI show];
    [IPCPayOrderRequestManager getIntegralRulesWithCustomerID:[IPCCurrentCustomer sharedManager].currentCustomer.customerID
                                                        Point:point
                                                 SuccessBlock:^(id responseValue)
     {
         IPCPointValueMode * pointValue = [[IPCPointValueMode alloc] initWithResponseObject:responseValue];
         [[IPCPayOrderManager sharedManager] calculatePointValue:pointValue];
         [self reload];
         [IPCCommonUI hiden];
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:@"查询积分定制规则失败！"];
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
         [IPCCommonUI showError:@"保存订单失败！"];
         if (self.delegate) {
             if ([self.delegate respondsToSelector:@selector(failPayOrder)]) {
                 [self.delegate failPayOrder];
             }
         }
     }];
}

- (void)queryCustomerDetailWithCustomerId:(NSString *)customerId
{
    [IPCCommonUI show];
    [IPCCustomerRequestManager queryCustomerDetailInfoWithCustomerID:customerId
                                                        SuccessBlock:^(id responseValue)
     {
         [[IPCCurrentCustomer sharedManager] loadCurrentCustomer:responseValue];
         [self reload];
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:@"查询客户信息失败!"];
     }];
}

#pragma mark //Clicked Events
- (void)reload{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadPayOrderView)]) {
            [self.delegate reloadPayOrderView];
        }
    }
}

- (BOOL)isCanPayOrder
{
    if ([[IPCShoppingCart sharedCart] itemsCount] == 0) {
        [IPCCommonUI showError:@"未添加任何商品!"];
        return NO;
    }
    if ( ![IPCCurrentCustomer sharedManager].currentCustomer) {
        [IPCCommonUI showError:@"请先选择客户信息"];
        return NO;
    }
    if ([IPCPayOrderManager sharedManager].employeeResultArray.count == 0) {
        [IPCCommonUI showError:@"请选择员工"];
        return NO;
    }
    if ([[IPCPayOrderManager sharedManager] isExistEmptyEmployeeResult]) {
        [IPCCommonUI showError:@"参与比例必须填写且大于零"];
        return NO;
    }
    if ([[IPCPayOrderManager sharedManager] totalEmployeeResult] < 100) {
        [IPCCommonUI showError:@"员工总份额不足百分之一百"];
        return NO;
    }
    return YES;
}

- (void)insertPayRecord{
    if ([[IPCPayOrderManager sharedManager] remainPayPrice] <= 0) {
        [IPCCommonUI showError:@"剩余应收金额为零"];
        return;
    }
    if ([IPCPayOrderManager sharedManager].isInsertRecordStatus){
        return;
    }
    [IPCPayOrderManager sharedManager].isInsertRecordStatus = YES;
    IPCPayRecord * record = [[IPCPayRecord alloc]init];
    record.payTypeInfo = @"现金";
    [IPCPayOrderManager sharedManager].insertPayRecord = record;
    
    if ([self.delegate respondsToSelector:@selector(createNewRecord)]) {
        [self.delegate createNewRecord];
    }
}

#pragma mark //DO Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([IPCCurrentCustomer sharedManager].currentCustomer)
        return 7;
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.cellHeight tableViewCell:section])
        return 1;
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && [IPCCurrentCustomer sharedManager].currentCustomer)
    {
        IPCPayOrderCustomerCell * cell = [tableView dequeueReusableCellWithIdentifier:customerIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPayOrderCustomerCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate = self;
        }
        return cell;
    }else if (indexPath.section == 1 &&  [IPCCurrentCustomer sharedManager].currentCustomer)
    {
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"收货地址"  AttributedTitle:nil ButtonTitle:nil ButtonImage:@"icon_arrow"];
            
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
            return cell;
        }
    }else if(indexPath.section == 2 && [IPCCurrentCustomer sharedManager].currentCustomer){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"验光单"  AttributedTitle:nil ButtonTitle:nil ButtonImage:@"icon_arrow"];
            
            __weak typeof(self) weakSelf = self;
            [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(RACTuple * _Nullable x) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if ([strongSelf.delegate respondsToSelector:@selector(managerOptometryView)]) {
                    [strongSelf.delegate managerOptometryView];
                }
            }];
            return cell;
        }else{
            IPCPayOrderOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:opometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPayOrderOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.optometry = [IPCCurrentCustomer sharedManager].currentOpometry;
            return cell;
        }
    }else if((indexPath.section == 3 && [IPCCurrentCustomer sharedManager].currentCustomer) || (indexPath.section == 0 && ![IPCCurrentCustomer sharedManager].currentCustomer)){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"选择员工"  AttributedTitle:nil ButtonTitle:nil ButtonImage:@"icon_insert_btn"];
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
    }else if ((indexPath.section == 4 && [IPCCurrentCustomer sharedManager].currentCustomer)||(indexPath.section == 1 && ![IPCCurrentCustomer sharedManager].currentCustomer)){
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
            return cell;
        }
    }else if((indexPath.section == 5 && [IPCCurrentCustomer sharedManager].currentCustomer) || (indexPath.section == 2 && ![IPCCurrentCustomer sharedManager].currentCustomer)){
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
            
            NSString * remainAmountText = [NSString stringWithFormat:@"剩余应收:￥%.2f", [[IPCPayOrderManager sharedManager] remainPayPrice]];
            NSAttributedString * str = [IPCCommonUI subStringWithText:remainAmountText BeginRang:5 Rang:remainAmountText.length - 5 Font:[UIFont systemFontOfSize:15] Color:COLOR_RGB_RED];
            [cell setRightOperation:nil  AttributedTitle:str ButtonTitle:nil ButtonImage:@"icon_insert_btn"];
            
            __weak typeof(self) weakSelf = self;
            [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(RACTuple * _Nullable x) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf insertPayRecord];
            }];
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

- (void)selectCustomer{
    if ([self.delegate respondsToSelector:@selector(chooseCustomer)]) {
        [self.delegate chooseCustomer];
    }
}


@end
