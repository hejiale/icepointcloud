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
#import "IPCProductViewMode.h"
#import "IPCSearchViewController.h"

static NSString * const glassListCellIdentifier = @"IPCGlasslistCollectionViewCellIdentifier";

@interface IPCGlassListViewController ()<GlasslistCollectionViewCellDelegate,IPCSearchViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    BOOL isCancelRequest;
}
@property (weak, nonatomic)   IBOutlet UICollectionView   *glassListCollectionView;
@property (weak, nonatomic)   IBOutlet UIButton                *goTopButton;
@property (strong, nonatomic) IPCProductViewMode          *glassListViewMode;

@end

@implementation IPCGlassListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Load CollectionView
    [self loadCollectionView];
    // Init ViewModel
    self.glassListViewMode =  [[IPCProductViewMode alloc]init];
    self.glassListViewMode.isTrying = NO;
    // Load Data
    [self beginFilterClass];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Choose WareHouse To Reload Products
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginFilterClass) name:IPCChooseWareHouseNotification object:nil];
    //According To NetWorkStatus And Judge Is Choose WareHouse To Reload Products
    if ((isCancelRequest && self.glassListViewMode.currentPage == 0) || [IPCAppManager sharedManager].isChangeHouse) {
        [self beginFilterClass];
        [IPCAppManager sharedManager].isChangeHouse = NO;
    }else{
        [self.glassListCollectionView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //Clear All Cover View
    [self removeCover];
    // Clear Refresh Animation
    [self stopRefresh];
    //Remove Notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCChooseWareHouseNotification object:nil];
}

#pragma mark //Set UI
- (void)loadCollectionView
{
    __block CGFloat width = (self.view.jk_width-2)/3;
    __block CGFloat height = (self.view.jk_height-2)/2;
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

#pragma mark //UICollectionView Refresh Method
- (void)beginRefresh{
    //Stop Footer Refresh Method
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
        [[IPCHttpRequest sharedClient] cancelAllRequest];
    }
    [self.refreshFooter resetDataStatus];
    [self loadNormalProducts];
}

- (void)loadMore
{
    self.glassListViewMode.currentPage += self.glassListViewMode.limit;
    
    __weak typeof(self) weakSelf = self;
    [self loadGlassesListData:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf reload];
    }];
}

#pragma mark //Normal Load Method
- (void)beginFilterClass
{
    self.glassListCollectionView.isBeginLoad = YES;
    [self loadNormalProducts];
    [self.glassListCollectionView reloadData];
}

#pragma mark //Load Glasses Data And Filter Data Request
- (void)loadNormalProducts
{
    //Reset Glasses Data
    [self.glassListViewMode resetData];
    
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
    [self.glassListViewMode reloadGlassListDataWithComplete:^(NSError * error){
        isCancelRequest = NO;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.glassListViewMode.status == IPCFooterRefresh_HasNoMoreData){
            [strongSelf.refreshFooter noticeNoDataStatus];
        }else if (strongSelf.glassListViewMode.status == IPCRefreshError){
            if ([error code] == NSURLErrorCancelled) {
                isCancelRequest = YES;
            }else{
                [IPCCommonUI showError:@"搜索商品失败,请稍后重试!"];
            }
        }
        if (complete) {
            complete();
        }
    }];
}

#pragma mark //Clicked Events
//Add to shopping cart animation
- (void)addCartAnimationInCell:(IPCGlasslistCollectionViewCell *)cell{
    [self reload];
    CGPoint startPoint  = [cell convertRect:cell.addCartButton.frame toView:self.view.superview].origin;
    CGPoint endPoint   = CGPointMake(self.view.superview.jk_width-100, -30);
    [self startAnimationWithStartPoint:startPoint EndPoint:endPoint];
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
        
        [self.glassListViewMode showFilterCategory:self InView:self.coverView ReloadClose:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf removeCover];
            [strongSelf beginFilterClass];
            [strongSelf.glassListViewMode queryBatchDegree];
        } ReloadUnClose:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf beginFilterClass];
        }];
    }
}

- (void)onSearchProducts{
    [super onSearchProducts];
    
    [self removeCover];
    //Present To Search ViewController
    IPCSearchViewController * searchViewMode = [[IPCSearchViewController alloc]initWithNibName:@"IPCSearchViewController" bundle:nil];
    searchViewMode.searchDelegate = self;
    searchViewMode.filterType = self.glassListViewMode.currentType;
    [searchViewMode showSearchProductViewWithSearchWord:self.glassListViewMode.searchWord];
    [self presentViewController:searchViewMode animated:YES completion:nil];
}


- (IBAction)onGoTopAction:(id)sender {
    [self.goTopButton setHidden:YES];
    [self.glassListCollectionView scrollToTopAnimated:YES];
}

//Reload Glasses CollectionView
- (void)reload{
    [super reload];
    
    self.glassListCollectionView.isBeginLoad = NO;
    [self.glassListCollectionView reloadData];
    [self.glassListViewMode.filterView setCoverStatus:YES];
    [self stopRefresh];
}

//Remover All Cover
- (void)removeCover
{
    [super removeCover];
    
    [self.glassListViewMode.filterView removeFromSuperview];
    [self.coverView removeFromSuperview];
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
    //Preload Glasses Data
    if (self.glassListViewMode.status == IPCFooterRefresh_HasMoreData) {
        if (!self.refreshFooter.isRefreshing) {
            if (indexPath.row == self.glassListViewMode.glassesList.count - (self.glassListViewMode.limit - 10)) {
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
        //Push To Detail ViewController
        IPCGlassDetailsViewController * detailVC = [[IPCGlassDetailsViewController alloc]initWithNibName:@"IPCGlassDetailsViewController" bundle:nil];
        detailVC.glasses  = self.glassListViewMode.glassesList[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)chooseParameter:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.glassListCollectionView indexPathForCell:cell];
        [self showGlassesParameterView:self.glassListViewMode.glassesList[indexPath.row]];
    }
}

- (void)editBatchParameter:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.glassListCollectionView indexPathForCell:cell];
        [self editGlassesParemeterView:self.glassListViewMode.glassesList[indexPath.row]];
    }
}

- (void)reloadProductList:(IPCGlasslistCollectionViewCell *)cell{
    [self reload];
}

#pragma mark //IPCSearchViewControllerDelegate
- (void)didSearchWithKeyword:(NSString *)keyword
{
    self.glassListViewMode.searchWord = keyword;
    [self beginFilterClass];
}

#pragma mark //UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > self.view.jk_height * 2) {
        [self.goTopButton setHidden:NO];
    }else{
        [self.goTopButton setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end