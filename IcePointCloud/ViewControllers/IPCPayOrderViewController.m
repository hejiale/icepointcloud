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
#import "IPCEmployeListView.h"

@interface IPCPayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,IPCPayOrderViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *payOrderTableView;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
@property (strong, nonatomic) IPCEmployeListView * employeView;
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
    self.normalSellCellMode = [[IPCPayOrderViewNormalSellCellMode alloc]init];
    self.normalSellCellMode.delegate = self;

    [IPCCurrentCustomerOpometry sharedManager].isOrderStatus = YES;
    
    [self.payOrderTableView setTableFooterView:self.tableFootView];
    [self.payOrderTableView setTableHeaderView:[[UIView alloc]init]];
    [self updateTotalPrice];
    
    [self setRightItem:@"icon_select_customer" Selection:@selector(selectCustomerAction)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:NO];
    [self.payOrderTableView reloadData];
}

#pragma mark //Set UI
- (void)loadEmployeView{
    __weak typeof(self) weakSelf = self;
    self.employeView = [[IPCEmployeListView alloc]initWithFrame:self.view.bounds DismissBlock:^{
        [weakSelf.employeView removeFromSuperview];
    }];
    [self.view addSubview:self.employeView];
    [self.view bringSubviewToFront:self.employeView];
}

//- (void)showPopoverOrderBgView:(IPCOrder *)result{
//    __weak typeof (self) weakSelf = self;
//    self.paySuccessView = [[IPCPaySuccessView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds OrderInfo:result Dismiss:^{
//        __strong typeof (weakSelf) strongSelf = weakSelf;
//        [strongSelf.paySuccessView removeFromSuperview];
//    }];
//    [self.view addSubview:self.paySuccessView];
//    [self.view bringSubviewToFront:self.paySuccessView];
//    [self successPayOrder];
//}

#pragma mark //Clicked Events
//- (IBAction)backAction:(id)sender {
//    __weak typeof (self) weakSelf = self;
//    [IPCCustomUI showAlert:@"冰点云" Message:@"确认退出此次订单支付吗?" Owner:self Done:^{
//        __strong typeof (weakSelf) strongSelf = weakSelf;
//        [[IPCPayOrderMode sharedManager] clearData];
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//}
//
//
//- (IBAction)onPayOrderAction:(id)sender {
//
//}

- (void)successPayOrder{
    [[IPCPayOrderMode sharedManager] clearData];
    [[IPCShoppingCart sharedCart] removeSelectCartItem];
    [[IPCCurrentCustomerOpometry sharedManager] clearData];
}

- (void)updateTotalPrice
{

}

- (void)selectCustomerAction{
    IPCSearchCustomerViewController * customerListVC = [[IPCSearchCustomerViewController alloc]initWithNibName:@"IPCSearchCustomerViewController" bundle:nil];
    customerListVC.isMainStatus = NO;
    [self.navigationController pushViewController:customerListVC animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
