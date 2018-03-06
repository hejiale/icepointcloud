//
//  UserDetailInfoViewController.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerDetailViewController.h"
#import "IPCCustomerOptometryCell.h"
#import "IPCCustomerHistoryOrderCell.h"
#import "IPCCustomerDetailCell.h"
#import "IPCCustomerDetailTopCell.h"
#import "IPCCustomerRefreshCell.h"
#import "IPCCustomDetailOrderView.h"
#import "IPCCustomerDetailViewMode.h"
#import "IPCManagerOptometryViewController.h"
#import "IPCUpdateCustomerView.h"
#import "IPCUpgradeMemberView.h"

static NSString * const topTitleIdentifier    = @"UserBaseTopTitleCellIdentifier";
static NSString * const footLoadIdentifier  = @"UserBaseFootCellIdentifier";
static NSString * const baseIdentifier        = @"UserBaseInfoCellIdentifier";
static NSString * const optometryIdentifier = @"HistoryOptometryCellIdentifier";
static NSString * const orderIdentifier       = @"HistoryOrderCellIdentifier";

@interface IPCCustomerDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    pthread_mutex_t _lock;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) IPCCustomerDetailViewMode * customerViewMode;
@property (strong, nonatomic) IPCUpdateCustomerView * editCustomerView;
@property (strong, nonatomic) IPCCustomDetailOrderView  *  detailOrderView;
@property (nonatomic, strong) IPCUpgradeMemberView * upgradeMemberView;

@end

@implementation IPCCustomerDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Set Up NavigationBar
    [self setNavigationTitle:@"个人信息"];
    [self setNavigationBarStatus:NO];
    //Set Up TableView
    [self.detailTableView setTableHeaderView:[[UIView alloc]init]];
    [self.detailTableView setTableFooterView:[[UIView alloc]init]];
    self.detailTableView.estimatedSectionFooterHeight = 0;
    self.detailTableView.estimatedSectionHeaderHeight = 0;
    // Init ViewModel
    self.customerViewMode = [[IPCCustomerDetailViewMode alloc]init];
    pthread_mutex_init(&_lock, NULL);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //刷新
    [self requestCustomerDetailInfo];
}


#pragma mark //Request Data
- (void)requestCustomerDetailInfo
{
    pthread_mutex_lock(&_lock);
    
    [self.customerViewMode resetData];
    self.detailTableView.isBeginLoad = YES;
    [self.detailTableView reloadData];
    self.customerViewMode.customerId = self.customer.customerID;
    
    __weak typeof (self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [strongSelf.customerViewMode queryCustomerDetailInfo:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.customerViewMode queryHistotyOrderList:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.detailTableView.isBeginLoad = NO;
        [strongSelf.detailTableView reloadData];
        pthread_mutex_unlock(&_lock);
    });
}


#pragma mark //Set UI
- (void)loadOrderDetailView:(IPCCustomerOrderMode *)orderObject
{
    [self.view endEditing:YES];
    
    self.detailOrderView = [[IPCCustomDetailOrderView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds
                                                                 OrderNum:orderObject.orderCode];
    [[UIApplication sharedApplication].keyWindow addSubview:self.detailOrderView];
    [self.detailOrderView show];
}

- (void)loadEditCustomerView
{
    __weak typeof(self) weakSelf = self;
    self.editCustomerView = [[IPCUpdateCustomerView alloc]initWithFrame:self.view.bounds
                                                         DetailCustomer:self.customerViewMode.detailCustomer
                                                            UpdateBlock:^(IPCCustomerMode *customer)
                             {
                                 [weakSelf requestCustomerDetailInfo];
                             }];
    [self.view addSubview:self.editCustomerView];
    [self.view bringSubviewToFront:self.editCustomerView];
}

- (void)showUpgradeMemberView
{
    __weak typeof(self) weakSelf = self;
    self.upgradeMemberView = [[IPCUpgradeMemberView alloc]initWithFrame:self.view.bounds
                                                               Customer:self.customerViewMode.detailCustomer
                                                            UpdateBlock:^(IPCCustomerMode *customer)
                              {
                                  [IPCCommonUI showSuccess:@"客户升级会员成功!"];
                                  [weakSelf requestCustomerDetailInfo];
                              }];
    [self.view addSubview:self.upgradeMemberView];
    [self.view bringSubviewToFront:self.upgradeMemberView];
}

#pragma mark //ClickEvents
/**
 *  Load More
 */
- (void)loadMoreOrderData{
    [IPCCommonUI show];
    self.customerViewMode.orderCurrentPage++;
    
    __weak typeof(self) weakSelf = self;
    [self.customerViewMode queryHistotyOrderList:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.detailTableView reloadData];
        [IPCCommonUI hiden];
    }];
}

/**
 *  Push Method
 */
- (void)pushToManagerOptometryViewController{
    IPCManagerOptometryViewController * optometryVC = [[IPCManagerOptometryViewController alloc]initWithNibName:@"IPCManagerOptometryViewController" bundle:nil];
    optometryVC.customerId = self.customerViewMode.detailCustomer.customerID;
    [self.navigationController pushViewController:optometryVC animated:YES];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.customerViewMode.detailCustomer) {
        if (self.customerViewMode.orderList.count) {
            return 3;
        }
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return self.customerViewMode.customerOpometry ? 2 : 1;
    }else{
        if (self.customerViewMode.isLoadMoreOrder)
            return self.customerViewMode.orderList.count+2;
        return self.customerViewMode.orderList.count > 0 ? self.customerViewMode.orderList.count+1 : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            IPCCustomerDetailTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topTitleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerDetailTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"客户基本信息" ButtonTitle:nil ButtonImage:@"icon_edit"];
            __weak typeof(self) weakSelf = self;
            [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(id x) {
                [weakSelf loadEditCustomerView];
            }];
            return cell;
        }else{
            IPCCustomerDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:baseIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerDetailCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if (self.customerViewMode.detailCustomer) {
                cell.currentCustomer = self.customerViewMode.detailCustomer;
            }
            __weak typeof(self) weakSelf = self;
            [[cell rac_signalForSelector:@selector(upgradeMemberAction:)] subscribeNext:^(RACTuple * _Nullable x) {
                [weakSelf showUpgradeMemberView];
            }];
            return cell;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            IPCCustomerDetailTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topTitleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerDetailTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"验光单" ButtonTitle:nil ButtonImage:@"icon_manager"];
            
            __weak typeof(self) weakSelf = self;
            [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(id x) {
                [weakSelf pushToManagerOptometryViewController];
            }];
            return cell;
        }else{
            IPCCustomerOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:optometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if (self.customerViewMode.customerOpometry) {
                cell.optometryMode = self.customerViewMode.customerOpometry;
            }
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            IPCCustomerDetailTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topTitleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerDetailTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setLeftTitle:@"历史订单信息"];
            return cell;
        }else if (self.customerViewMode.isLoadMoreOrder && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] -1){
            IPCCustomerRefreshCell * cell = [tableView dequeueReusableCellWithIdentifier:footLoadIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerRefreshCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            return cell;
        }else{
            IPCCustomerHistoryOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerHistoryOrderCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if (self.customerViewMode.orderList.count && self.customerViewMode) {
                IPCCustomerOrderMode * order = self.customerViewMode.orderList[indexPath.row-1];
                cell.customerOrder = order;
            }
            return cell;
        }
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row > 0) {
        return 305;
    }else if (indexPath.section == 1 && indexPath.row > 0){
        return 150;
    }else if (indexPath.section == 2 && indexPath.row > 0){
        if (indexPath.row <= self.customerViewMode.orderList.count)
            return 80;
    }
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.customerViewMode && self.customerViewMode.orderList.count) {
        if (indexPath.section == 2 && indexPath.row > 0) {
            if (self.customerViewMode.isLoadMoreOrder && indexPath.row == self.customerViewMode.orderList.count + 1) {
                [self loadMoreOrderData];
            }else{
                IPCCustomerOrderMode * order = self.customerViewMode.orderList[indexPath.row-1];
                [self loadOrderDetailView:order];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window){
        self.view = nil;
        self.customerViewMode = nil;
        self.upgradeMemberView = nil;
        self.editCustomerView = nil;
        self.detailOrderView = nil;
        [IPCHttpRequest cancelAllRequest];
    }
}




@end
