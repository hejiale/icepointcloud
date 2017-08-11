//
//  IPCSearchCustomerViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCSearchCustomerViewController.h"
#import "IPCCustomerCollectionViewCell.h"
#import "IPCInsertCustomerViewController.h"
#import "IPCCustomerDetailViewController.h"
#import "IPCSearchViewController.h"

static NSString * const customerIdentifier = @"CustomerCollectionViewCellIdentifier";

@interface IPCSearchCustomerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,IPCSearchViewControllerDelegate>
{
    NSString * searchKeyWord;
}
@property (weak, nonatomic) IBOutlet UICollectionView *customerCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *insertButton;
@property (nonatomic, strong) NSMutableArray<NSString *> * keywordHistory;
@property (nonatomic, strong) IPCCustomerList * customerList;
@property (nonatomic, strong) IPCRefreshAnimationHeader   *refreshHeader;

@end

@implementation IPCSearchCustomerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([IPCPayOrderManager sharedManager].isPayOrderStatus || [IPCInsertCustomer instance].isInsertStatus) {
        [self setNavigationTitle:@"客户"];
        [self setNavigationBarStatus:NO];
    }else{
        [self setNavigationBarStatus:YES];
    }
    [self.insertButton setHidden:[IPCInsertCustomer instance].isInsertStatus];
}

- (NSMutableArray<NSString *> *)keywordHistory
{
    if (!_keywordHistory) {
        _keywordHistory = [[NSMutableArray alloc]init];
    }
    return _keywordHistory;
}

#pragma mark //Set UI
- (void)loadCollectionView{
    CGFloat itemWidth = (self.view.jk_width-2)/3;
    CGFloat itemHeight = (self.view.jk_height-2)/5;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    [_customerCollectionView setCollectionViewLayout:layout];
    _customerCollectionView.emptyAlertImage = @"exception_search";
    _customerCollectionView.emptyAlertTitle = @"未查询到客户信息!";
    _customerCollectionView.mj_header = self.refreshHeader;
    [_customerCollectionView registerNib:[UINib nibWithNibName:@"IPCCustomerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:customerIdentifier];
    [self.refreshHeader beginRefreshing];
}

- (IPCRefreshAnimationHeader *)refreshHeader{
    if (!_refreshHeader){
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    }
    return _refreshHeader;
}

#pragma mark //Refresh Method
- (void)refreshData{
    [self queryCustomerInfo:^{
        [self.customerCollectionView reloadData];
        
        if (self.refreshHeader.isRefreshing) {
            [self.refreshHeader endRefreshing];
        }
    }];
}


#pragma mark //Request Data
- (void)queryCustomerInfo:(void(^)())complete
{
    [IPCCustomerRequestManager queryCustomerListWithKeyword:searchKeyWord ? : @""
                                               SuccessBlock:^(id responseValue)
     {
         _customerList = [[IPCCustomerList alloc]initWithResponseValue:responseValue];
         
         if (complete) {
             complete();
         }
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:@"查询客户信息失败!"];
     }];
}

#pragma mark //Clicked Events
- (IBAction)insertNewCustomerAction:(id)sender {
    IPCInsertCustomerViewController * insertCustomerVC = [[IPCInsertCustomerViewController alloc]initWithNibName:@"IPCInsertCustomerViewController" bundle:nil];
    [self.navigationController pushViewController:insertCustomerVC animated:YES];
}

- (IBAction)searchCustomerAction:(id)sender{
    IPCSearchViewController * searchVC = [[IPCSearchViewController alloc]initWithNibName:@"IPCSearchViewController" bundle:nil];
    searchVC.searchDelegate = self;
    [searchVC showSearchCustomerViewWithSearchWord:searchKeyWord];
    [self presentViewController:searchVC animated:YES completion:nil];
}

#pragma mark //UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.customerList.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCCustomerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:customerIdentifier forIndexPath:indexPath];
    
    IPCCustomerMode * customer = self.customerList.list[indexPath.row];
    cell.currentCustomer = customer;
    return cell;
}


#pragma mark //UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.customerList.list.count) {
        IPCCustomerMode * customer = self.customerList.list[indexPath.row];
        
        if (customer) {
            if ([IPCInsertCustomer instance].isInsertStatus) {
                [IPCInsertCustomer instance].introducerId = customer.customerID;
                [IPCInsertCustomer instance].introducerName = customer.customerName;
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([IPCPayOrderManager sharedManager].isPayOrderStatus){
                [[IPCPayOrderManager sharedManager] resetPayPrice];
                [IPCPayOrderManager sharedManager].currentCustomerId = customer.customerID;
                
                [[NSNotificationCenter defaultCenter]postNotificationName:IPCChooseCustomerNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                IPCCustomerDetailViewController * detailVC = [[IPCCustomerDetailViewController alloc]initWithNibName:@"IPCCustomerDetailViewController" bundle:nil];
                [detailVC setCustomer:customer];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }
}

#pragma mark //IPCSearchViewControllerDelegate
- (void)didSearchWithKeyword:(NSString *)keyword{
    searchKeyWord = keyword;
    [self.refreshHeader beginRefreshing];
}


@end
