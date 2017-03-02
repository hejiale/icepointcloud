//
//  IPCPayOrderViewController.m
//  IcePointCloud
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewController.h"
#import "IPCExpandShoppingCartCell.h"
#import "IPCHistoryOptometryCell.h"
#import "IPCCustomerAddressListCell.h"
#import "IPCOrderTopTableViewCell.h"
#import "IPCCartOrderMemoViewCell.h"
#import "IPCCartOrderCustomerCell.h"
#import "IPCExpandShoppingCartCell.h"
#import "IPCCartItemViewCellMode.h"
#import "IPCOrderPayTypeCell.h"
#import "IPCOrderPayStyleCell.h"
#import "IPCEmployeListView.h"
#import "IPCPaySuccessView.h"

static NSString * const kNewShoppingCartItemName = @"ExpandableShoppingCartCellIdentifier";
static NSString * const ContactIdentifier    = @"ShoppingCustomerCellIdentifier";
static NSString * const opometryIdentifier = @"HistoryOptometryCellIdentifier";
static NSString * const addressIdentifier    = @"CustomerAddressListCellIdentifier";
static NSString * const titleIdentifier          = @"IPCOrderTopTableViewCellIdentifier";
static NSString * const memoIdentifier       = @"OrderMemoViewCellIdentifier";
static NSString * const payTypeIdentifier   = @"IPCOrderPayTypeCellIdentifier";
static NSString * const payStyleIdentifier   = @"IPCOrderPayStyleCellIdentifier";

@interface IPCPayOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *payOrderTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (strong, nonatomic) IPCEmployeListView * employeView;
@property (strong, nonatomic) IPCPaySuccessView  * paySuccessView;


@end

@implementation IPCPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.payOrderTableView setTableFooterView:[[UIView alloc]init]];
    [self.payOrderTableView setTableHeaderView:[[UIView alloc]init]];
    [self.bottomView addTopLine];
    [self.payButton setBackgroundColor:COLOR_RGB_BLUE];
    [self updateTotalPrice];
}


#pragma mark //Set UI
- (void)loadEmployeView{
    __weak typeof (self) weakSelf = self;
    self.employeView = [[IPCEmployeListView alloc]initWithFrame:self.view.bounds DismissBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.employeView removeFromSuperview];self.employeView = nil;
        [strongSelf.payOrderTableView reloadData];
        [strongSelf updateTotalPrice];
    }];
    [self.view addSubview:self.employeView];
    [self.view bringSubviewToFront:self.employeView];
}


#pragma mark //Clicked Events
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)onPayOrderAction:(id)sender {
    if (! [IPCPayOrderMode sharedManager].currentEmploye) {
        [IPCUIKit showError:@"请先选择员工"];
    }else if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeNone) {
        [IPCUIKit showError:@"请选择支付方式"];
    }else if ([IPCPayOrderMode sharedManager].payStyle == IPCPayStyleTypeNone){
        [IPCUIKit showError:@"请选择结算方式"];
    }else if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeInstallment && [IPCPayOrderMode sharedManager].prepaidAmount <= 0){
        [IPCUIKit showError:@"请输入预付金额"];
    }else{
        
    }
}

- (void)updateTotalPrice{
    [self.totalPriceLabel setAttributedText:[IPCUIKit subStringWithText:[NSString stringWithFormat:@"合计：￥%.f", [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]] BeginRang:0 Rang:3 Font:[UIFont systemFontOfSize:14 weight:UIFontWeightThin] Color:[UIColor blackColor]]];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4)
        return  [[IPCShoppingCart sharedCart] selectedItemsCount];
    else if (section == 0 || section == 1)
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
    }else if(indexPath.section == 4){
        IPCExpandShoppingCartCell * cell = [tableView dequeueReusableCellWithIdentifier:kNewShoppingCartItemName];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCExpandShoppingCartCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] selectedItemAtIndex:indexPath.row] ;
        if (cartItem){
            [cell setIsOrder:YES];
            [cell setCartItem:cartItem Reload:nil];
        }
        return cell;
    }else if(indexPath.section == 5){
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
            [cell updateUI:^{
                [self loadEmployeView];
            } Update:^{
                
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
    }else if (indexPath.section == 5 && indexPath.row > 0){
        return 60;
    }else if (indexPath.section == 6 && indexPath.row > 0){
        return 155;
    }else if (indexPath.section == 3 && indexPath.row > 0){
        return 70;
    }else if (indexPath.section == 4) {
        return 135;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
