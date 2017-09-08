//
//  GlassListViewController.m
//  IcePointCloud
//
//  Created by mac on 7/23/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCGlassListViewController.h"
#import "IPCGlassDetailsViewController.h"
#import "IPCGlasslistCollectionViewCell.h"
#import "IPCGlassParameterView.h"
#import "IPCEditBatchParameterView.h"
#import "IPCProductViewMode.h"
#import "IPCPayOrderViewController.h"
#import "IPCSearchViewController.h"

static NSString * const glassListCellIdentifier = @"GlasslistCollectionViewCellIdentifier";

@interface IPCGlassListViewController ()<GlasslistCollectionViewCellDelegate,IPCSearchViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic)   IBOutlet UICollectionView               *glassListCollectionView;
@property (strong, nonatomic) IPCGlassParameterView                  *parameterView;
@property (strong, nonatomic) IPCEditBatchParameterView           *editParameterView;
@property (nonatomic, strong) IPCRefreshAnimationHeader          *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter           *refreshFooter;
@property (strong, nonatomic) IPCProductViewMode                   *glassListViewMode;

@end

@implementation IPCGlassListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glassListViewMode =  [[IPCProductViewMode alloc]init];
    self.glassListViewMode.isTrying = NO;
    [self loadCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:YES];
    [self.refreshHeader beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeCover];
    
    if (self.refreshFooter.isRefreshing || self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        [[IPCHttpRequest sharedClient] cancelAllRequest];
    }
}

#pragma mark //Set UI
- (void)loadCollectionView{
    __block CGFloat width = (self.view.jk_width-2)/3;
    __block CGFloat height = (self.view.jk_height-2)/3;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setItemSize:CGSizeMake(width, height)];
    [layout setMinimumLineSpacing:1];
    [layout setMinimumInteritemSpacing:1];
    
    [self.glassListCollectionView setCollectionViewLayout:layout];
    [self.glassListCollectionView registerNib:[UINib nibWithNibName:@"IPCGlasslistCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:glassListCellIdentifier];
    self.glassListCollectionView.mj_header = self.refreshHeader;
    self.glassListCollectionView.mj_footer = self.refreshFooter;
    self.glassListCollectionView.emptyAlertTitle = @"未搜索到任何商品";
    self.glassListCollectionView.emptyAlertImage = @"exception_search";
}


- (IPCRefreshAnimationHeader *)refreshHeader{
    if (!_refreshHeader){
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginReloadTableView)];
    }
    return _refreshHeader;
}

- (IPCRefreshAnimationFooter *)refreshFooter{
    if (!_refreshFooter)
        _refreshFooter = [IPCRefreshAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTableView)];
    return _refreshFooter;
}


#pragma mark //Refresh Method
- (void)beginReloadTableView{
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
        [[IPCHttpRequest sharedClient] cancelAllRequest];
    }
    
    [self.refreshFooter resetDataStatus];
    self.glassListViewMode.isBeginLoad = YES;
    self.glassListViewMode.currentPage = 0;
    
    [self loadNormalProducts];
}

- (void)loadMoreTableView{
    if (self.glassListViewMode.status == IPCFooterRefresh_HasNoMoreData)return;
    
    self.glassListViewMode.isBeginLoad = NO;
    self.glassListViewMode.currentPage += 30;
    
    __weak typeof(self) weakSelf = self;
    [self loadGlassesListData:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf reload];
    }];
}

#pragma mark //Load Data
- (void)loadNormalProducts
{
    __weak typeof (self) weakSelf = self;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf loadGlassesListData:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.glassListViewMode filterGlassCategoryWithFilterSuccess:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf reload];
    });
}


- (void)loadGlassesListData:(void(^)())complete
{
    __weak typeof(self) weakSelf = self;
    [self.glassListViewMode reloadGlassListDataWithIsTry:NO Complete:^(){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.glassListViewMode.status == IPCFooterRefresh_HasNoMoreData){
            [strongSelf.refreshFooter noticeNoDataStatus];
        }
        if (complete) {
            complete();
        }
    }];
}

#pragma mark //Clicked Events
- (void)removeCover
{
    [super removeCover];
    
    [self.glassListViewMode.filterView removeFromSuperview];
    [self.coverView removeFromSuperview];
}

//Add a shopping cart animation
- (void)addCartAnimationInCell:(IPCGlasslistCollectionViewCell *)cell{
    [self reload];
    CGPoint startPoint  = [cell convertRect:cell.addCartButton.frame toView:self.view.superview].origin;
    CGPoint endPoint   = CGPointMake(self.view.superview.jk_width-85, -30);
    [self startAnimationWithStartPoint:startPoint EndPoint:endPoint];
}

- (void)reload{
    [super reload];
    
    [self.glassListCollectionView reloadData];
    
    if (self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
    }
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
    }
}

- (void)onFilterProducts{
    [super onFilterProducts];
    
    if ([self.glassListViewMode.filterView superview]) {
        [self removeCover];
    }else{
        __weak typeof (self) weakSelf = self;
        [self addCoverWithAlpha:0.2 Complete:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf removeCover];
        }];
        [self.glassListViewMode loadFilterCategory:self InView:self.coverView ReloadClose:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf removeCover];
            [strongSelf.refreshHeader beginRefreshing];
            [strongSelf.glassListViewMode queryBatchDegree];
        } ReloadUnClose:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.refreshHeader beginRefreshing];
        }];
    }
}

- (void)onSearchProducts{
    [super onSearchProducts];
    
    [self removeCover];
    [self presentSearchViewController];
}

- (void)presentSearchViewController{
    IPCSearchViewController * searchViewMode = [[IPCSearchViewController alloc]initWithNibName:@"IPCSearchViewController" bundle:nil];
    searchViewMode.searchDelegate = self;
    searchViewMode.filterType = self.glassListViewMode.currentType;
    [searchViewMode showSearchProductViewWithSearchWord:self.glassListViewMode.searchWord];
    [self presentViewController:searchViewMode animated:YES completion:nil];
}

#pragma mark //UICollectionViewDataSoure
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.glassListViewMode.glassesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCGlasslistCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:glassListCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    if ([self.glassListViewMode.glassesList count] && self.glassListViewMode){
        IPCGlasses * glasses = self.glassListViewMode.glassesList[indexPath.row];
        [cell setGlasses:glasses];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.glassListViewMode.status == IPCFooterRefresh_HasMoreData) {
        if (!self.refreshFooter.isRefreshing) {
            if (indexPath.row == self.glassListViewMode.glassesList.count -20) {
                [self.refreshFooter beginRefreshing];
            }
        }
    }
}

#pragma mark //GlassListViewCellDelegate
- (void)addShoppingCartAnimation:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0)
        [self addCartAnimationInCell:cell];
}

- (void)showProductDetail:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.glassListCollectionView indexPathForCell:cell];
        
        IPCGlassDetailsViewController * detailVC = [[IPCGlassDetailsViewController alloc]initWithNibName:@"IPCGlassDetailsViewController" bundle:nil];
        detailVC.glasses  = self.glassListViewMode.glassesList[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)chooseParameter:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.glassListCollectionView indexPathForCell:cell];
        self.parameterView = [[IPCGlassParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds  Complete:^{
            [self reload];
        }];
        self.parameterView.glasses = self.glassListViewMode.glassesList[indexPath.row];
        [[UIApplication sharedApplication].keyWindow addSubview:self.parameterView];
        [self.parameterView show];
    }
}

- (void)editBatchParameter:(IPCGlasslistCollectionViewCell *)cell{
    __weak typeof (self) weakSelf = self;
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.glassListCollectionView indexPathForCell:cell];
        self.editParameterView = [[IPCEditBatchParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds Glasses:self.glassListViewMode.glassesList[indexPath.row] Dismiss:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.editParameterView removeFromSuperview];strongSelf.editParameterView = nil;
            [strongSelf reload];
        }];
        [[UIApplication sharedApplication].keyWindow addSubview:self.editParameterView];
        [self.editParameterView show];
    }
}

- (void)reloadProductList{
    [self reload];
}

#pragma mark //IPCSearchViewControllerDelegate
- (void)didSearchWithKeyword:(NSString *)keyword
{
    self.glassListViewMode.searchWord = keyword;
    [self.refreshHeader beginRefreshing];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    self.glassListViewMode = nil;
}


@end
