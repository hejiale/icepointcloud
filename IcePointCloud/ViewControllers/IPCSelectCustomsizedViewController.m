//
//  IPCSelectCustomsizedViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/5/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCSelectCustomsizedViewController.h"
#import "IPCCustomsizedGlassesCell.h"
#import "IPCProductViewMode.h"

static NSString * const glassListCellIdentifier = @"GlasslistCollectionViewCellIdentifier";

@interface IPCSelectCustomsizedViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,IPCCustomsizedGlassesCellDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UICollectionView                 *customsizedCollectionView;
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property (strong, nonatomic) IPCProductViewMode                   *glassListViewMode;
@property (nonatomic, strong) IPCRefreshAnimationHeader          *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter           *refreshFooter;

@end

@implementation IPCSelectCustomsizedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setBackground];
    [self setNavigationBarStatus:YES];
    [self.searchBgView addBorder:3 Width:0.5];
    [self.topView addBottomLine];
    
    self.glassListViewMode =  [[IPCProductViewMode alloc]init];
    self.glassListViewMode.isTrying = NO;
    self.glassListViewMode.isCustomsized = YES;
    
    __block CGFloat width = (self.customsizedCollectionView.jk_width - 10)/3;
    __block CGFloat height = (self.customsizedCollectionView.jk_height - 10)/3;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setItemSize:CGSizeMake(width, height)];
    [layout setMinimumLineSpacing:5];
    [layout setMinimumInteritemSpacing:5];
    
    [self.customsizedCollectionView setCollectionViewLayout:layout];
    [self.customsizedCollectionView registerNib:[UINib nibWithNibName:@"IPCCustomsizedGlassesCell" bundle:nil] forCellWithReuseIdentifier:glassListCellIdentifier];
    self.customsizedCollectionView.mj_header = self.refreshHeader;
    self.customsizedCollectionView.mj_footer = self.refreshFooter;
    self.customsizedCollectionView.emptyAlertTitle = @"没有找到符合条件的商品";
    self.customsizedCollectionView.emptyAlertImage = @"exception_search";
    [self.refreshHeader beginRefreshing];
}


#pragma mark //Set UI
- (MJRefreshBackStateFooter *)refreshHeader{
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
    self.glassListViewMode.isBeginLoad = YES;
    self.glassListViewMode.currentPage = 0;
    self.customsizedCollectionView.mj_footer.hidden = NO;
    [self loadNormalProducts];
}

- (void)loadMoreTableView{
    self.glassListViewMode.isBeginLoad = NO;
    self.glassListViewMode.currentPage += 9;
    
    [self loadGlassesListData:^{
        [self.customsizedCollectionView reloadData];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}


#pragma mark //Request Data
- (void)loadNormalProducts{
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
        [strongSelf.customsizedCollectionView reloadData];
        [strongSelf.refreshHeader endRefreshing];
        [strongSelf.refreshFooter endRefreshing];
    });
}

- (void)loadGlassesListData:(void(^)())complete
{
    [self.glassListViewMode reloadGlassListDataWithIsTry:NO IsHot:NO Complete:^(LSRefreshDataStatus status, NSError *error){
        if (status == IPCRefreshError && error) {
            [IPCCustomUI showError:error.domain];
        }else if (status == IPCFooterRefresh_HasNoMoreData){
            self.customsizedCollectionView.mj_footer.hidden = YES;
        }
        if (complete) {
            complete();
        }
    }];
}

#pragma mark //Clicked Events
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)filterProductAction:(id)sender{
    if ([self.glassListViewMode.filterView superview]) {
        [self removeCover];
    }else{
        __weak typeof (self) weakSelf = self;
        [self addBackgroundViewWithAlpha:0.2   InView:self.customsizedCollectionView Complete:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf removeCover];
        }];
        [self.glassListViewMode loadFilterCategory:self InView:self.backGroudView ReloadClose:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf removeCover];
            [strongSelf.refreshHeader beginRefreshing];
        } ReloadUnClose:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.refreshHeader beginRefreshing];
        }];
    }
}

- (void)removeCover
{
    __weak typeof (self) weakSelf = self;
    if ([self.backGroudView superview] && self.glassListViewMode.filterView) {
        [self.glassListViewMode.filterView closeCompletion:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.glassListViewMode.filterView removeFromSuperview];strongSelf.glassListViewMode.filterView = nil;
            [strongSelf.backGroudView removeFromSuperview];
        }];
    }
}

#pragma mark //UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.glassListViewMode.glassesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCCustomsizedGlassesCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:glassListCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    if ([self.glassListViewMode.glassesList count] && self.glassListViewMode){
        IPCGlasses * glasses = self.glassListViewMode.glassesList[indexPath.row];
        cell.glasses = glasses;
    }
    return cell;
}

#pragma mark //IPCCustomsizedGlassesCellDelegate
- (void)confirmSelectGlass:(IPCCustomsizedGlassesCell *)cell{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.glassListViewMode.searchWord = [textField.text jk_trimmingWhitespace];
    [self.refreshHeader beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
