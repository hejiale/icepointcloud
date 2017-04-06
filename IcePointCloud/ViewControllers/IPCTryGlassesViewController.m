//
//  ViewController.m
//  IcePointCloud
//
//  Created by mac on 7/18/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCTryGlassesViewController.h"
#import "IPCGlassDetailsViewController.h"
#import "IPCGlasslistCollectionViewCell.h"
#import "IPCGlassParameterView.h"
#import "IPCDefineCameraBaseComponent.h"
#import "IPCPhotoPickerViewController.h"
#import "IPCOnlineFaceDetector.h"
#import "IPCShareManager.h"
#import "IPCShareChatView.h"
#import "IPCSwitch.h"
#import "IPCMatchItem.h"
#import "IPCSingleModeView.h"
#import "IPCCompareItemView.h"
#import "IPCGlassListViewMode.h"
#import "IPCOfflineFaceDetector.h"

static NSString * const kResuableId = @"GlasslistCollectionViewCellIdentifier";

@interface IPCTryGlassesViewController ()<CompareItemViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,GlasslistCollectionViewCellDelegate,OBOvumSource,OBDropZone,UIScrollViewDelegate>
{
    NSInteger    activeMatchItemIndex;
}

@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (nonatomic, weak) IBOutlet UIView *matchPanelView;
@property (nonatomic, strong) IBOutlet UIView *modelsPicker;
@property (nonatomic, strong) IBOutlet UIView *photoDeleteConfirmView;
@property (nonatomic, weak) IBOutlet UIButton *photoDeleteBtn;
@property (nonatomic, weak) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIView *topOperationBar;
@property (weak, nonatomic) IBOutlet UIView *compareBgView;
@property (strong, nonatomic)  IPCSingleModeView * signleModeView;
@property (strong, nonatomic) IBOutlet UIView *sortProductView;
@property (weak, nonatomic) IBOutlet UIButton *recommendedButton;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBottomConstraint;
@property (weak, nonatomic) IBOutlet IPCStaticImageTextButton *cameraButton;
@property (weak, nonatomic) IBOutlet IPCStaticImageTextButton *librayButton;
@property (strong, nonatomic) IBOutlet UIView *cameraBgView;
@property (weak, nonatomic) IBOutlet UIButton *toTopButton;
@property (strong, nonatomic) UIVisualEffectView * blurBgView;
@property (strong, nonatomic)  IPCShareChatView  *shareButtonView;
@property (strong, nonatomic) IPCGlassParameterView  *parameterView;
@property (strong, nonatomic) IPCSwitch *compareSwitch;
@property (nonatomic, strong) IPCRefreshAnimationHeader *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter *refreshFooter;
@property (nonatomic, strong) IPCOnlineFaceDetector *faceRecognition;
@property (strong, nonatomic) IPCGlassListViewMode  *glassListViewMode;
@property (nonatomic, strong) NSMutableArray<IPCMatchItem *> *matchItems;
@property (nonatomic, strong) IPCOfflineFaceDetector  * offlineFaceDetector;

@end

@implementation IPCTryGlassesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.glassListViewMode =  [[IPCGlassListViewMode alloc]init];
    self.glassListViewMode.isTrying = YES;
    
    [self.recommendedButton setTitleColor:COLOR_RGB_BLUE forState:UIControlStateSelected];
    [self.sellButton setTitleColor:COLOR_RGB_BLUE forState:UIControlStateSelected];
    [self.bottomImageView setBackgroundColor:COLOR_RGB_BLUE];
    [self.cameraButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentDown];
    [self.librayButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentDown];
    self.matchPanelView.dropZoneHandler = self;
    
    self.signleModeView = [IPCSingleModeView jk_loadInstanceFromNibWithName:@"IPCSingleModeView" owner:self];
    [self.signleModeView setFrame:self.matchPanelView.bounds];
    [self.matchPanelView addSubview:self.signleModeView];
    
    [[self.signleModeView rac_signalForSelector:@selector(scaleAction:)]subscribeNext:^(id x) {
        [self.compareSwitch setOn:YES];
        [self switchToCompareMode];
    }];
    [[self.signleModeView rac_signalForSelector:@selector(deleteModel)] subscribeNext:^(id x) {
        IPCCompareItemView * compareView = self.compareBgView.subviews[activeMatchItemIndex];
        [compareView initGlassView];
    }];
    
    self.leftBottomConstraint.constant = self.sortProductView.jk_width/2 + 15;
    [self.matchPanelView bringSubviewToFront:self.topOperationBar];
    [self.topOperationBar addSubview:self.compareSwitch];
    
    CGFloat height = (self.view.jk_height - 15 - self.sortProductView.jk_height)/3;
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(self.productCollectionView.jk_width, height);
    layOut.minimumInteritemSpacing = 0;
    layOut.minimumLineSpacing = 5;
    
    [self.productCollectionView setCollectionViewLayout:layOut];
    [self.productCollectionView registerNib:[UINib nibWithNibName:@"IPCGlasslistCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kResuableId];
    self.productCollectionView.mj_header = self.refreshHeader;
    self.productCollectionView.mj_footer = self.refreshFooter;
    self.productCollectionView.emptyAlertImage = @"exception_search";
    self.productCollectionView.emptyAlertTitle = @"没有找到可试戴的眼镜!";
    [self.refreshHeader beginRefreshing];
    
    if ([IPCCustomUI rootViewcontroller]) {
        IPCTabBarViewController * rootVC = (IPCTabBarViewController *)[IPCCustomUI rootViewcontroller];
        [[rootVC rac_signalForSelector:@selector(searchProductAction)] subscribeNext:^(id x) {
            [self removeAllPopView];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IPCHttpRequest sharedClient] cancelAllRequest];
    [self.productCollectionView reloadData];
    if ([self.matchItems count] == 0 || [self.compareBgView.subviews count] == 0)[self initMatchItems];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeAllPopView];
}


- (NSMutableArray<IPCMatchItem *> *)matchItems{
    if (!_matchItems)
        _matchItems = [[NSMutableArray alloc]init];
    return _matchItems;
}


#pragma mark //Initialize the default try wearing glasses compare mode
- (void)initMatchItems
{
    for (NSInteger i = 0; i < 4; i++) {
        IPCMatchItem *mi = [[IPCMatchItem alloc]init];
        mi.modelType = IPCModelTypeGirlWithLongHair;//current model
        [self.matchItems addObject:mi];
    }
    activeMatchItemIndex = 0;
    self.signleModeView.matchItem = self.matchItems[activeMatchItemIndex];
    [self.signleModeView updateModelPhoto];
    [self initCompareModeView];
}


- (void)initCompareModeView
{
    [self.compareBgView removeAllSubviews];
    
    if ([self.compareBgView.subviews count] == 0) {
        __weak typeof (self) weakSelf = self;
        [self.matchItems enumerateObjectsUsingBlock:^(IPCMatchItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            IPCCompareItemView *item = [UIView jk_loadInstanceFromNibWithName:@"IPCCompareItemView" owner:strongSelf];
            CGRect frame = item.frame;
            if (idx == 1 || idx == 3) frame.origin.x = frame.size.width;
            if (idx == 2 || idx == 3) frame.origin.y = frame.size.height;
            item.frame  = frame;
            item.origin = frame.origin;
            item.originalCenter = item.center;
            item.parentSingleModeView = strongSelf.signleModeView;
            item.tag = idx;
            item.delegate = strongSelf;
            item.matchItem = strongSelf.matchItems[idx];
            [item updateModelPhoto];
            [strongSelf.compareBgView addSubview:item];
        }];
    }
}

#pragma mark //Set UI ----------------------------------------------------------------------------
- (UIVisualEffectView *)blurBgView{
    if (!_blurBgView)
        _blurBgView = [IPCCustomUI showBlurView:[UIApplication sharedApplication].keyWindow.bounds Target:self action:@selector(removeAllPopView)];
    return _blurBgView;
}

- (IPCSwitch *)compareSwitch{
    if (!_compareSwitch) {
        _compareSwitch = [[IPCSwitch alloc] initWithFrame:CGRectMake(55, self.topOperationBar.frame.size.height/2-10, 50, 20)];
        [_compareSwitch addTarget:self action:@selector(switchPressed:) forControlEvents:UIControlEventValueChanged];
        [_compareSwitch setTintColor:[UIColor darkGrayColor]];
        [_compareSwitch setOnTintColor:[UIColor darkGrayColor]];
        [_compareSwitch setThumbTintColor:[UIColor whiteColor]];
    }
    return _compareSwitch;
}

- (IPCRefreshAnimationHeader *)refreshHeader{
    if (!_refreshHeader)
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginReloadTableView)];
    return _refreshHeader;
}

- (IPCRefreshAnimationFooter *)refreshFooter{
    if (!_refreshFooter)
        _refreshFooter = [IPCRefreshAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTableView)];
    return _refreshFooter;
}

#pragma mark //Refresh Methods ----------------------------------------------------------------------------
- (void)beginReloadTableView{
    self.glassListViewMode.currentPage = 0;
    self.productCollectionView.mj_footer.hidden = NO;
    [IPCCustomUI show];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self loadGlassesListData:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self.glassListViewMode filterGlassCategoryWithFilterSuccess:^(NSError *error) {
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.productCollectionView reloadData];
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            [IPCCustomUI hiden];
        });
    });
}

- (void)loadMoreTableView{
    self.glassListViewMode.currentPage++;
    [self loadGlassesListData:^{
        [self.productCollectionView reloadData];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}

#pragma mark //Load Data
- (void)loadGlassesListData:(void(^)())complete{
    __weak typeof (self) weakSelf = self;
    [self.glassListViewMode reloadGlassListDataWithComplete:^(LSRefreshDataStatus status, NSError *error){
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (error && status == IPCRefreshError){
            if (error.code != NSURLErrorNotConnectedToInternet) {
                [IPCCustomUI showError:error.domain];
            }
        }else if (status == IPCFooterRefresh_HasNoMoreData){
            strongSelf.productCollectionView.mj_footer.hidden = YES;
        }
        if (complete) {
            complete();
        }
    }];
}

#pragma mark //NSNotification Methods ----------------------------------------------------------------------------
- (void)filterProductAction:(id)sender {
    if (self.recommendedButton.selected)return;
    
    __weak typeof (self) weakSelf = self;
    if ([self.glassListViewMode.filterView superview]) {
        [self removeAllPopView];
    }else{
        [self addBackgroundViewWithAlpha:0.2 Complete:^{
            [self removeAllPopView];
        }];
        [self.glassListViewMode loadFilterCategory:self InView:self.backGroudView ReloadClose:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf removeAllPopView];
            [strongSelf.refreshHeader beginRefreshing];
        } ReloadUnClose:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.refreshHeader beginRefreshing];
        }];
    }
}

- (void)searchProductAction:(NSNotification *)notification{
    [self removeAllPopView];
    if (self.recommendedButton.selected){
        [IPCCustomUI showError:@"暂无可查询的热门推荐商品"];
        return;
    }
    self.glassListViewMode.searchWord = notification.userInfo[IPCSearchKeyWord];
    [self.refreshHeader beginRefreshing];
}

#pragma mark //Clicked Events ----------------------------------------------------------------------------
//Choose recommend or sales methods
- (IBAction)onChooseRecommendedAction:(id)sender {
    [self.sellButton setSelected:NO];
    [self.recommendedButton setSelected:YES];
    self.leftBottomConstraint.constant = 15;
    [self.glassListViewMode.glassesList removeAllObjects];
    [self.productCollectionView reloadData];
}


- (IBAction)onChooseSelledAction:(id)sender {
    [self.sellButton setSelected:YES];
    [self.recommendedButton setSelected:NO];
    self.leftBottomConstraint.constant = self.sellButton.jk_width + 15;
    [self.refreshHeader beginRefreshing];
}

//Clean bg cover methods
- (void)removeAllPopView{
    [self.shareButtonView removeFromSuperview];
    [self.photoDeleteConfirmView removeFromSuperview];
    [self.modelsPicker removeFromSuperview];
    [self.backGroudView removeFromSuperview];
    [self.blurBgView removeFromSuperview];
    [self.glassListViewMode.filterView removeFromSuperview];
}

//Add a shopping cart animation
- (void)addCartAnimationInCell:(IPCGlasslistCollectionViewCell *)cell{
    [self.productCollectionView reloadData];
    CGPoint startPoint = [cell convertRect:cell.addCartButton.frame toView:self.view.superview].origin;
    CGPoint endPoint = CGPointMake(self.view.superview.jk_width-85, -30);
    [self startAnimationWithStartPoint:startPoint EndPoint:endPoint];
}


//signle show or compare show methods
- (void)switchPressed:(id)sender {
    if ([self.backGroudView superview])
        [self removeAllPopView];
    
    if (self.compareSwitch.isOn) {
        [self switchToCompareMode];
    }else{
        [self switchToSingleMode];
    }
}

//Choose delete method
- (IBAction)onDeleteBtnTapped:(UIButton *)sender
{
    if ([self.backGroudView superview]) {
        [self removeAllPopView];
    }else{
        [self addBackgroundViewWithAlpha:0 Complete:^{
            [self removeAllPopView];
        }];
        CGFloat x = [self.topOperationBar convertRect:sender.frame toView:self.backGroudView].origin.x-50;
        [self.photoDeleteConfirmView setFrame:CGRectMake(x, self.topOperationBar.jk_bottom, 135, 70)];
        [self.backGroudView addSubview:self.photoDeleteConfirmView];
    }
}

//Delete camera image
- (IBAction)onConfirmDeleteBtnTapped:(id)sender
{
    for (IPCMatchItem *mi in self.matchItems) {
        mi.frontialPhoto = nil;
        mi.photoType = IPCPhotoTypeModel;
    }
    for (IPCCompareItemView *v in self.compareBgView.subviews)
        [v updateModelPhoto];
    
    [self.signleModeView updateModelPhoto];
    self.photoDeleteBtn.enabled = NO;
    [self removeAllPopView];
}

//Choose Model Method
- (IBAction)onModelsBtnTapped:(UIButton *)sender
{
    if ([self.backGroudView superview]) {
        [self removeAllPopView];
    }else{
        [self addBackgroundViewWithAlpha:0 Complete:^{
            [self removeAllPopView];
        }];
        CGFloat x = [self.topOperationBar convertRect:sender.frame toView:self.backGroudView].origin.x - self.modelsPicker.jk_width + 75;
        self.modelsPicker.layer.anchorPoint = CGPointMake(0.9, 0);
        [self.modelsPicker setFrame:CGRectMake(x, self.topOperationBar.jk_bottom, self.modelsPicker.jk_width, self.modelsPicker.jk_height)];
        self.modelsPicker.alpha = 0;
        self.modelsPicker.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        [self.backGroudView addSubview:self.modelsPicker];
        
        [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.modelsPicker.alpha = 1.f;
            self.modelsPicker.transform = CGAffineTransformMakeScale(1.f, 1.f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.modelsPicker.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    }
}

//Click model head image
- (IBAction)onModelPhotoTapped:(UIButton *)sender
{
    if ([self.backGroudView superview])[self removeAllPopView];
    
    IPCMatchItem *mi = self.matchItems[0];
    if (mi.photoType == IPCPhotoTypeModel && mi.modelType == index) return;
    
    for (IPCMatchItem *item in self.matchItems) {
        item.modelType = sender.tag;
        item.photoType = IPCPhotoTypeModel;
        item.frontialPhoto = nil;
    }
    
    for (IPCCompareItemView *v in self.compareBgView.subviews)
        [v updateModelPhoto];
    
    [self.signleModeView updateModelPhoto];
    self.photoDeleteBtn.enabled = NO;
}


- (IBAction)goToTopAction:(id)sender {
    [self.productCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

//Share Tryglass Image
- (IBAction)onShareBtnTapped:(UIButton *)sender
{
    [self addBackgroundViewWithAlpha:0.2 Complete:^{
        [self removeAllPopView];
    }];
    _shareButtonView = [[IPCShareChatView alloc]initWithFrame:CGRectMake(0, 0, self.backGroudView.jk_width,80 )
                                                         Chat:^{
                                                             [self shareToWechat:WXSceneSession];
                                                         } Line:^{
                                                             [self shareToWechat:WXSceneTimeline];
                                                         } Favorite:^{
                                                             [self shareToWechat:WXSceneFavorite];
                                                         }];
    [self.backGroudView addSubview:_shareButtonView];
    [self.backGroudView bringSubviewToFront:_shareButtonView];
    [_shareButtonView show];
}

- (void)shareToWechat :(int)scene{
    UIImage * screenImage = [UIImage jk_captureWithView:self.matchPanelView];
    IPCShareManager * manager = [[IPCShareManager alloc]init];
    [manager shareToChat:screenImage Scene:scene];
    [self removeAllPopView];
}

//Shooting head
- (IBAction)onCameraBtnTapped:(id)sender
{
    if ([self.blurBgView superview]) {
        [self removeAllPopView];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.blurBgView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.blurBgView];
        [self.cameraBgView setFrame:self.blurBgView.bounds];
        [self.blurBgView addSubview:self.cameraBgView];
    }
}

//Camera method
- (IBAction)onPickerFrontalBtnTapped:(id)sender
{
    [self removeAllPopView];
    __weak typeof (self) weakSelf = self;
    IPCDefineCameraBaseComponent * baseComponent = [[IPCDefineCameraBaseComponent alloc]initWithResultImage:^(UIImage *image) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf outPutCameraImage:image];
    }];
    [baseComponent showSampleWithController:self];
}

//Library method
- (IBAction)onPickerLibBtnTapped:(id)sender
{
    [self.blurBgView removeFromSuperview];
    __weak typeof (self) weakSelf = self;
    IPCPhotoPickerViewController * pickVC = [[IPCPhotoPickerViewController alloc]initWithCompleteImage:^(UIImage *image) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf outPutCameraImage:image];
    }];
    IPCNavigationViewController * pickNav = [[IPCNavigationViewController alloc]initWithRootViewController:pickVC];
    [self presentViewController:pickNav animated:YES completion:nil];
}

#pragma mark //His head shot head modification model refresh glasses
- (void)outPutCameraImage:(UIImage *)image
{
    __weak typeof (self) weakSelf = self;
    //A network under the condition of priority calls online face recognition, if network error or request wrong call the offline face recognition
    self.offlineFaceDetector = [[IPCOfflineFaceDetector alloc]init];
    //Face recognition eye position
    self.faceRecognition = [[IPCOnlineFaceDetector alloc]initWithFaceFrame:^(CGPoint position, CGSize size) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf updateModelFace:position Size:size];
    } Error:^(IFlySpeechError *error) {
        if (error) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.offlineFaceDetector offLineDecectorFace:image Face:^(CGRect rect) {
                [strongSelf updateModelFace:rect.origin Size:rect.size];
            } ErrorBlock:^(NSError *error) {
                [IPCCustomUI showError:error.domain];
            }];
        }else{
            [IPCCustomUI showError:@"未检测到人脸轮廓"];
        }
    }];
    [self.faceRecognition postFaceRequest:image];
    [self changeCameraImage:image];
}

- (void)updateModelFace:(CGPoint)position Size:(CGSize)size
{
    [self.signleModeView updateFaceUI:position :size];
    for (IPCCompareItemView * item in self.compareBgView.subviews)
        [item updateFaceUI:position :size];
}

//Modify the model photos
- (void)changeCameraImage:(UIImage *)cameraImage
{
    for (IPCMatchItem *mi in self.matchItems) {
        mi.frontialPhoto = cameraImage;
        mi.photoType = IPCPhotoTypeFrontial;
    }
    for (IPCCompareItemView * item in self.compareBgView.subviews)
        [item updateModelPhoto];
    
    [self.signleModeView updateModelPhoto];
    self.photoDeleteBtn.enabled = YES;
}

#pragma mark //Try switching to wear glasses a single or more patterns
- (void)switchToSingleMode
{
    IPCCompareItemView *targetItemView = self.compareBgView.subviews[activeMatchItemIndex];
    [targetItemView amplificationLargeModelView];
}

- (void)switchToCompareMode
{
    [self initCompareModeView];
    
    IPCCompareItemView *targetItemView = self.compareBgView.subviews[activeMatchItemIndex];
    
    CGRect frame = targetItemView.frame;
    targetItemView.layer.anchorPoint = targetItemView.singleModeViewAnchorPoint;
    targetItemView.frame = frame;
    
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        targetItemView.transform = CGAffineTransformScale(targetItemView.transform, 1, 1);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.compareBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.alpha = 0;
                obj.hidden = NO;
            }];
            
            [self.compareBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [UIView animateWithDuration:.2 delay:.1 * idx options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    obj.alpha = 1;
                } completion:^(BOOL finished) {
                    if (finished) {
                        self.signleModeView.hidden = YES;
                    }
                }];
            }];
        }
    }];
}


#pragma mark //CompareItemViewDelegate
- (void)didAnimateToSingleMode:(IPCCompareItemView *)itemView withIndex:(NSInteger)index
{
    activeMatchItemIndex = index;
    [self.compareSwitch setOn:NO];
    self.signleModeView.matchItem = itemView.matchItem;
}

- (void)deleteCompareGlasses:(IPCCompareItemView *)itemView{
    [self.signleModeView initGlassView];
}


#pragma mark //UICollectionViewDataSource ----------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.glassListViewMode.glassesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IPCGlasslistCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kResuableId forIndexPath:indexPath];
    cell.delegate = self;
    
    if ([self.glassListViewMode.glassesList count] && self.glassListViewMode){
        IPCGlasses * glass = self.glassListViewMode.glassesList[indexPath.row];
        cell.isTrying = self.glassListViewMode.isTrying;
        [cell setGlasses:glass];
        
        if (glass) {
            OBDragDropManager *dragDropManager = [OBDragDropManager sharedManager];
            UILongPressGestureRecognizer *dragDropRecognizer = [dragDropManager createLongPressDragDropGestureRecognizerWithSource:self];
            [cell addGestureRecognizer:dragDropRecognizer];
        }
    }
    return cell;
}

#pragma mark //UICollectionViewCellDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}


#pragma mark //GlasslistCollectionViewCellDelegate
- (void)addShoppingCartAnimation:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0)
        [self addCartAnimationInCell:cell];
}


- (void)showProductDetail:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.productCollectionView indexPathForCell:cell];
        IPCGlassDetailsViewController * detailVC = [[IPCGlassDetailsViewController alloc] initWithNibName:@"IPCGlassDetailsViewController" bundle:nil];
        detailVC.glasses  = self.glassListViewMode.glassesList[indexPath.row];
        [[detailVC rac_signalForSelector:@selector(pushToCartAction:)] subscribeNext:^(id x) {
            [IPCCustomUI pushToRootIndex:4];
            [detailVC.navigationController popToRootViewControllerAnimated:NO];
        }];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)chooseParameter:(IPCGlasslistCollectionViewCell *)cell{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.productCollectionView indexPathForCell:cell];
        self.parameterView = [[IPCGlassParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds Complete:^{
            [self.productCollectionView reloadData];
        }];
        self.parameterView.glasses = self.glassListViewMode.glassesList[indexPath.row];
        [[UIApplication sharedApplication].keyWindow addSubview:self.parameterView];
        [self.parameterView show];
    }
}

- (void)reloadProductList{
    [self.productCollectionView reloadData];
}

#pragma mark - OBOvumSource ----------------------------------------------------------------------------
-(OBOvum *)createOvumFromView:(UIView*)sourceView
{
    if ([self.glassListViewMode.glassesList count] > 0) {
        UIView *cell = [self nearestAncestorForView:sourceView withClass:[UICollectionViewCell class]];
        NSIndexPath *indexPath = [self.productCollectionView indexPathForCell:(UICollectionViewCell *)cell];
        IPCGlasses *glass = self.glassListViewMode.glassesList[indexPath.row];
        OBOvum *ovum = [[OBOvum alloc] init];
        if (glass)ovum.dataObject = glass;
        return ovum;
    }
    return nil;
}

- (UIView *)createDragRepresentationOfSourceView:(UIView *)sourceView inWindow:(UIWindow*)window
{
    if ([self.glassListViewMode.glassesList count] > 0) {
        UIView *cell = [self nearestAncestorForView:sourceView withClass:[UICollectionViewCell class]];
        if (cell) {
            NSIndexPath *indexPath = [self.productCollectionView indexPathForCell:(UICollectionViewCell *)cell];
            IPCGlasses *glass = self.glassListViewMode.glassesList[indexPath.row];
            CGRect frame = [sourceView convertRect:sourceView.bounds toView:sourceView.window];
            frame = [window convertRect:frame fromWindow:sourceView.window];
            if (glass) {
                IPCGlassesImage *gp = [glass imageWithType:IPCGlassesImageTypeFrontialNormal];
                UIImageView *glassImgView = [[UIImageView alloc] init];
                glassImgView.contentMode = UIViewContentModeScaleAspectFit;
                [glassImgView setImageWithURL:[NSURL URLWithString:gp.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
                glassImgView.frame = CGRectMake(frame.origin.x, frame.origin.y, sourceView.frame.size.width*0.9, sourceView.frame.size.height*0.9);
                return glassImgView;
            }
            return nil;
        }
    }
    return nil;
}

- (void) dragViewWillAppear:(UIView *)dragView inWindow:(UIWindow*)window atLocation:(CGPoint)location
{
    dragView.transform = CGAffineTransformIdentity;
    dragView.alpha = 0.0;
    
    [UIView animateWithDuration:0.25 animations:^{
        dragView.center = location;
        dragView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        dragView.alpha = 0.85;
    }];
}


- (UIView *)nearestAncestorForView:(UIView *)aView withClass:(Class)aClass
{
    UIView *parent = aView;
    while (parent) {
        if ([parent isKindOfClass:aClass]) return parent;
        parent = parent.superview;
    }
    return nil;
}

#pragma mark - OBDropZone
- (void)ovumExited:(OBOvum *)ovum inView:(UIView *)view atLocation:(CGPoint)location{
}

- (OBDropAction)ovumEntered:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location{
    return OBDropActionMove;
}

- (OBDropAction)ovumMoved:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location{
    return OBDropActionMove;
}

- (void)ovumDropped:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
    if (ovum) {
        IPCGlasses * glass = (IPCGlasses *)ovum.dataObject;
        if (glass) {
            if (!self.compareSwitch.isOn) {
                [self.signleModeView dropGlasses:glass onLocaton:location];
            }else{
                [self.signleModeView initGlassView];
                
                UIView *target = [self.compareBgView hitTest:location withEvent:nil];
                target = [self nearestAncestorForView:target withClass:[IPCCompareItemView class]];
                if (target && [target isKindOfClass:[IPCCompareItemView class]]) {
                    IPCCompareItemView * itemView = (IPCCompareItemView *)target;
                    location = [self.compareBgView convertPoint:location toView:itemView];
                    [itemView dropGlasses:glass onLocaton:location];
                }
            }
        }
    }
}


#pragma mark //UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 3*self.view.jk_height) {
        [self.toTopButton setHidden:NO];
    }else{
        [self.toTopButton setHidden:YES];
    }
}

#pragma mark //Adding/removing notice ----------------------------------------------------------------------------
- (void)addTryNotifications{
    [self clearNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchProductAction:) name:IPCTrySearchProductNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterProductAction:) name:IPCTryFilterProductNotification object:nil];
}

- (void)clearNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCTrySearchProductNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCTryFilterProductNotification object:nil];
}

- (void)reload{
    [self.productCollectionView reloadData];
}

- (void)rootRefresh{
    [self.glassListViewMode.filterValue clear];
    self.glassListViewMode.currentType = IPCTopFIlterTypeFrames;
    [self.refreshHeader beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
