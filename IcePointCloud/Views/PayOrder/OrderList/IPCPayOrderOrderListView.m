//
//  IPCPayOrderOrderListView.m
//  IcePointCloud
//
//  Created by gerry on 2018/3/21.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderOrderListView.h"
#import "IPCPayOrderOrderListViewCell.h"

static NSString * const orderListCellIdentifier = @"IPCPayOrderOrderListViewCellIdentifier";

@interface IPCPayOrderOrderListView()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentPage;
    NSString * currentOrderNum;
}
@property (weak, nonatomic) IBOutlet UITableView *orderListTableView;
@property (nonatomic, strong) IPCRefreshAnimationHeader   *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter    *refreshFooter;
@property (nonatomic, strong) NSMutableArray<IPCCustomerOrderMode *> * orderList;
@property (nonatomic, copy) void(^CompleteBlock)(NSString * orderNum);

@end

@implementation IPCPayOrderOrderListView

- (instancetype)initWithFrame:(CGRect)frame Complete:(void(^)(NSString * orderNum))complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CompleteBlock = complete;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderOrderListView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.orderListTableView.mj_header = self.refreshHeader;
    self.orderListTableView.mj_footer = self.refreshFooter;
    [self.orderListTableView setTableHeaderView:[[UIView alloc]init]];
    [self.orderListTableView setTableFooterView:[[UIView alloc]init]];
    self.orderListTableView.emptyAlertImage = @"exception_search";
    self.orderListTableView.emptyAlertTitle = @"未查询到任何订单信息!";
    [self.refreshHeader beginRefreshing];
}

- (NSMutableArray<IPCCustomerOrderMode *> *)orderList{
    if (!_orderList) {
        _orderList = [[NSMutableArray alloc]init];
    }
    return _orderList;
}

#pragma mark //Set UI
- (IPCRefreshAnimationHeader *)refreshHeader{
    if (!_refreshHeader){
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    }
    return _refreshHeader;
}

- (IPCRefreshAnimationFooter *)refreshFooter{
    if (!_refreshFooter)
        _refreshFooter = [IPCRefreshAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    return _refreshFooter;
}

#pragma mark //Request Data
- (void)queryOrderListData
{
    [IPCCustomerRequestManager queryHistorySellInfoWithPhone:[[IPCPayOrderManager sharedManager] currentCustomer].customerID
                                                        Page:currentPage
                                                SuccessBlock:^(id responseValue)
     {
         IPCCustomerOrderList * orderObject = [[IPCCustomerOrderList alloc]initWithResponseValue:responseValue];
         [self.orderList addObjectsFromArray:orderObject.list];
         
         [self.orderListTableView reloadData];
         [self.refreshHeader endRefreshing];
         [self.refreshFooter endRefreshing];
         
     } FailureBlock:^(NSError *error) {
         
     }];
}

#pragma mark //UICollectionView Refresh Method
- (void)beginRefresh
{
    currentPage = 1;
    [self.orderList removeAllObjects];
    
    [self queryOrderListData];
}

- (void)loadMore
{
    currentPage++;
    [self queryOrderListData];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCPayOrderOrderListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:orderListCellIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCPayOrderOrderListViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    IPCCustomerOrderMode * orderMode = self.orderList[indexPath.row];
    cell.customerOrder = orderMode;
    cell.orderNum = currentOrderNum;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark //UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderList.count) {
        IPCCustomerOrderMode * orderMode = self.orderList[indexPath.row];
        currentOrderNum = orderMode.orderCode;
        
        if (orderMode) {
            if (self.CompleteBlock) {
                self.CompleteBlock(orderMode.orderCode);
            }
            [tableView reloadData];
        }
    }
}


@end
