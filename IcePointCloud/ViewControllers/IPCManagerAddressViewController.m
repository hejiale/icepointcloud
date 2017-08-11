//
//  IPCManagerAddressViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCManagerAddressViewController.h"
#import "IPCManagerAddressViewModel.h"
#import "IPCManagerAddressCell.h"
#import "IPCEditAddressView.h"

static NSString * const addressIdentifier = @"IPCEditAddressCellIdentifier";

@interface IPCManagerAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (strong, nonatomic) IPCEditAddressView * editAddressView;
@property (strong, nonatomic) IPCManagerAddressViewModel * addressViewModel;
@property (nonatomic, strong) IPCRefreshAnimationHeader    *refreshHeader;

@end

@implementation IPCManagerAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBarStatus:NO];
    [self setNavigationTitle:@"收货地址"];
    [self setRightItem:@"icon_insert_btn" Selection:@selector(insertNewAddressAction)];
    
    [self.addressTableView setTableFooterView:[[UIView alloc]init]];
    self.addressTableView.emptyAlertImage = @"icon_nonAddress";
    self.addressTableView.emptyAlertTitle = @"暂未添加收货地址";
    self.addressTableView.mj_header = self.refreshHeader;
    [self.refreshHeader beginRefreshing];
}


- (void)setCustomerId:(NSString *)customerId
{
    _customerId = customerId;
    
    if (_customerId) {
        self.addressViewModel = [[IPCManagerAddressViewModel alloc]init];
        self.addressViewModel.customerId = _customerId;
    }
}

#pragma mark //Request Data
- (void)loadAddressListData{
    __weak typeof(self) weakSelf = self;
    [self.addressViewModel queryCustomerAddressList:^ {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.addressTableView reloadData];
        [strongSelf.refreshHeader endRefreshing];
    }];
}


- (void)setDefaultAddress:(NSString *)addressId{
    __weak typeof(self) weakSelf = self;
    [self.addressViewModel setCurrentAddress:addressId Complete:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.refreshHeader beginRefreshing];
    }];
}

#pragma mark //Set UI
- (IPCEditAddressView *)editAddressView{
    if (!_editAddressView) {
        _editAddressView = [[IPCEditAddressView alloc]initWithFrame:self.view.bounds
                                                         CustomerID:self.addressViewModel.customerId
                                                           Complete:^(NSString *addressId) {
                                                               [_editAddressView removeFromSuperview];
                                                               [self loadAddressListData];
                                                           } Dismiss:^{
                                                               [_editAddressView removeFromSuperview];
                                                           }];
    }
    return _editAddressView;
}

- (MJRefreshBackStateFooter *)refreshHeader{
    if (!_refreshHeader){
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAddressListData)];
    }
    return _refreshHeader;
}

#pragma mark //Clicked Events
- (void)insertNewAddressAction{
    if (self.editAddressView) {
        [self.editAddressView removeFromSuperview];self.editAddressView = nil;
    }
    [self.view addSubview:self.editAddressView];
    [self.view bringSubviewToFront:self.editAddressView];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressViewModel.addressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCManagerAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCManagerAddressCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    IPCCustomerAddressMode * address = self.addressViewModel.addressList[indexPath.row];
    cell.addressMode = address;
    
    if (indexPath.row == 0) {
        [cell.defaultButton setSelected:YES];
    }else{
        [cell.defaultButton setSelected:NO];
    }
    __weak typeof(self) weakSelf = self;
    [[cell rac_signalForSelector:@selector(setDefaultAction:)] subscribeNext:^(RACTuple * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setDefaultAddress:address.addressID];
    }];
    return cell;
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if ([IPCPayOrderManager sharedManager].isPayOrderStatus) {
        IPCCustomerAddressMode * address = self.addressViewModel.addressList[indexPath.row];
        [IPCCurrentCustomer sharedManager].currentAddress = nil;
        [IPCCurrentCustomer sharedManager].currentAddress = address;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
