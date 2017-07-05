//
//  IPCPayOrderViewController.m
//  IcePointCloud
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewController.h"
#import "IPCPayOrderViewMode.h"
#import "IPCSearchCustomerViewController.h"
#import "IPCSelectCustomsizedViewController.h"
#import "IPCManagerOptometryViewController.h"
#import "IPCManagerAddressViewController.h"
#import "IPCEmployeListView.h"

@interface IPCPayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,IPCPayOrderViewModelDelegate>

@property (weak, nonatomic) IBOutlet UITableView *payOrderTableView;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IPCEmployeListView * employeView;
@property (strong, nonatomic) IPCPayOrderViewMode * payOrderViewMode;

@end

@implementation IPCPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationTitle:@"确认订单"];
    [self setRightItem:@"icon_select_customer" Selection:@selector(selectCustomerAction:)];
    
    self.payOrderViewMode = [[IPCPayOrderViewMode alloc]init];
    self.payOrderViewMode.delegate = self;
    
    [self.payOrderTableView setTableFooterView:self.tableFootView];
    [self.payOrderTableView setTableHeaderView:[[UIView alloc]init]];
    
    __weak typeof(self) weakSelf = self;
    [[self rac_signalForSelector:@selector(backAction)] subscribeNext:^(id x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.payOrderViewMode resetPayInfoData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:NO];
    
    [IPCPayOrderManager sharedManager].balanceAmount = [IPCCurrentCustomer sharedManager].currentCustomer.balance;
    [IPCPayOrderManager sharedManager].point = [IPCCurrentCustomer sharedManager].currentCustomer.integral;
    [self.payOrderViewMode requestTradeOrExchangeStatus];
    
    if ([IPCPayOrderManager sharedManager].currentCustomerId) {
        if ([IPCPayOrderManager sharedManager].isChooseOptometry || [IPCPayOrderManager sharedManager].isChooseAddress) {
            [self.payOrderTableView reloadData];
            [IPCPayOrderManager sharedManager].isChooseAddress = NO;
            [IPCPayOrderManager sharedManager].isChooseOptometry = NO;
        }else{
            [self.payOrderViewMode queryCustomerDetailWithCustomerId:[IPCPayOrderManager sharedManager].currentCustomerId];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeCover];
}

#pragma mark //Set UI
- (void)loadEmployeView
{
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    self.employeView = [[IPCEmployeListView alloc]initWithFrame:self.view.bounds DismissBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removeCover];
        [strongSelf.payOrderTableView reloadData];
    }];
    [self.view addSubview:self.employeView];
    [self.view bringSubviewToFront:self.employeView];
}

#pragma mark //Clicked Events
- (IBAction)loadPayStyleView:(id)sender
{
    if ( ![IPCCurrentCustomer sharedManager].currentCustomer) {
        [IPCCustomUI showError:@"请先选择客户信息"];
        return;
    }
    if ([IPCPayOrderManager sharedManager].employeeResultArray.count == 0) {
        [IPCCustomUI showError:@"请选择员工"];
        return;
    }
    if ([[IPCPayOrderManager sharedManager] isExistEmptyEmployeeResult]) {
        [IPCCustomUI showError:@"参与比例必须填写且大于零"];
        return;
    }
    if ([[IPCPayOrderManager sharedManager] totalEmployeeResult] < 100) {
        [IPCCustomUI showError:@"员工总份额不足百分之一百"];
        return;
    }
    if ([IPCPayOrderManager sharedManager].realTotalPrice + [IPCPayOrderManager sharedManager].givingAmount + [IPCPayOrderManager sharedManager].pointPrice != [[IPCShoppingCart sharedCart] selectedPayItemTotalPrice])
    {
        [IPCCustomUI showError:@"请输入有效实付金额"];
        return;
    }
    [self.saveButton jk_showIndicator];
    [self.payOrderViewMode offerOrder];
}


- (IBAction)cancelPayOrderAction:(id)sender {
    [self.payOrderViewMode resetPayInfoData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectCustomerAction:(id)sender{
    IPCSearchCustomerViewController * customerListVC = [[IPCSearchCustomerViewController alloc]initWithNibName:@"IPCSearchCustomerViewController" bundle:nil];
    customerListVC.isMainStatus = NO;
    [self.navigationController pushViewController:customerListVC animated:YES];
}


- (void)pushToManagerOptometryViewController{
    IPCManagerOptometryViewController * optometryVC = [[IPCManagerOptometryViewController alloc]initWithNibName:@"IPCManagerOptometryViewController" bundle:nil];
    optometryVC.customerId = [IPCPayOrderManager sharedManager].currentCustomerId;
    [self.navigationController pushViewController:optometryVC animated:YES];
}

- (void)pushToManagerAddressViewController{
    IPCManagerAddressViewController * addressVC = [[IPCManagerAddressViewController alloc]initWithNibName:@"IPCManagerAddressViewController" bundle:nil];
    addressVC.customerId = [IPCPayOrderManager sharedManager].currentCustomerId;
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)removeCover{
    [self.employeView removeFromSuperview];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.payOrderViewMode numberOfSectionsInTableView:tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.payOrderViewMode tableView:tableView numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.payOrderViewMode tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.payOrderViewMode tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ((section == 5 && [IPCCurrentCustomer sharedManager].currentCustomer) || (section == 1 && ![IPCCurrentCustomer sharedManager].currentCustomer)){
        return 0;
    }
    return 5;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 5)];
    [footView setBackgroundColor:[UIColor clearColor]];
    return footView;
}

#pragma mark //IPCPayOrderViewCellDelegate
- (void)showEmployeeView{
    [self loadEmployeView];
}

- (void)managerOptometryView{
    [self pushToManagerOptometryViewController];
}


- (void)managerAddressView{
    [self pushToManagerAddressViewController];
}

- (void)reloadPayOrderView{
    [self.payOrderTableView setHidden:NO];
    [self.payOrderTableView reloadData];
}

- (void)selectNormalGlasses{
    IPCSelectCustomsizedViewController * selectCustomsizedVC = [[IPCSelectCustomsizedViewController alloc]initWithNibName:@"IPCSelectCustomsizedViewController" bundle:nil];
    [self.navigationController pushViewController:selectCustomsizedVC animated:YES];
}

- (void)successPayOrder{
    [self.saveButton jk_hideIndicator];
    [IPCCustomUI showSuccess:@"订单付款成功!"];
    [self.payOrderViewMode resetPayInfoData];
    [[IPCShoppingCart sharedCart] removeSelectCartItem];
    [self performSelector:@selector(popViewControllerAnimated:) afterDelay:2];
}

- (void)failPayOrder{
    [self.saveButton jk_hideIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
