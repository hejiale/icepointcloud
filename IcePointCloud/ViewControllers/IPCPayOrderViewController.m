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
#import "IPCEmployeListView.h"

@interface IPCPayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,IPCPayOrderViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *payOrderTableView;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
@property (strong, nonatomic) IPCEmployeListView * employeView;
@property (strong, nonatomic) IPCPayOrderViewMode * normalSellCellMode;

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
    
    [self setRightItem:@"icon_select_customer" Selection:@selector(selectCustomerAction)];
    [self setNavigationTitle:@"确认订单"];
    
    self.normalSellCellMode = [[IPCPayOrderViewMode alloc]init];
    self.normalSellCellMode.delegate = self;
    
    [[IPCPayOrderMode sharedManager] resetData];
    [IPCPayOrderMode sharedManager].isPayOrderStatus = YES;//判断选择用户页面的确定按钮是否显示
    
    [self.payOrderTableView setTableFooterView:self.tableFootView];
    [self.payOrderTableView setTableHeaderView:[[UIView alloc]init]];

    __weak typeof(self) weakSelf = self;
    [[self rac_signalForSelector:@selector(backAction)] subscribeNext:^(id x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf resetPayInfoData];
    }];
    
    if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens)
    {
        [IPCCustomsizedItem sharedItem].customsizdType = IPCCustomsizedTypeUnified;
        [IPCCustomsizedItem sharedItem].rightEye = [[IPCCustomsizedEye alloc]init];
        [IPCCustomsizedItem sharedItem].rightEye.customsizedCount = 1;
        [IPCCustomsizedItem sharedItem].leftEye = [[IPCCustomsizedEye alloc]init];
        [IPCCustomsizedItem sharedItem].leftEye.customsizedCount = 1;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:NO];
    [self reloadCustomerInfo];
    [self.normalSellCellMode requestTradeOrExchangeStatus];
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
    if ([IPCPayOrderMode sharedManager].realTotalPrice + [IPCPayOrderMode sharedManager].givingAmount + [IPCPayOrderMode sharedManager].pointPrice != [[IPCShoppingCart sharedCart] selectedPayItemTotalPrice])
    {
        [IPCCustomUI showError:@"请输入有效实付金额"];
        return;
    }
    if ([IPCPayOrderMode sharedManager].payTypeRecordArray.count == 0) {
        [IPCCustomUI showError:@"请填写收款记录"];
        return;
    }
    [self.normalSellCellMode offerOrder];
}


- (IBAction)cancelPayOrderAction:(id)sender {
    [self resetPayInfoData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectCustomerAction{
    IPCSearchCustomerViewController * customerListVC = [[IPCSearchCustomerViewController alloc]initWithNibName:@"IPCSearchCustomerViewController" bundle:nil];
    customerListVC.isMainStatus = NO;
    [self.navigationController pushViewController:customerListVC animated:YES];
}

- (void)resetPayInfoData{
    [[IPCCurrentCustomerOpometry sharedManager] clearData];
    [[IPCPayOrderMode sharedManager] resetData];
    [[IPCShoppingCart sharedCart] clearAllItemPoint];
    [[IPCShoppingCart sharedCart] removeAllValueCardCartItem];
    [[IPCCustomsizedItem sharedItem] resetData];
    [[IPCShoppingCart sharedCart] resetSelectCartItemPrice];
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
    if (![IPCCurrentCustomerOpometry sharedManager].currentAddress && section == 1 && [IPCCurrentCustomerOpometry sharedManager].currentCustomer)
        return 0;
    else if (![IPCCurrentCustomerOpometry sharedManager].currentOpometry && section == 2 && [IPCCurrentCustomerOpometry sharedManager].currentCustomer)
        return 0;
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

- (void)searchCustomerMethod{
    [self selectCustomerAction];
}

- (void)selectNormalGlasses{
    IPCSelectCustomsizedViewController * selectCustomsizedVC = [[IPCSelectCustomsizedViewController alloc]initWithNibName:@"IPCSelectCustomsizedViewController" bundle:nil];
    [self.navigationController pushViewController:selectCustomsizedVC animated:YES];
}

- (void)successPayOrder{
    [IPCCustomUI showSuccess:@"订单付款成功!"];
    [self resetPayInfoData];
    [[IPCShoppingCart sharedCart] removeSelectCartItem];
    [self performSelector:@selector(popViewControllerAnimated:) afterDelay:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
