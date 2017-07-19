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
#import "IPCManagerOptometryViewController.h"
#import "IPCManagerAddressViewController.h"
#import "IPCEmployeListView.h"
#import "IPCShoppingCartView.h"

@interface IPCPayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,IPCPayOrderViewModelDelegate>

@property (weak, nonatomic) IBOutlet UIView *cartContentView;
@property (weak, nonatomic) IBOutlet UITableView *payOrderTableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IPCEmployeListView * employeView;
@property (strong, nonatomic) IPCPayOrderViewMode * payOrderViewMode;
@property (strong, nonatomic) IPCShoppingCartView * shopCartView;

@end

@implementation IPCPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    [self.cancelButton addBorder:2 Width:0.5];
    [self.saveButton addBorder:2 Width:0];
    
    self.payOrderViewMode = [[IPCPayOrderViewMode alloc]init];
    self.payOrderViewMode.delegate = self;
    
    [self.payOrderTableView setTableFooterView:self.tableFootView];
    [self.payOrderTableView setTableHeaderView:self.tableHeadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryCustomerDetail)
                                                 name:IPCChooseCustomerNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:YES];
    [IPCPayOrderManager sharedManager].isPayOrderStatus = YES;
    [self.payOrderViewMode requestTradeOrExchangeStatus];
    [self.cartContentView addSubview:self.shopCartView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeCover];
    [self.shopCartView removeFromSuperview];self.shopCartView = nil;
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

- (IPCShoppingCartView *)shopCartView{
    if (!_shopCartView) {
        _shopCartView = [[IPCShoppingCartView alloc]initWithFrame:self.cartContentView.bounds];
    }
    return _shopCartView;
}

#pragma mark //Clicked Events
- (IBAction)savePayOrder:(id)sender
{
    if ([self.payOrderViewMode isCanPayOrder]) {
        [self.saveButton jk_showIndicator];
        [self.payOrderViewMode offerOrder];
    }
}


- (IBAction)cancelPayOrderAction:(id)sender {
    [self.payOrderViewMode resetPayInfoData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectCustomerAction:(id)sender{
    IPCSearchCustomerViewController * customerListVC = [[IPCSearchCustomerViewController alloc]initWithNibName:@"IPCSearchCustomerViewController" bundle:nil];
    [self.navigationController pushViewController:customerListVC animated:YES];
}

- (void)removeCover{
    [self.employeView removeFromSuperview];self.employeView = nil;
}

#pragma mark //Push Method
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

#pragma mark //ChooseCustomer Notification
- (void)queryCustomerDetail{
    if ([IPCPayOrderManager sharedManager].currentCustomerId) {
        [self.payOrderViewMode queryCustomerDetailWithCustomerId:[IPCPayOrderManager sharedManager].currentCustomerId];
    }
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
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 0.5)];
    [footView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.1]];
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
    [self.payOrderTableView reloadData];
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
