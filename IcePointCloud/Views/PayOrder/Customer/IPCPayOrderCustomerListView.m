//
//  IPCPayOrderCustomerListView.m
//  IcePointCloud
//
//  Created by gerry on 2018/2/27.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderCustomerListView.h"
#import "IPCCustomerListViewModel.h"
#import "IPCPayOrderCustomerCollectionViewCell.h"
#import "IPCPayOrderMemberCollectionViewCell.h"

static NSString * const customerIdentifier = @"IPCPayOrderCustomerCollectionViewCellIdentifier";
static NSString * const memberIdentifier = @"IPCPayOrderMemberCollectionViewCellIdentifier";

@interface IPCPayOrderCustomerListView()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
{
    BOOL  chooseStatus;
}
@property (weak, nonatomic) IBOutlet UICollectionView *customerCollectionView;
@property (nonatomic, strong) IPCRefreshAnimationHeader   *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter    *refreshFooter;
@property (nonatomic, strong) IPCCustomerListViewModel    * viewModel;
@property (nonatomic, copy) void(^DetailBlock)(IPCDetailCustomer * customer);

@end

@implementation IPCPayOrderCustomerListView

- (instancetype)initWithFrame:(CGRect)frame  IsChooseStatus:(BOOL)isChoose Detail:(void(^)(IPCDetailCustomer * customer))detail
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderCustomerListView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        chooseStatus = isChoose;
        self.DetailBlock = detail;
        [self loadCollectionView];
        self.viewModel = [[IPCCustomerListViewModel alloc]init];
        [self loadData];
    }
    return self;
}

#pragma mark //Set UI
- (void)loadCollectionView{
    CGFloat itemWidth = (self.jk_width-10)/3;
    CGFloat itemHeight = (self.jk_height-30-60)/7;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    [_customerCollectionView setCollectionViewLayout:layout];
    _customerCollectionView.emptyAlertImage = @"exception_search";
    _customerCollectionView.emptyAlertTitle = @"未查询到客户信息!";
    _customerCollectionView.mj_header = self.refreshHeader;
    _customerCollectionView.mj_footer = self.refreshFooter;
    [_customerCollectionView registerNib:[UINib nibWithNibName:@"IPCPayOrderCustomerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:customerIdentifier];
    [_customerCollectionView registerNib:[UINib nibWithNibName:@"IPCPayOrderMemberCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:memberIdentifier];
}

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

#pragma mark //Refresh Methods
- (void)beginRefresh
{
    //Stop Footer Refresh Method
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
        [IPCHttpRequest  cancelAllRequest];
    }
    [self.refreshFooter resetDataStatus];
    [self.viewModel resetData];
    
    [self loadCustomerList];
}

- (void)loadMore
{
    self.viewModel.currentPage++;
    [self loadCustomerList];
}

#pragma mark //Load Data
- (void)loadData
{
    [self.viewModel resetData];
    self.customerCollectionView.isBeginLoad = YES;
    [self loadCustomerList];
    [self.customerCollectionView reloadData];
}

#pragma mark //Request Data
- (void)loadCustomerList
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryCustomerList:^(NSError *error)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         if (strongSelf.viewModel.status == IPCFooterRefresh_HasNoMoreData) {
             [strongSelf.refreshFooter noticeNoDataStatus];
         }else if (strongSelf.viewModel.status == IPCRefreshError){
             if ([error code] != NSURLErrorCancelled) {
                 [IPCCommonUI showError:@"查询客户失败,请稍后重试!"];
             }
         }
         [weakSelf reload];
     }];
}

- (void)queryCustomerDetail:(NSString *)customerId
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel queryCustomerDetailWithStatus:chooseStatus
                                       CustomerId:customerId
                                         Complete:^(IPCDetailCustomer * customer)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         if (strongSelf.DetailBlock) {
             strongSelf.DetailBlock(customer);
         }
         [weakSelf reload];
     }];
}

#pragma mark //Reload CollectionView
- (void)reload
{
    self.customerCollectionView.isBeginLoad = NO;
    [self.customerCollectionView reloadData];
    [self stopRefresh];
}

- (void)stopRefresh
{
    if (self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
    }
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
    }
}

#pragma mark //UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.customerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCPayOrderCustomerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:customerIdentifier forIndexPath:indexPath];
    
    if (self.viewModel && self.viewModel.customerArray.count) {
        IPCCustomerMode * customer = self.viewModel.customerArray[indexPath.row];
        cell.currentCustomer = customer;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Prereload Data
    if (self.viewModel.status == IPCFooterRefresh_HasMoreData) {
        if (!self.refreshFooter.isRefreshing) {
            if (indexPath.row == self.viewModel.customerArray.count -10) {
                [self.refreshFooter beginRefreshing];
            }
        }
    }
}

#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.customerArray.count) {
        IPCCustomerMode * customer = self.viewModel.customerArray[indexPath.row];
        
        if ([customer.customerID isEqualToString:[IPCPayOrderManager sharedManager].currentCustomerId])return;
        
        if (customer) {
            if (!chooseStatus) {
                [IPCPayOrderManager sharedManager].isValiateMember = NO;
                [IPCPayOrderManager sharedManager].currentCustomerId = customer.customerID;
            }
            [self queryCustomerDetail:customer.customerID];
        }
    }
}


#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.viewModel.searchWord = [textField.text jk_trimmingWhitespace];
    [self loadData];
}


@end
