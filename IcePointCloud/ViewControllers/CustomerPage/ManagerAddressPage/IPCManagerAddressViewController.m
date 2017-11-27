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

@interface IPCManagerAddressViewController ()<UITableViewDelegate,UITableViewDataSource,IPCManagerAddressCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (strong, nonatomic) IPCEditAddressView * editAddressView;
@property (strong, nonatomic) IPCManagerAddressViewModel * addressViewModel;

@end

@implementation IPCManagerAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Set Up NavigationBar
    [self setNavigationBarStatus:NO];
    [self setNavigationTitle:@"收货地址"];
    [self setRightItem:@"icon_insert_btn" Selection:@selector(insertNewAddressAction)];
    //Load TableView
    [self loadTableView];
    //Load Data
    [self loadAddressListData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //Cancel Request
    [[IPCHttpRequest sharedClient] cancelAllRequest];
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
- (void)loadAddressListData
{
    [self.addressViewModel.addressList removeAllObjects];
    self.addressViewModel.addressList = nil;
    self.addressTableView.isBeginLoad = YES;
    [self.addressTableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    [self.addressViewModel queryCustomerAddressList:^ {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.addressTableView.isBeginLoad = NO;
        [strongSelf.addressTableView reloadData];
    }];
}


- (void)setDefaultAddress:(NSString *)addressId{
    [IPCCommonUI showInfo:@"正在设置默认地址..."];
    
    __weak typeof(self) weakSelf = self;
    [self.addressViewModel setCurrentAddress:addressId Complete:^{
        [IPCCommonUI showSuccess:@"设置成功!"];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf performSelector:@selector(loadAddressListData) withObject:nil afterDelay:1.f];
    }];
}

#pragma mark //Set UI
- (void)loadTableView{
    [self.addressTableView setTableHeaderView:[[UIView alloc]init]];
    [self.addressTableView setTableFooterView:[[UIView alloc]init]];
    self.addressTableView.estimatedSectionHeaderHeight = 0;
    self.addressTableView.estimatedSectionFooterHeight = 0;
    self.addressTableView.emptyAlertImage = @"icon_nonAddress";
    self.addressTableView.emptyAlertTitle = @"暂未添加收货地址";
}


- (IPCEditAddressView *)editAddressView{
    __weak typeof(self) weakSelf = self;
    if (!_editAddressView) {
        _editAddressView = [[IPCEditAddressView alloc]initWithFrame:self.view.bounds
                                                         CustomerID:self.addressViewModel.customerId
                                                           Complete:^(NSString *addressId) {
                                                               __strong typeof(weakSelf) strongSelf = weakSelf;
                                                               [_editAddressView removeFromSuperview];
                                                               [strongSelf loadAddressListData];
                                                           } Dismiss:^{
                                                               [_editAddressView removeFromSuperview];
                                                           }];
    }
    return _editAddressView;
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
        cell.delegate = self;
    }
    IPCCustomerAddressMode * address = self.addressViewModel.addressList[indexPath.row];
    cell.addressMode = address;
    
    if (indexPath.row == 0) {
        [cell.defaultButton setSelected:YES];
    }else{
        [cell.defaultButton setSelected:NO];
    }
    return cell;
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark //
- (void)setDefaultAddressForCell:(IPCManagerAddressCell *)cell
{
    NSIndexPath * indexPath = [self.addressTableView indexPathForCell:cell];
    IPCCustomerAddressMode * address = self.addressViewModel.addressList[indexPath.row];
    
    [self setDefaultAddress:address.addressID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
