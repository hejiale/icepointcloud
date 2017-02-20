//
//  IPCPayOrderView.m
//  IcePointCloud
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPayOrderView.h"
#import "IPCHistoryOptometryCell.h"
#import "IPCCustomerAddressListCell.h"
#import "IPCOrderTopTableViewCell.h"
#import "IPCCartOrderMemoViewCell.h"
#import "IPCCartOrderCustomerCell.h"
#import "IPCExpandShoppingCartCell.h"
#import "IPCCartItemViewCellMode.h"
#import "IPCOrderPayTypeCell.h"
#import "IPCOrderPayStyleCell.h"

static NSString * const ContactIdentifier    = @"ShoppingCustomerCellIdentifier";
static NSString * const opometryIdentifier = @"HistoryOptometryCellIdentifier";
static NSString * const addressIdentifier    = @"CustomerAddressListCellIdentifier";
static NSString * const titleIdentifier          = @"IPCOrderTopTableViewCellIdentifier";
static NSString * const memoIdentifier       = @"OrderMemoViewCellIdentifier";
static NSString * const payTypeIdentifier   = @"IPCOrderPayTypeCellIdentifier";
static NSString * const payStyleIdentifier   = @"IPCOrderPayStyleCellIdentifier";

typedef void(^SelectEmployeBlock)();
typedef void(^UpdateOrderBlock)();

@interface IPCPayOrderView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *payOrderTableView;

@property (strong, nonatomic) IPCCartItemViewCellMode * cartItemViewCellMode;
@property (copy, nonatomic) SelectEmployeBlock selectEmployeBlock;
@property (copy, nonatomic) UpdateOrderBlock  updateBlock;

@end

@implementation IPCPayOrderView


- (instancetype)initWithFrame:(CGRect)frame SelectEmploye:(void(^)())selectEmploye UpdateOrder:(void (^)())updateOrder
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectEmployeBlock = selectEmploye;
        self.updateBlock = updateOrder;
        self.cartItemViewCellMode = [[IPCCartItemViewCellMode alloc]init];
        
        UIView * payView = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderView" owner:self];
        [payView setFrame:frame];
        [self addSubview:payView];
        
        [[[IPCShoppingCart sharedCart] selectCartItems] enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.expanded = NO;
        }];
    }
    return self;
}


#pragma mark //Clicked Events
- (void)reloadData{
    [self.payOrderTableView reloadData];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4)
        return [self.cartItemViewCellMode tableView:tableView numberOfRowsInSection:section IsPay:YES];
    else if (section == 0)
        return 1;
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
        if (indexPath.row == 0) {
            IPCOrderTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderTopTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"订单备注"];
            return cell;
        }else{
            IPCCartOrderMemoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:memoIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCartOrderMemoViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.memoTextView setText:[IPCPayOrderMode sharedManager].orderMemo];
            return cell;
        }
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
    }else if(indexPath.section == 4){
        return [self.cartItemViewCellMode tableView:tableView cellForRowAtIndexPath:indexPath IsPay:YES];
    }else if(indexPath.section == 5){
        if (indexPath.row == 0) {
            IPCOrderTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderTopTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.topTitleLabel setText:@"选择支付方式"];
            return cell;
        }else{
            IPCOrderPayTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:payTypeIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderPayTypeCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell updateUI:^{
                if (self.selectEmployeBlock)
                    self.selectEmployeBlock();
            } Update:^{
                if (self.updateBlock) {
                    self.updateBlock();
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
    if (indexPath.section == 4) {
        IPCShoppingCartItem * item = [[IPCShoppingCart sharedCart] selectedItemAtIndex:indexPath.row];
        return [self.cartItemViewCellMode cartItemProductCellHeight:item];
    }else if (indexPath.section == 0){
        return 280;
    }else if (indexPath.section == 2 && indexPath.row > 0){
        return 180;
    }else if (indexPath.section == 1 && indexPath.row > 0){
        return 100;
    }else if (indexPath.section == 5 && indexPath.row > 0){
        return 195;
    }else if (indexPath.section == 6 && indexPath.row > 0){
        return 155;
    }else if (indexPath.section == 3 && indexPath.row > 0){
        return 70;
    }
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4) {
        return 0;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 0.1)];
    [headView setBackgroundColor:[UIColor clearColor]];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, section == 4 ? 0 : 8)];
    [footView setBackgroundColor:[UIColor clearColor]];
    return footView;
}

@end
