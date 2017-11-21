//
//  IPCPayOrderViewController.m
//  IcePointCloud
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewController.h"
//#import "IPCPayOrderViewMode.h"
//#import "IPCCustomerListViewController.h"
//#import "IPCManagerOptometryViewController.h"
//#import "IPCManagerAddressViewController.h"
//#import "IPCEmployeListView.h"


#import "IPCPayOrderCustomerViewController.h"
#import "IPCPayOrderOptometryViewController.h"
#import "IPCPayOrderOfferOrderViewController.h"
#import "IPCPayOrderPayCashViewController.h"

#import "IPCPayorderScrollPageView.h"
#import "IPCCustomKeyboard.h"

@interface IPCPayOrderViewController ()<UIScrollViewDelegate,IPCPayorderScrollPageViewDelegate>

//@property (weak, nonatomic) IBOutlet UIView *cartContentView;
//@property (weak, nonatomic) IBOutlet UITableView *payOrderTableView;
//@property (strong, nonatomic) IBOutlet UIView *tableHeadView;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//@property (strong, nonatomic) IPCEmployeListView * employeView;
//@property (strong, nonatomic) IPCPayOrderViewMode * payOrderViewMode;
//@property (strong, nonatomic) IPCShoppingCartView * shopCartView;

@property (strong, nonatomic) IPCPayorderScrollPageView * pageView;
@property (strong, nonatomic) IPCPayOrderOptometryViewController * optometryVC;



@end

@implementation IPCPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提交订单";
    //Set UI
    [self.bottomView addTopLine];
    [self.cancelButton addBorder:2 Width:0.5 Color:nil];
    [self.saveButton addBorder:2 Width:0 Color:nil];
    //Set TableView
//    [self.payOrderTableView setTableHeaderView:[[UIView alloc]init]];
//    [self.payOrderTableView setTableFooterView:[[UIView alloc]init]];
//    self.payOrderTableView.estimatedSectionHeaderHeight = 0;
//    self.payOrderTableView.estimatedSectionFooterHeight = 0;
    //Init View Model
//    self.payOrderViewMode = [[IPCPayOrderViewMode alloc]init];
//    self.payOrderViewMode.delegate = self;
    //Set Shopping Cart View
//    [self.cartContentView addSubview:self.shopCartView];
    //Set Notification
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(queryCustomerDetail)
//                                                 name:IPCChooseCustomerNotification
//                                               object:nil];
    _pageView = [[IPCPayorderScrollPageView alloc]initWithFrame:CGRectMake(0, 0, 80, self.contentScrollView.jk_height)];
    [_pageView setPageImages:@[@"icon_unpage_0",@"icon_unpage_1",@"icon_unpage_2",@"icon_unpage_3"]];
    [_pageView setOnPageImages:@[@"icon_page_0",@"icon_page_1",@"icon_page_2",@"icon_page_3"]];
//    [_pageView setPageTitles:@[@"客户",@"验光单",@"结算",@"收银"]];
    [_pageView setNumberPages:4];
    [_pageView setDelegate:self];
    [self.view addSubview:_pageView];
    
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.jk_width, _pageView.numberPages*self.contentScrollView.jk_height)];
    
    IPCPayOrderCustomerViewController * customerVC = [[IPCPayOrderCustomerViewController alloc]initWithNibName:@"IPCPayOrderCustomerViewController" bundle:nil];
    _optometryVC = [[IPCPayOrderOptometryViewController alloc]initWithNibName:@"IPCPayOrderOptometryViewController" bundle:nil];
    IPCPayOrderOfferOrderViewController * productVC = [[IPCPayOrderOfferOrderViewController alloc]initWithNibName:@"IPCPayOrderOfferOrderViewController" bundle:nil];
    IPCPayOrderPayCashViewController * cashVC = [[IPCPayOrderPayCashViewController alloc]initWithNibName:@"IPCPayOrderPayCashViewController" bundle:nil];
    
    [self insertScrollSubView:@[customerVC,_optometryVC,productVC,cashVC]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetOptometryOffset:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)insertScrollSubView:(NSArray<UIViewController *> *)subViews
{
    __block CGFloat left = self.pageView.jk_right;
    __block CGFloat width = self.contentScrollView.jk_width - self.pageView.jk_right;
    __block CGFloat height = self.contentScrollView.jk_height;
    
    __weak typeof(self) weakSelf = self;
    
    [subViews enumerateObjectsUsingBlock:^(UIViewController * _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf addChildViewController:controller];
        [controller.view setFrame:CGRectMake(left, idx*height, width, height)];
        [strongSelf.contentScrollView addSubview:controller.view];
        [controller didMoveToParentViewController:strongSelf];
    }];
}

- (void)resetOptometryOffset:(NSNotification *)notification
{
    [self.contentScrollView setContentOffset:CGPointMake(0, self.pageView.currentPage*self.contentScrollView.jk_height)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Set Naviagtion Bar
    [self setNavigationBarStatus:YES];
    //Reload Method
    [self reloadTableHead];
//    [self.shopCartView reload];
//    [self.payOrderTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeCover];
}

#pragma mark //Set UI
//- (void)loadEmployeView
//{
//    [self.view endEditing:YES];
//
//    __weak typeof(self) weakSelf = self;
//    self.employeView = [[IPCEmployeListView alloc]initWithFrame:self.view.bounds DismissBlock:^{
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf removeCover];
////        [strongSelf.payOrderTableView reloadData];
//    }];
//    [self.view addSubview:self.employeView];
//    [self.view bringSubviewToFront:self.employeView];
//}

//- (IPCShoppingCartView *)shopCartView{
//    if (!_shopCartView) {
//        __weak typeof(self) weakSelf = self;
//        _shopCartView = [[IPCShoppingCartView alloc]initWithFrame:self.cartContentView.bounds Complete:^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf.payOrderTableView reloadData];
//        }];
//    }
//    return _shopCartView;
//}

#pragma mark //Clicked Events
- (IBAction)savePayOrder:(id)sender
{
//    if ([self.payOrderViewMode isCanPayOrder]) {
//        [self.saveButton jk_showIndicator];
//        [self.payOrderViewMode offerOrder];
//    }
}


- (IBAction)cancelPayOrderAction:(id)sender {
//    __weak typeof(self) weakSelf = self;
//    [IPCCommonUI showAlert:@"温馨提示" Message:@"您确定要取消该订单并清空购物列表及客户信息吗?" Owner:[UIApplication sharedApplication].keyWindow.rootViewController Done:^{
//        __strong typeof (weakSelf) strongSelf = weakSelf;
////        [strongSelf resetPayInfoView];
//    }];
}

//- (IBAction)selectCustomerAction:(id)sender{
//    [self pushToSearchCustomerVC];
//}

- (void)removeCover{
//    [self.employeView removeFromSuperview];self.employeView = nil;
}

- (void)reloadTableHead{
//    if ([IPCPayOrderManager sharedManager].currentCustomerId) {
//        [self.payOrderTableView setTableHeaderView:[[UIView alloc]init]];
//    }else{
//        [self.payOrderTableView setTableHeaderView:self.tableHeadView];
//    }
}

//- (void)resetPayInfoView{
//    [[IPCPayOrderManager sharedManager] resetData];
//    [self.payOrderTableView reloadData];
//    [self.shopCartView reload];
//    [self reloadTableHead];
//}

#pragma mark //Push Method
//- (void)pushToSearchCustomerVC{
//    IPCCustomerListViewController * customerListVC = [[IPCCustomerListViewController alloc]initWithNibName:@"IPCCustomerListViewController" bundle:nil];
//    [self.navigationController pushViewController:customerListVC animated:YES];
//}
//
//- (void)pushToManagerOptometryViewController{
//    IPCManagerOptometryViewController * optometryVC = [[IPCManagerOptometryViewController alloc]initWithNibName:@"IPCManagerOptometryViewController" bundle:nil];
//    optometryVC.customerId = [IPCPayOrderManager sharedManager].currentCustomerId;
//    [self.navigationController pushViewController:optometryVC animated:YES];
//}
//
//- (void)pushToManagerAddressViewController{
//    IPCManagerAddressViewController * addressVC = [[IPCManagerAddressViewController alloc]initWithNibName:@"IPCManagerAddressViewController" bundle:nil];
//    addressVC.customerId = [IPCPayOrderManager sharedManager].currentCustomerId;
//    [self.navigationController pushViewController:addressVC animated:YES];
//}

#pragma mark //ChooseCustomer Notification
//- (void)queryCustomerDetail{
//    if ([IPCPayOrderManager sharedManager].currentCustomerId) {
//        [self.payOrderViewMode queryCustomerDetailWithCustomerId:[IPCPayOrderManager sharedManager].currentCustomerId];
//    }
//}

#pragma mark //UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return [self.payOrderViewMode numberOfSectionsInTableView:tableView];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [self.payOrderViewMode tableView:tableView numberOfRowsInSection:section];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [self.payOrderViewMode tableView:tableView cellForRowAtIndexPath:indexPath];
//}

#pragma mark //UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.payOrderViewMode tableView:tableView heightForRowAtIndexPath:indexPath];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.5;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 0.5)];
//    [footView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.1]];
//    return footView;
//}

#pragma mark //IPCPayOrderViewModelDelegate
//- (void)showEmployeeView{
//    [self loadEmployeView];
//}
//
//- (void)managerOptometryView{
//    [self pushToManagerOptometryViewController];
//}
//
//- (void)managerAddressView{
//    [self pushToManagerAddressViewController];
//}
//
//- (void)reloadPayOrderView{
//    [self.shopCartView reload];
//    [self.payOrderTableView reloadData];
//    [IPCCommonUI hiden];
//}
//
//- (void)createNewRecord{
//    [self.payOrderTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
//    [self.payOrderTableView reloadData];
//}
//
//- (void)chooseCustomer{
//    [self pushToSearchCustomerVC];
//}
//
//- (void)successPayOrder{
//    [self.saveButton jk_hideIndicator];
//    [IPCCommonUI showSuccess:@"订单付款成功!"];
//    [self resetPayInfoView];
//}
//
//- (void)failPayOrder{
//    [self.saveButton jk_hideIndicator];
//}

#pragma mark //UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat currentPage = scrollView.contentOffset.y/scrollView.jk_height;
    [self.pageView setCurrentPage:currentPage];
}

#pragma mark //IPCPayorderScrollPageViewDelegate
- (void)changePageIndex:(NSInteger)index
{
    [self.contentScrollView setContentOffset:CGPointMake(0, index*self.contentScrollView.jk_height)];
    
    if (index == 1) {
        [self.optometryVC reload];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
