//
//  IPCUpdateOrderViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/7.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCUpdateOrderViewController.h"
#import "IPCCustomerDetailCell.h"
#import "IPCCustomTopCell.h"
#import "IPCCustomerAddressCell.h"
#import "IPCCustomerOptometryCell.h"
#import "IPCPayTypeRecordCell.h"
#import "IPCOrderDetailProductCell.h"
#import "IPCPayOrderPayInfoCell.h"
#import "IPCPayOrderEmployeeCell.h"

static NSString * const titleIdentifier            = @"IPCOrderTopTableViewCellIdentifier";
static NSString * const customerIdentifier    = @"IPCCustomerDetailCellIdentifier";
static NSString * const opometryIdentifier   = @"HistoryOptometryCellIdentifier";
static NSString * const addressIdentifier      = @"CustomerAddressListCellIdentifier";
static NSString * const recordIdentifier        = @"IPCPayTypeRecordCellIdentifier";
static NSString * const productIdentifier      = @"IPCOrderDetailProductCellIdentifier";
static NSString * const payInfoIdentifier       = @"IPCPayOrderPayInfoCellIdentifier";
static NSString * const employeeIdentifier    = @"IPCPayOrderEmployeeCellIdentifier";

@interface IPCUpdateOrderViewController ()<UITableViewDataSource, UITableViewDelegate,IPCPayOrderSubViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView * orderTableView;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation IPCUpdateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setBackground];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:NO];
    [self setNavigationTitle:@"确认订单"];
    [self.orderTableView setTableHeaderView:[[UIView alloc]init]];
    [self.orderTableView setTableFooterView:self.tableFootView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self closeSaveOrder];
}

#pragma mark //Request Method
- (void)updatePayOrderRequest{
    __block NSMutableArray * payRecordArray = [[NSMutableArray alloc]init];
    [[IPCPayOrderMode sharedManager].payTypeRecordArray enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isHavePay) {
            NSMutableDictionary * otherResultDic = [[NSMutableDictionary alloc]init];
            [otherResultDic setObject:[NSString stringWithFormat:@"%.2f",obj.payPrice] forKey:@"payAmount"];
            [otherResultDic setObject:obj.payTypeInfo forKey:@"payType"];
            [payRecordArray addObject:otherResultDic];
        }
    }];

    [IPCPayOrderRequestManager payRemainOrderWithOrderNum:[IPCCustomOrderDetailList instance].orderInfo.orderNumber PayInfos:payRecordArray SuccessBlock:^(id responseValue)
    {
        [IPCCustomUI showSuccess:@"订单保存成功!"];
        [self performSelector:@selector(successSaveOrder) withObject:nil afterDelay:2];
    } FailureBlock:^(NSError *error) {
        [IPCCustomUI showError:error.domain];
    }];
}

#pragma mark //Clicked Events
- (IBAction)cancelPayAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)surePayAction:(id)sender {
    [self.saveButton jk_showIndicator];
    [self updatePayOrderRequest];
}

- (void)successSaveOrder{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(updatePayOrder)]) {
            [self.delegate updatePayOrder];
        }
    }
}

- (void)closeSaveOrder{
    [IPCPayOrderMode sharedManager].insertPayRecord = nil;
    [IPCPayOrderMode sharedManager].isInsertRecordStatus = NO;
    
    __block NSMutableArray<IPCPayRecord *> * insertArray = [[NSMutableArray alloc]init];
    [[IPCPayOrderMode sharedManager].payTypeRecordArray enumerateObjectsUsingBlock:^(IPCPayRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isHavePay) {
            [insertArray addObject:obj];
        }
    }];
    [[IPCPayOrderMode sharedManager].payTypeRecordArray removeObjectsInArray:insertArray];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return [IPCCustomOrderDetailList instance].products.count + 1;
    }else if (section == 5){
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setTopTitle:@"客户基本信息"];
            return cell;
        }else{
            IPCCustomerDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:customerIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerDetailCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setTopTitle:@"收货地址"];
            return cell;
        }else{
            IPCCustomerAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerAddressCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.addressMode = [IPCCustomOrderDetailList instance].addressMode;
            return cell;
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setTopTitle:@"验光单"];
            return cell;
        }else{
            IPCCustomerOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:opometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.optometryMode = [IPCCustomOrderDetailList instance].optometryMode;
            [cell.defaultButton setHidden:YES];
            return cell;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setTopTitle:@"订单列表"];
            return cell;
        }else{
            IPCOrderDetailProductCell * cell = [tableView dequeueReusableCellWithIdentifier:productIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderDetailProductCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            
            if ([IPCCustomOrderDetailList instance].products.count) {
                IPCGlasses * product = [IPCCustomOrderDetailList instance].products[indexPath.row-1];
                cell.glasses = product;
            }
            return cell;
        }
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setTopTitle:@"选择员工"];
            return cell;
        }else{
            IPCPayOrderEmployeeCell * cell = [tableView dequeueReusableCellWithIdentifier:employeeIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPayOrderEmployeeCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            return cell;
        }
    }else if (indexPath.section == 5){
        IPCPayOrderPayInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:payInfoIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPayOrderPayInfoCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }else{
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setTopTitle:@"收款记录"];
            [cell setNoPayTitle:[NSString stringWithFormat:@"￥%.2f", [IPCPayOrderMode sharedManager].remainAmount]];
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

#pragma mark //UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row > 0) {
        return 345;
    }else if ( indexPath.section == 1 && indexPath.row > 0){
        return 70;
    }else if (indexPath.section == 2 && indexPath.row > 0 ){
        return 160;
    }else if (indexPath.section == 3 && indexPath.row > 0){
        return 115;
    }else if (indexPath.section == 4 && indexPath.row > 0){
        return 130;
    }else if (indexPath.section == 5){
        return 150;
    }else if (indexPath.section == 6 && indexPath.row > 0){
        return [IPCPayOrderMode sharedManager].payTypeRecordArray.count * 50 + ([IPCPayOrderMode sharedManager].isInsertRecordStatus ? 50 : 0) + 50;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 5)];
    [footView setBackgroundColor:[UIColor clearColor]];
    return footView;
}

#pragma mark //IPCPayOrderSubViewDelegate
- (void)reloadUI
{
    [self.orderTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
