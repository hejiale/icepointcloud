//
//  IPCPayOrderViewController.m
//  IcePointCloud
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewController.h"
#import "IPCPayOrderViewNormalSellCellMode.h"
#import "IPCSearchCustomerViewController.h"
#import "IPCPayOrderPayTypeView.h"
#import "IPCEmployeListView.h"
#import "IPCPaySuccessView.h"

@interface IPCPayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,IPCPayOrderViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *payOrderTableView;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
@property (strong, nonatomic) IPCEmployeListView * employeView;
@property (strong, nonatomic) IPCPayOrderPayTypeView * payTypeView;
@property (strong, nonatomic) IPCPaySuccessView * paySuccessView;
@property (strong, nonatomic) IPCPayOrderViewNormalSellCellMode * normalSellCellMode;

@end

@implementation IPCPayOrderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationTitle:@"确认订单"];
    [[IPCPayOrderMode sharedManager] resetData];
    
    self.normalSellCellMode = [[IPCPayOrderViewNormalSellCellMode alloc]init];
    self.normalSellCellMode.delegate = self;
    
    [IPCPayOrderMode sharedManager].isPayOrderStatus = YES;
    
    [self.payOrderTableView setTableFooterView:self.tableFootView];
    [self.payOrderTableView setTableHeaderView:[[UIView alloc]init]];

    [[self rac_signalForSelector:@selector(backAction)] subscribeNext:^(id x) {
        [[IPCCurrentCustomerOpometry sharedManager] clearData];
        [[IPCPayOrderMode sharedManager] resetData];
        [[IPCShoppingCart sharedCart] removeAllValueCardCartItem];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([IPCCurrentCustomerOpometry sharedManager].currentCustomer) {
        [self setRightEmptyView];
    }else{
        [self setRightItem:@"icon_select_customer" Selection:@selector(selectCustomerAction)];
    }
    [self setNavigationBarStatus:NO];
    [self reloadCustomerInfo];
    [self.payOrderTableView reloadData];
}


- (void)reloadCustomerInfo{
    [IPCPayOrderMode sharedManager].balanceAmount = [IPCCurrentCustomerOpometry sharedManager].currentCustomer.balance;
    [IPCPayOrderMode sharedManager].point = [IPCCurrentCustomerOpometry sharedManager].currentCustomer.integral;
}

#pragma mark //Set UI
- (void)loadEmployeView{
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    self.employeView = [[IPCEmployeListView alloc]initWithFrame:self.view.bounds DismissBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.employeView removeFromSuperview];
        [strongSelf.payOrderTableView reloadData];
    }];
    [self.view addSubview:self.employeView];
    [self.view bringSubviewToFront:self.employeView];
}

- (void)loadPayTypeView{
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    self.payTypeView = [[IPCPayOrderPayTypeView alloc]initWithFrame:self.view.bounds
                                                                Pay:^{
                                                                    __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                    [strongSelf.normalSellCellMode offerOrder];
                                                                }Dismiss:^{
                                                                    __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                    [strongSelf.payTypeView removeFromSuperview];
                                                                }];
    [self.view addSubview:self.payTypeView];
    [self.view bringSubviewToFront:self.payTypeView];
}

- (void)loadPaySuccessView:(IPCOrder *)result
{
    __weak typeof(self) weakSelf = self;
    [self.payOrderTableView setHidden:YES];
    self.paySuccessView = [[IPCPaySuccessView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds
                                                        OrderInfo:result
                                                          Dismiss:^{
                                                              __strong typeof(weakSelf) strongSelf = weakSelf;
                                                              [strongSelf resetPayInfoData];
                                                              [strongSelf.paySuccessView removeFromSuperview];
                                                              [strongSelf.navigationController popViewControllerAnimated:YES];
                                                          }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.paySuccessView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.paySuccessView];
}

#pragma mark //Clicked Events
- (IBAction)loadPayStyleView:(id)sender
{
    if ( ![IPCCurrentCustomerOpometry sharedManager].currentCustomer) {
        [IPCCustomUI showError:@"请先选择客户信息"];
        return;
    }
    if ([IPCPayOrderMode sharedManager].employeeResultArray.count == 0) {
        [IPCCustomUI showError:@"请选择员工"];
        return;
    }
    if ([[IPCPayOrderMode sharedManager] isExistEmptyEmployeeResult]) {
        [IPCCustomUI showError:@"参与比例必须填写且大于零"];
        return;
    }
    if ([[IPCPayOrderMode sharedManager] totalEmployeeResult] < 100) {
        [IPCCustomUI showError:@"员工总份额不足百分之一百"];
        return;
    }
    if ([IPCPayOrderMode sharedManager].realTotalPrice == 0 && [IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount) {
        [IPCCustomUI showError:@"请输入有效实付金额"];
        return;
    }
    if ([IPCPayOrderMode sharedManager].presellAmount == 0 && [IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeInstallment) {
        [IPCCustomUI showError:@"请输入有效定金"];
        return;
    }
    [self loadPayTypeView];
}


- (IBAction)cancelPayOrderAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectCustomerAction{
    IPCSearchCustomerViewController * customerListVC = [[IPCSearchCustomerViewController alloc]initWithNibName:@"IPCSearchCustomerViewController" bundle:nil];
    customerListVC.isMainStatus = NO;
    [self.navigationController pushViewController:customerListVC animated:YES];
}

- (void)resetPayInfoData{
    [[IPCShoppingCart sharedCart] removeSelectCartItem];
    [[IPCCurrentCustomerOpometry sharedManager] clearData];
    [[IPCPayOrderMode sharedManager] resetData];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.normalSellCellMode numberOfSectionsInTableView:tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.normalSellCellMode tableView:tableView numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.normalSellCellMode tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.normalSellCellMode tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, (section == 3  ? 0 : 5))];
    [footView setBackgroundColor:[UIColor clearColor]];
    return footView;
}

#pragma mark //IPCPayOrderViewCellDelegate
- (void)showEmployeeView{
    [self loadEmployeView];
}

- (void)reloadPayOrderView{
    [self.payOrderTableView reloadData];
}

- (void)showPaySuccessViewWithOrderInfo:(IPCOrder *)orderResult
{
    [self.payTypeView removeFromSuperview];
    if ([IPCPayOrderMode sharedManager].payStyle == IPCPayStyleTypeWechat || [IPCPayOrderMode sharedManager].payStyle == IPCPayStyleTypeAlipay) {
        [self loadPaySuccessView:orderResult];
    }else{
        [IPCCustomUI showSuccess:@"订单支付成功"];
        [self resetPayInfoData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)searchCustomerMethod{
    [self selectCustomerAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
