//
//  ViewController.m
//  IcePointCloud
//
//  Created by mac on 7/18/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCTryGlassesViewController.h"
#import "IPCTryGlassesCell.h"
#import "IPCSearchViewController.h"
#import "IPCDefineCameraBaseComponent.h"
#import "IPCPhotoPickerViewController.h"
#import "IPCOnlineFaceDetector.h"
#import "IPCShareManager.h"
#import "IPCShareChatView.h"
#import "IPCSwitch.h"
#import "IPCMatchItem.h"
#import "IPCSingleModeView.h"
#import "IPCCompareItemView.h"
#import "IPCProductViewMode.h"
#import "IPCOfflineFaceDetector.h"
#import "IPCGlassParameterView.h"
#import "IPCEditBatchParameterView.h"
#import "IPCTryGlassesView.h"

static NSString * const glassListCellIdentifier = @"GlasslistCollectionViewCellIdentifier";

@interface IPCTryGlassesViewController ()<UITableViewDelegate,UITableViewDataSource,CompareItemViewDelegate,IPCSearchViewControllerDelegate,IPCTryGlassesCellDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (nonatomic, weak) IBOutlet UIView *matchPanelView;
@property (nonatomic, strong) IBOutlet UIView *modelsPicker;
@property (nonatomic, strong) IBOutlet UIView *photoDeleteConfirmView;
@property (nonatomic, weak) IBOutlet UIButton *photoDeleteBtn;
@property (nonatomic, weak) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIView *topOperationBar;
@property (weak, nonatomic) IBOutlet UIView *compareBgView;
@property (strong, nonatomic)  IPCSingleModeView * signleModeView;
@property (weak, nonatomic) IBOutlet IPCStaticImageTextButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *goTopButton;
@property (weak, nonatomic) IBOutlet IPCStaticImageTextButton *librayButton;
@property (strong, nonatomic) IBOutlet UIView *cameraBgView;
@property (weak, nonatomic) IBOutlet UIView *recommdBgView;
@property (weak, nonatomic) IBOutlet UIScrollView *recommdScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstant;
@property (strong, nonatomic) UIVisualEffectView * blurBgView;
@property (strong, nonatomic)  IPCShareChatView  *shareButtonView;
@property (strong, nonatomic) IPCSwitch *compareSwitch;
@property (strong, nonatomic) IPCGlassParameterView   *parameterView;
@property (strong, nonatomic) IPCEditBatchParameterView  *editParameterView;
@property (nonatomic, strong) IPCRefreshAnimationHeader *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter *refreshFooter;
@property (nonatomic, strong) IPCOnlineFaceDetector *faceRecognition;
@property (strong, nonatomic) IPCProductViewMode  *glassListViewMode;
@property (nonatomic, strong) IPCOfflineFaceDetector  * offlineFaceDetector;
@property (nonatomic, strong) IPCTryGlassesView  *  tryGlassesView;

@end

@implementation IPCTryGlassesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.recommdBgView addLeftLine];
    [self.cameraButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentDown];
    [self.librayButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentDown];
    [self loadSingleModelView];
    [self.matchPanelView bringSubviewToFront:self.topOperationBar];
    [self.topOperationBar addSubview:self.compareSwitch];
    [self loadTableView];
    [self.view addSubview:self.tryGlassesView];
    
    self.glassListViewMode =  [[IPCProductViewMode alloc]init];
    self.glassListViewMode.isTrying = YES;
    [self beginFilterClass];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:YES];
    [self initMatchItems];
    [self reload];
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

#pragma mark //Set UI ----------------------------------------------------------------------------
- (void)loadTableView{
    [self.productTableView setTableHeaderView:[[UIView alloc]init]];
    [self.productTableView setTableFooterView:[[UIView alloc]init]];
    self.productTableView.mj_header = self.refreshHeader;
    self.productTableView.mj_footer = self.refreshFooter;
    self.productTableView.estimatedSectionHeaderHeight = 0;
    self.productTableView.estimatedSectionFooterHeight = 0;
    self.productTableView.emptyAlertImage = @"exception_search";
    self.productTableView.emptyAlertTitle = @"未搜索到可试戴的眼镜!";
}


- (UIVisualEffectView *)blurBgView{
    if (!_blurBgView)
        _blurBgView = [IPCCommonUI showBlurView:[UIApplication sharedApplication].keyWindow.bounds Target:self action:@selector(removeCover)];
    return _blurBgView;
}

//Create Single Model View
- (void)loadSingleModelView{
    self.signleModeView = [IPCSingleModeView jk_loadInstanceFromNibWithName:@"IPCSingleModeView" owner:self];
    [self.signleModeView setFrame:self.matchPanelView.bounds];
    [self.matchPanelView addSubview:self.signleModeView];
    
    __weak typeof(self) weakSelf = self;
    [[self.signleModeView rac_signalForSelector:@selector(deleteModel)] subscribeNext:^(id x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        IPCCompareItemView * compareView = strongSelf.compareBgView.subviews[[IPCTryMatch instance].activeMatchItemIndex];
        [compareView initGlassView];
        [strongSelf updateCurrentGlass];
    }];
}

//Initialize the default try wearing glasses compare mode
- (void)initMatchItems
{
    if ([[IPCTryMatch instance].matchItems count] == 0)
        [[IPCTryMatch instance] initMatchItems];
    
    self.signleModeView.matchItem = [[IPCTryMatch instance] currentMatchItem];
    [self.signleModeView updateModelPhoto];
    [self initCompareModeView];
}


- (void)initCompareModeView
{
    if ([self.compareBgView.subviews count] == 0) {
        __weak typeof (self) weakSelf = self;
        [[IPCTryMatch instance].matchItems enumerateObjectsUsingBlock:^(IPCMatchItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
            item.matchItem = [IPCTryMatch instance].matchItems[idx];
            [item updateModelPhoto];
            [strongSelf.compareBgView addSubview:item];
        }];
    }
}


- (IPCSwitch *)compareSwitch{
    if (!_compareSwitch) {
        _compareSwitch = [[IPCSwitch alloc] initWithFrame:CGRectMake(5, self.topOperationBar.frame.size.height/2-10, 42, 21)];
        [_compareSwitch addTarget:self action:@selector(onSwitchPressed:) forControlEvents:UIControlEventValueChanged];
        [_compareSwitch setTintColor:[UIColor whiteColor]];
        [_compareSwitch setOnTintColor:COLOR_RGB_BLUE];
        [_compareSwitch setThumbTintColor:[UIColor whiteColor]];
    }
    return _compareSwitch;
}

- (IPCRefreshAnimationHeader *)refreshHeader{
    if (!_refreshHeader)
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    return _refreshHeader;
}

- (IPCRefreshAnimationFooter *)refreshFooter{
    if (!_refreshFooter)
        _refreshFooter = [IPCRefreshAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    return _refreshFooter;
}

- (void)updateRecommdUI
{
    if (self.glassListViewMode.recommdGlassesList.count && !self.compareSwitch.isOn) {
        [self.recommdBgView setHidden:NO];
        [self.recommdScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        __block CGFloat width = self.recommdBgView.jk_width/3;
        __block CGFloat height = self.recommdBgView.jk_height;
        
        [self.glassListViewMode.recommdGlassesList enumerateObjectsUsingBlock:^(IPCGlasses * _Nonnull glass, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width*idx, 0, width, height)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            IPCGlassesImage * glassImage = [glass imageWithType:IPCGlassesImageTypeThumb];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[glassImage.imageURL stringByAppendingString:@"-320x160"]]];
            [imageView setUserInteractionEnabled:YES];
            __weak typeof(self) weakSelf = self;
            [imageView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [[IPCTryMatch instance] currentMatchItem].glass = glass;
                [strongSelf reload];
            }];
            [self.recommdScrollView addSubview:imageView];
        }];
        [self.recommdScrollView setContentOffset:CGPointZero];
        [self.recommdScrollView setContentSize:CGSizeMake(self.glassListViewMode.recommdGlassesList.count * width, 0)];
    }else{
        [self.recommdBgView setHidden:YES];
    }
}

- (IPCTryGlassesView *)tryGlassesView
{
    if (!_tryGlassesView) {
        __weak typeof(self) weakSelf = self;
        _tryGlassesView = [[IPCTryGlassesView alloc]initWithFrame:CGRectMake(0, 0, self.productTableView.jk_width, (SCREEN_HEIGHT-70)/4) ChooseParameter:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf editGlassParameterView:[[IPCTryMatch instance] currentMatchItem].glass];
        } EditParameter:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf showGlassesParameterView:[[IPCTryMatch instance] currentMatchItem].glass];
        } AddCart:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            _tryGlassesView.glasses = [[IPCTryMatch instance] currentMatchItem].glass;
        } ReduceCart:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            _tryGlassesView.glasses = [[IPCTryMatch instance] currentMatchItem].glass;
        } TryGlasses:nil];
        [_tryGlassesView addBottomLine];
        [_tryGlassesView setDefaultGlasses];
        [_tryGlassesView setHidden:YES];
    }
    return _tryGlassesView;
}

- (void)updateCurrentGlass{
    if ([[IPCTryMatch instance] currentMatchItem].glass && !self.compareSwitch.isOn)
    {
        self.tryGlassesView.glasses = [[IPCTryMatch instance] currentMatchItem].glass;
        self.tableViewTopConstant.constant = (SCREEN_HEIGHT - 70)/4;
        [self.tryGlassesView setHidden:NO];
    }else{
        self.tableViewTopConstant.constant = 0;
        [self.tryGlassesView setHidden:YES];
        [self.recommdBgView setHidden:YES];
    }
}

- (void)showGlassesParameterView:(IPCGlasses *)glass{
    __weak typeof(self) weakSelf = self;
    self.editParameterView = [[IPCEditBatchParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds Glasses:glass Dismiss:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.editParameterView removeFromSuperview];strongSelf.editParameterView = nil;
        [strongSelf.productTableView reloadData];
        strongSelf.tryGlassesView.glasses = [[IPCTryMatch instance] currentMatchItem].glass;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.editParameterView];
    [self.editParameterView show];
}

- (void)editGlassParameterView:(IPCGlasses *)glass{
    __weak typeof(self) weakSelf = self;
    self.parameterView = [[IPCGlassParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds  Complete:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.productTableView reloadData];
        strongSelf.tryGlassesView.glasses = [[IPCTryMatch instance] currentMatchItem].glass;
    }];
    self.parameterView.glasses = glass;
    [[UIApplication sharedApplication].keyWindow addSubview:self.parameterView];
    [self.parameterView show];
}

#pragma mark //Refresh Methods ----------------------------------------------------------------------------
- (void)beginRefresh
{
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
        [[IPCHttpRequest sharedClient] cancelAllRequest];
    }
    [self.refreshFooter resetDataStatus];
    [self beginReloadTableView];
}


- (void)beginFilterClass
{
    [self.glassListViewMode.glassesList removeAllObjects];
    self.glassListViewMode.glassesList = nil;
    self.productTableView.isBeginLoad = YES;
    [self.productTableView reloadData];
    [self beginReloadTableView];
}

- (void)loadMore
{
    self.glassListViewMode.currentPage += 30;
    
    __weak typeof (self) weakSelf = self;
    [self loadGlassesListData:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf reloadTableView];
    }];
}

- (void)beginReloadTableView
{
    self.glassListViewMode.currentPage = 0;
    [self.glassListViewMode.glassesList removeAllObjects];
    self.glassListViewMode.glassesList = nil;
    
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
        [strongSelf reloadTableView];
    });
}

- (void)reloadTableView
{
    self.productTableView.isBeginLoad = NO;
    [self.productTableView reloadData];
    [self.glassListViewMode.filterView setCoverStatus:YES];
    
    if (self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
    }
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
    }
}

#pragma mark //Request Data
- (void)loadGlassesListData:(void(^)())complete{
    __weak typeof (self) weakSelf = self;
    [self.glassListViewMode reloadGlassListDataWithIsTry:YES Complete:^(){
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf.glassListViewMode.status == IPCFooterRefresh_HasNoMoreData){
            [strongSelf.refreshFooter noticeNoDataStatus];
        }
        if (complete) {
            complete();
        }
    }];
}

- (void)queryRecommdGlasses
{
    if ([[IPCTryMatch instance] currentMatchItem].glass && !self.compareSwitch.isOn) {
        __weak typeof(self) weakSelf = self;
        [self.glassListViewMode queryRecommdGlasses:[[IPCTryMatch instance] currentMatchItem].glass Complete:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf updateRecommdUI];
        }];
    }
}

#pragma mark //Clicked Events ----------------------------------------------------------------------------
//Clean bg cover methods
- (void)removeCover{
    [super removeCover];
    
    [self.shareButtonView removeFromSuperview];
    [self.photoDeleteConfirmView removeFromSuperview];
    [self.modelsPicker removeFromSuperview];
    [self.blurBgView removeFromSuperview];
    [self.glassListViewMode.filterView removeFromSuperview];
    [self.coverView removeFromSuperview];
}

- (IBAction)onGoTopAction:(id)sender {
    [self.goTopButton setHidden:YES];
    [self.productTableView scrollToTopAnimated:YES];
}

//signle show or compare show methods
- (void)onSwitchPressed:(id)sender {
    if ([self.coverView superview])
        [self removeCover];
    
    if (self.compareSwitch.isOn) {
        [self switchToCompareMode];
    }else{
        [self switchToSingleMode];
    }
}

//Choose delete method
- (IBAction)onDeleteBtnTapped:(UIButton *)sender
{
    if ([self.coverView superview]) {
        [self removeCover];
    }else{
        [self addCoverWithAlpha:0 Complete:^{
            [self removeCover];
        }];
        CGFloat x = [self.topOperationBar convertRect:sender.frame toView:self.coverView].origin.x-50;
        [self.photoDeleteConfirmView setFrame:CGRectMake(x, self.topOperationBar.jk_bottom, 135, 70)];
        [self.coverView addSubview:self.photoDeleteConfirmView];
    }
}

//Delete camera image
- (IBAction)onConfirmDeleteBtnTapped:(id)sender
{
    for (IPCMatchItem *mi in [IPCTryMatch instance].matchItems) {
        mi.frontialPhoto = nil;
        mi.photoType = IPCPhotoTypeModel;
    }
    for (IPCCompareItemView *v in self.compareBgView.subviews)
        [v updateModelPhoto];
    
    [self.signleModeView updateModelPhoto];
    self.photoDeleteBtn.enabled = NO;
    [self removeCover];
}

//Choose Model Method
- (IBAction)onModelsBtnTapped:(UIButton *)sender
{
    if ([self.coverView superview]) {
        [self removeCover];
    }else{
        [self addCoverWithAlpha:0 Complete:^{
            [self removeCover];
        }];
        CGFloat x = [self.topOperationBar convertRect:sender.frame toView:self.coverView].origin.x - self.modelsPicker.jk_width + 75;
        self.modelsPicker.layer.anchorPoint = CGPointMake(0.9, 0);
        [self.modelsPicker setFrame:CGRectMake(x, self.topOperationBar.jk_bottom, self.modelsPicker.jk_width, self.modelsPicker.jk_height)];
        self.modelsPicker.alpha = 0;
        self.modelsPicker.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        [self.coverView addSubview:self.modelsPicker];
        
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
    if ([self.coverView superview])[self removeCover];
    
    IPCMatchItem *mi = [IPCTryMatch instance].matchItems[0];
    if (mi.photoType == IPCPhotoTypeModel && mi.modelType == index) return;
    
    for (IPCMatchItem *item in [IPCTryMatch instance].matchItems) {
        item.modelType = sender.tag;
        item.photoType = IPCPhotoTypeModel;
        item.frontialPhoto = nil;
    }
    
    for (IPCCompareItemView *v in self.compareBgView.subviews)
        [v updateModelPhoto];
    
    [self.signleModeView updateModelPhoto];
    self.photoDeleteBtn.enabled = NO;
}

//Share Tryglass Image
- (IBAction)onShareBtnTapped:(UIButton *)sender
{
    [self addCoverWithAlpha:0.2 Complete:^{
        [self removeCover];
    }];
    _shareButtonView = [[IPCShareChatView alloc]initWithFrame:CGRectMake(0, 0, self.coverView.jk_width,80 )
                                                         Chat:^{
                                                             [self onShareToWechat:WXSceneSession];
                                                         } Line:^{
                                                             [self onShareToWechat:WXSceneTimeline];
                                                         } Favorite:^{
                                                             [self onShareToWechat:WXSceneFavorite];
                                                         }];
    [self.coverView addSubview:_shareButtonView];
    [self.coverView bringSubviewToFront:_shareButtonView];
    [_shareButtonView show];
}

- (void)onShareToWechat :(int)scene{
    UIImage * screenImage = [UIImage jk_captureWithView:self.matchPanelView];
    IPCShareManager * manager = [[IPCShareManager alloc]init];
    [manager shareToChat:screenImage Scene:scene];
    [self removeCover];
}

//Shooting head
- (IBAction)onCameraBtnTapped:(id)sender
{
    if ([self.blurBgView superview]) {
        [self removeCover];
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
    [self removeCover];
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
    IPCPortraitNavigationViewController * pickNav = [[IPCPortraitNavigationViewController alloc]initWithRootViewController:pickVC];
    [self presentViewController:pickNav animated:YES completion:nil];
}

//His head shot head modification model refresh glasses
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
                [IPCCommonUI showError:@"人脸验证失败!"];
            }];
        }else{
            [IPCCommonUI showError:@"未检测到人脸轮廓"];
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
    for (IPCMatchItem *mi in [IPCTryMatch instance].matchItems) {
        mi.frontialPhoto = cameraImage;
        mi.photoType = IPCPhotoTypeFrontial;
    }
    for (IPCCompareItemView * item in self.compareBgView.subviews)
        [item updateModelPhoto];
    
    [self.signleModeView updateModelPhoto];
    self.photoDeleteBtn.enabled = YES;
}

//Filter Products \ Search Products
- (void)onFilterProducts{
    [super onFilterProducts];
    
    __weak typeof (self) weakSelf = self;
    if ([self.glassListViewMode.filterView superview]) {
        [self removeCover];
    }else{
        [self addCoverWithAlpha:0.2 Complete:^{
            [self removeCover];
        }];
        [self.glassListViewMode loadFilterCategory:self InView:self.coverView ReloadClose:^{
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
    [self presentSearchViewController];
}

- (void)presentSearchViewController{
    IPCSearchViewController * searchViewMode = [[IPCSearchViewController alloc]initWithNibName:@"IPCSearchViewController" bundle:nil];
    searchViewMode.searchDelegate = self;
    searchViewMode.filterType = self.glassListViewMode.currentType;
    [searchViewMode showSearchProductViewWithSearchWord:self.glassListViewMode.searchWord];
    [self presentViewController:searchViewMode animated:YES completion:nil];
}

//Try switching to wear glasses a single or more patterns
- (void)switchToSingleMode
{
    IPCCompareItemView *targetItemView = self.compareBgView.subviews[[IPCTryMatch instance].activeMatchItemIndex];
    [targetItemView amplificationLargeModelView];
}

- (void)switchToCompareMode
{
    [[IPCHttpRequest sharedClient] cancelAllRequest];
    [self setRecommdStatus:YES];
    
    for (IPCCompareItemView * item in self.compareBgView.subviews) {
        item.transform = CGAffineTransformIdentity;
        item.center = item.originalCenter;
        [item updateItem:NO];
    }
    [self updateCompareBorder];
    
    IPCCompareItemView *targetItemView = self.compareBgView.subviews[[IPCTryMatch instance].activeMatchItemIndex];
    
    CGRect frame = self.signleModeView.frame;
    self.signleModeView.layer.anchorPoint = targetItemView.singleModeViewAnchorPoint;
    self.signleModeView.frame = frame;
    
    [UIView animateWithDuration:.2 delay:0 options:0 animations:^{
        self.signleModeView.transform = CGAffineTransformScale(self.signleModeView.transform, 0.5, 0.5);
    } completion:^(BOOL finished) {
        if (finished) {
            [self.compareBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.alpha = 0;
                obj.hidden = NO;
            }];
            
            [UIView animateWithDuration:0.2f animations:^{
                self.signleModeView.alpha = 0;
                self.signleModeView.hidden = YES;
            }];
            
            [self.compareBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [UIView animateWithDuration:.2 delay:.1 * idx options:0 animations:^{
                    obj.alpha = 1;
                } completion:nil];
            }];
        }
    }];
}

//Reload Table View
- (void)reload{
    [super reload];
    
    [self.productTableView reloadData];
    
    if (self.compareSwitch.isOn) {
        if (self.compareBgView.subviews.count) {
            IPCCompareItemView * itemView = self.compareBgView.subviews[[IPCTryMatch instance].activeMatchItemIndex];
            itemView.matchItem = [[IPCTryMatch instance] currentMatchItem];
        }
    }else{
        [self updateCurrentGlass];
        [self updateTryGlasses];
    }
}

- (void)updateTryGlasses
{
    [self queryRecommdGlasses];
    self.signleModeView.matchItem = [[IPCTryMatch instance] currentMatchItem];
    if (self.compareBgView.subviews.count) {
        IPCCompareItemView * itemView = self.compareBgView.subviews[[IPCTryMatch instance].activeMatchItemIndex];
        itemView.matchItem = [[IPCTryMatch instance] currentMatchItem];
        [itemView updateItem:NO];
    }
}

- (void)setRecommdStatus:(BOOL)status
{
    if (!status && [[IPCTryMatch instance] currentMatchItem].glass) {
        [self reload];
    }else{
        self.tableViewTopConstant.constant = 0;
        [self.recommdBgView setHidden:YES];
        [self.tryGlassesView setHidden:YES];
    }
}

- (void)updateCompareBorder
{
    [self.compareBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[IPCCompareItemView class]]) {
            IPCCompareItemView * item = (IPCCompareItemView *)obj;
            if (item.tag == [IPCTryMatch instance].activeMatchItemIndex) {
                [item addBorder:0 Width:5 Color:COLOR_RGB_BLUE];
            }else{
                [item addBorder:0 Width:0 Color:nil];
            }
        }
    }];
}

#pragma mark //CompareItemViewDelegate
- (void)didAnimateToSingleMode:(IPCCompareItemView *)itemView
{
    [self.compareSwitch setOn:NO];
    self.signleModeView.matchItem = itemView.matchItem;
    [self setRecommdStatus:NO];
}

- (void)deleteCompareGlasses:(IPCCompareItemView *)itemView{
    [self.signleModeView initGlassView];
    [self updateCurrentGlass];
}

- (void)selectCompareIndex:(IPCCompareItemView *)itemView{
    [IPCTryMatch instance].activeMatchItemIndex = itemView.tag;
    [self updateCompareBorder];
}

#pragma mark //UITableViewDataSource ----------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.glassListViewMode.glassesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCTryGlassesCell * cell = [tableView dequeueReusableCellWithIdentifier:glassListCellIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCTryGlassesCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        cell.delegate = self;
    }
    if ([self.glassListViewMode.glassesList count] && self.glassListViewMode){
        IPCGlasses * glass = self.glassListViewMode.glassesList[indexPath.row];
        [cell setGlasses:glass];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.glassListViewMode.status == IPCFooterRefresh_HasMoreData) {
        if (!self.refreshFooter.isRefreshing) {
            if (indexPath.row == self.glassListViewMode.glassesList.count -20) {
                [self.refreshFooter beginRefreshing];
            }
        }
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.jk_height/4;
}

#pragma mark //IPCTryGlassesCellDelegate
- (void)chooseParameter:(IPCTryGlassesCell *)cell
{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.productTableView indexPathForCell:cell];
        [self editGlassParameterView:self.glassListViewMode.glassesList[indexPath.row]];
    }
}

- (void)editBatchParameter:(IPCTryGlassesCell *)cell
{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.productTableView indexPathForCell:cell];
        [self showGlassesParameterView:self.glassListViewMode.glassesList[indexPath.row]];
    }
}

- (void)reloadProductList
{
    [self.productTableView reloadData];
}


- (void)tryGlasses:(IPCTryGlassesCell *)cell
{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.productTableView indexPathForCell:cell];
        [[IPCTryMatch instance] currentMatchItem].glass = self.glassListViewMode.glassesList[indexPath.row];
        [self reload];
    }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.glassListViewMode = nil;
}

@end
