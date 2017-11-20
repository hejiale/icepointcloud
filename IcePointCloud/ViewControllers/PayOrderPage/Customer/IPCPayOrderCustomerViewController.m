//
//  IPCPayOrderCustomerViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderCustomerViewController.h"
#import "IPCPayOrderCustomInfoView.h"
#import "IPCPayOrderCustomerCollectionViewCell.h"
#import "IPCCustomerListViewModel.h"
#import "IPCPayOrderEditCustomerView.h"

static NSString * const customerIdentifier = @"IPCPayOrderCustomerCollectionViewCellIdentifier";

@interface IPCPayOrderCustomerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *customInfoContentView;
@property (weak, nonatomic) IBOutlet UICollectionView *customerCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *alertEmptyCustomerImageView;

@property (nonatomic, strong) IPCRefreshAnimationHeader   *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter    *refreshFooter;
@property (nonatomic, strong) IPCCustomerListViewModel    * viewModel;
@property (nonatomic, strong) IPCPayOrderCustomInfoView * infoView;

@end

@implementation IPCPayOrderCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadCollectionView];
    self.viewModel = [[IPCCustomerListViewModel alloc]init];
    [self loadData];
}


#pragma mark //Set UI
- (void)loadCollectionView{
    CGFloat itemWidth = (self.customerCollectionView.jk_width-10)/3;
    CGFloat itemHeight = (self.customerCollectionView.jk_height-30)/7;
    
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

- (IPCPayOrderCustomInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[IPCPayOrderCustomInfoView alloc]initWithFrame:self.customInfoContentView.bounds];
    }
    return _infoView;
}

#pragma mark //Refresh Methods
- (void)beginRefresh
{
    //Stop Footer Refresh Method
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
        [[IPCHttpRequest sharedClient] cancelAllRequest];
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
             if ([error code] == NSURLErrorCancelled) {
                 
             }else{
                 [IPCCommonUI showError:@"查询客户失败,请稍后重试!"];
             }
         }
         [strongSelf reload];
     }];
}

- (void)queryCustomerDetailWithCustomerId:(NSString *)customerId
{
    [IPCCommonUI show];
    __weak typeof(self) weakSelf = self;
    [IPCCustomerRequestManager queryCustomerDetailInfoWithCustomerID:customerId
                                                        SuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [[IPCCurrentCustomer sharedManager] loadCurrentCustomer:responseValue];
         [strongSelf.infoView updateCustomerInfo];
         [strongSelf.customInfoContentView addSubview:strongSelf.infoView];
         [strongSelf.customInfoContentView bringSubviewToFront:strongSelf.infoView];
         [IPCCommonUI hiden];
     } FailureBlock:^(NSError *error) {
         if ([error code] != NSURLErrorCancelled) {
             [IPCCommonUI showError:@"查询客户信息失败!"];
         }
     }];
}


#pragma mark //Reload CollectionView
- (void)reload
{
    self.customerCollectionView.isBeginLoad = NO;
    [self.customerCollectionView reloadData];
    [self stopRefresh];
}

- (void)stopRefresh{
    if (self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
    }
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
    }
}

#pragma mark //Clicked Events
- (IBAction)insertNewCustomerAction:(id)sender {
    IPCPayOrderEditCustomerView * editCustomerView = [[IPCPayOrderEditCustomerView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:editCustomerView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:editCustomerView];
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
    IPCCustomerMode * customer = self.viewModel.customerArray[indexPath.row];
    [IPCPayOrderManager sharedManager].currentCustomerId = customer.customerID;
    [self queryCustomerDetailWithCustomerId:customer.customerID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
