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
#import "IPCCustomerAddressCell.h"
#import "IPCCustomTopCell.h"
#import "IPCCustomerRefreshCell.h"
#import "IPCCustomDetailOrderView.h"
#import "IPCCustomerDetailViewMode.h"
#import "IPCUpdateCustomerView.h"
#import "IPCUpdateOrderViewController.h"
#import "IPCManagerOptometryViewController.h"
#import "IPCManagerAddressViewController.h"

static NSString * const topTitleIdentifier    = @"UserBaseTopTitleCellIdentifier";
static NSString * const footLoadIdentifier  = @"UserBaseFootCellIdentifier";
static NSString * const baseIdentifier        = @"UserBaseInfoCellIdentifier";
static NSString * const optometryIdentifier = @"HistoryOptometryCellIdentifier";
static NSString * const orderIdentifier       = @"HistoryOrderCellIdentifier";
static NSString * const addressIdentifier   = @"CustomerAddressListCellIdentifier";

@interface IPCCustomerDetailViewController ()<UITableViewDelegate,UITableViewDataSource,IPCCustomerDetailViewDelegate,IPCUpdateOrderViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) IPCCustomerDetailViewMode * customerViewMode;
@property (strong, nonatomic) IPCCustomDetailOrderView  *  detailOrderView;
@property (strong, nonatomic) IPCUpdateCustomerView * updateCustomerView;
@property (nonatomic, strong) IPCRefreshAnimationHeader   *refreshHeader;

@end

@implementation IPCCustomerDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.topBar addBottomLine];
    
    [self.detailTableView setTableHeaderView:[[UIView alloc]init]];
    [self.detailTableView setTableFooterView:[[UIView alloc]init]];
    self.detailTableView.isHiden = YES;
    self.detailTableView.emptyAlertTitle = @"暂未查询到该客户信息，请重试！";
    self.detailTableView.emptyAlertImage = [UIImage imageNamed:@"exception_history"];
    self.detailTableView.mj_header = self.refreshHeader;
    [self.refreshHeader beginRefreshing];
    
    self.customerViewMode = [[IPCCustomerDetailViewMode alloc]init];
    self.customerViewMode.currentCustomer = self.customer;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self setNavigationBarStatus:YES];
}

#pragma mark //Request Data
- (void)requestCustomerDetailInfo{
    [self.customerViewMode resetData];
    
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
        [strongSelf.customerViewMode queryHistoryOptometryList:^{
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
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [strongSelf.customerViewMode queryCustomerAddressList:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.detailTableView reloadData];
        [strongSelf.refreshHeader endRefreshing];
    });
}


#pragma mark //Set UI
- (void)loadOrderDetailView:(IPCCustomerOrderMode *)orderObject{
    [self.view endEditing:YES];
    __weak typeof (self) weakSelf = self;
    self.detailOrderView = [[IPCCustomDetailOrderView alloc]initWithFrame:self.view.bounds
                                                                 OrderNum:orderObject.orderCode
                                                            ProductDetail:^(IPCGlasses *glass) {

                                                            } Pay:^{
                                                                __strong typeof (weakSelf) strongSelf = weakSelf;
                                                                [strongSelf pushToUpdateOrderViewController];
                                                            }  Dismiss:^{
                                                                __strong typeof (weakSelf) strongSelf = weakSelf;
                                                                [strongSelf removerAllPopView:NO];
                                                            }];
    [self.view addSubview:self.detailOrderView];
    [self.view bringSubviewToFront:self.detailOrderView];
    [self.detailOrderView show];
}


- (void)loadUpdateCustomerView{
    self.updateCustomerView = [[IPCUpdateCustomerView alloc]initWithFrame:self.contentView.bounds];
    self.updateCustomerView.currentDetailCustomer = self.customerViewMode.detailCustomer;
    self.updateCustomerView.delegate = self;
    [self.contentView addSubview:self.updateCustomerView];
    [self.contentView bringSubviewToFront:self.updateCustomerView];

     __weak typeof(self) weakSelf = self;
    [[self.updateCustomerView rac_signalForSelector:@selector(removeCoverAction:)] subscribeNext:^(id x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removerAllPopView:NO];
    }];
}

- (MJRefreshBackStateFooter *)refreshHeader{
    if (!_refreshHeader){
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestCustomerDetailInfo)];
    }
    return _refreshHeader;
}

#pragma mark //ClickEvents
- (IBAction)backToLastAction{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  Load More
 */
- (void)loadMoreOptometryData{
    __weak typeof (self) weakSelf = self;
    self.customerViewMode.optometryCurrentPage++;
    [self.customerViewMode queryHistoryOptometryList:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.detailTableView reloadData];
    }];
}

- (void)loadMoreOrderData{
    __weak typeof (self) weakSelf = self;
    self.customerViewMode.orderCurrentPage++;
    [self.customerViewMode queryHistotyOrderList:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.detailTableView reloadData];
    }];
}

/**
 *  Push Method
 */
- (void)pushToUpdateOrderViewController{
    IPCUpdateOrderViewController * updateOrderVC = [[IPCUpdateOrderViewController  alloc]initWithNibName:@"IPCUpdateOrderViewController" bundle:nil];
    updateOrderVC.delegate = self;
    [self.navigationController pushViewController:updateOrderVC animated:YES];
}

- (void)pushToManagerOptometryViewController{
    IPCManagerOptometryViewController * optometryVC = [[IPCManagerOptometryViewController alloc]initWithNibName:@"IPCManagerOptometryViewController" bundle:nil];
    optometryVC.customerId = self.customerViewMode.detailCustomer.customerID;
    [self.navigationController pushViewController:optometryVC animated:YES];
}

- (void)pushToManagerAddressViewController{
    IPCManagerAddressViewController * addressVC = [[IPCManagerAddressViewController alloc]initWithNibName:@"IPCManagerAddressViewController" bundle:nil];
    addressVC.customerId = self.customerViewMode.detailCustomer.customerID;
    [self.navigationController pushViewController:addressVC animated:YES];
}


/**
 *  Dismiss Cover
 */
- (void)removerAllPopView:(BOOL)isLoad
{
    [self.updateCustomerView removeFromSuperview];
    [self.detailOrderView removeFromSuperview];
    if (isLoad) {
        [self requestCustomerDetailInfo];
    }
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        if (self.customerViewMode.isLoadMoreOptometry)
            return self.customerViewMode.optometryList.count + 2;
        return self.customerViewMode.optometryList.count + 1;
    }else if (section == 3){
        if (self.customerViewMode.isLoadMoreOrder)
            return self.customerViewMode.orderList.count+2;
        return self.customerViewMode.orderList.count > 0 ? self.customerViewMode.orderList.count+1 : 0;
    }
    return self.customerViewMode.addressList.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topTitleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"客户基本信息" ButtonTitle:nil ButtonImage:@"icon_edit_customer"];
            [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(id x) {
                [self loadUpdateCustomerView];
            }];
            return cell;
        }else{
            IPCCustomerDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:baseIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerDetailCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if (self.customerViewMode && self.customerViewMode.detailCustomer) {
                cell.currentCustomer = self.customerViewMode.detailCustomer;
            }
            return cell;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topTitleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"历史验光单" ButtonTitle:@"管理" ButtonImage:nil];
            [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(id x) {
                [self pushToManagerOptometryViewController];
            }];
            return cell;
        }else if (self.customerViewMode.isLoadMoreOptometry && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] -1){
            IPCCustomerRefreshCell * cell = [tableView dequeueReusableCellWithIdentifier:footLoadIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerRefreshCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            return cell;
        }else{
            IPCCustomerOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:optometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if (self.customerViewMode && self.customerViewMode.optometryList.count) {
                IPCOptometryMode * optometry = self.customerViewMode.optometryList[indexPath.row -1];
                cell.optometryMode = optometry;
            }
            return cell;
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topTitleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"收货地址信息" ButtonTitle:@"管理" ButtonImage:nil];
            [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(id x) {
                [self pushToManagerAddressViewController];
            }];
            return cell;
        }else{
            IPCCustomerAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerAddressCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if (self.customerViewMode && self.customerViewMode.addressList.count) {
                IPCCustomerAddressMode * address = self.customerViewMode.addressList[indexPath.row-1];
                cell.addressMode = address;
                
                if (indexPath.row == 1) {
                    [cell.defaultLabel setHidden:NO];
                }else{
                    [cell.defaultLabel setHidden:YES];
                }
            }
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topTitleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
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
            if (self.customerViewMode && self.customerViewMode.orderList.count) {
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
        return 345;
    }else if (indexPath.section == 1 && indexPath.row > 0){
        if (self.customerViewMode.isLoadMoreOptometry && indexPath.row == self.customerViewMode.optometryList.count + 1)
            return 50;
        return 150;
    }else if (indexPath.section == 3 && indexPath.row > 0){
        if (self.customerViewMode.isLoadMoreOrder && indexPath.row == self.customerViewMode.orderList.count + 1)
            return 50;
        return 80;
    }else if (indexPath.section == 2 && indexPath.row > 0){
        return 70;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.customerViewMode.orderList.count == 0 && section == 3)return 0;
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 5)];
    [headView setBackgroundColor:[UIColor clearColor]];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if(self.customerViewMode.isLoadMoreOptometry && indexPath.row == self.customerViewMode.optometryList.count + 1){
            [self loadMoreOptometryData];
        }
    }else if (indexPath.section == 3 && indexPath.row > 0) {
        if (self.customerViewMode.isLoadMoreOrder && indexPath.row == self.customerViewMode.orderList.count + 1) {
            [self loadMoreOrderData];
        }else{
            IPCCustomerOrderMode * order = self.customerViewMode.orderList[indexPath.row-1];
            [self loadOrderDetailView:order];
        }
    }
}

#pragma mark //IPCCustomerDetailViewDelegate
- (void)dismissCoverSubViews{
    [self removerAllPopView:YES];
}

#pragma mark //IPCUpdateOrderViewControllerDelegate
- (void)updatePayOrder{
    [self removerAllPopView:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
