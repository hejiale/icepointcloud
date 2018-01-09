//
//  ViewController.m
//  IcePointCloud
//
//  Created by mac on 7/18/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCTryGlassesViewController.h"
#import "IPCTryGlassesListViewCell.h"
#import "IPCSearchGlassesViewController.h"
#import "IPCDefineCameraBaseComponent.h"
#import "IPCPhotoPickerBaseComponent.h"
#import "IPCSingleModeView.h"
#import "IPCCompareItemView.h"
#import "IPCOfflineFaceDetector.h"
#import "IPCCurrentTryGlassesView.h"
#import "IPCOnlineFaceDetector.h"
#import "IPCShareManager.h"
#import "IPCShareChatView.h"
#import "IPCMatchItem.h"
#import "IPCSwitch.h"

static NSString * const glassListCellIdentifier = @"IPCTryGlassesListViewCellIdentifier";

@interface IPCTryGlassesViewController ()<UITableViewDelegate,UITableViewDataSource,CompareItemViewDelegate,IPCSearchViewDelegate,IPCTryGlassesCellDelegate,UIScrollViewDelegate>

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
@property (strong, nonatomic)  IPCShareChatView  *shareButtonView;
@property (strong, nonatomic) IPCSwitch *compareSwitch;
@property (nonatomic, strong) IPCOnlineFaceDetector *faceRecognition;
@property (nonatomic, strong) IPCOfflineFaceDetector  * offlineFaceDetector;
@property (nonatomic, strong) IPCCurrentTryGlassesView  *  tryGlassesView;

@end

@implementation IPCTryGlassesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Set UI
    [self.recommdBgView addLeftLine];
    [self.cameraButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentDown];
    [self.librayButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentDown];
    [self loadSingleModelView];
    [self.matchPanelView bringSubviewToFront:self.topOperationBar];
    [self.topOperationBar addSubview:self.compareSwitch];
    [self loadTableView];
    [self.view addSubview:self.tryGlassesView];
    //Init View Model
    self.glassListViewMode =  [[IPCProductViewMode alloc]init];
    self.glassListViewMode.isTrying = YES;
    //Load Data
    [self beginFilterClass];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginFilterClass) name:IPCChooseWareHouseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginFilterClass) name:IPCChoosePriceStrategyNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initMatchItems];
    //According To NetWorkStatus To Reload Products
    if (self.isCancelRequest && self.glassListViewMode.currentPage == 0) {
        [self beginFilterClass];
    }else{
        [self reload];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self removeCover];
    [self stopRefresh];
}


//Initialize the default try wearing glasses compare mode
- (void)initMatchItems
{
    if ([[IPCTryMatch instance].matchItems count] == 0)
        [[IPCTryMatch instance] initMatchItems];
    
    self.signleModeView.matchItem = [[IPCTryMatch instance] currentMatchItem];
    [self.signleModeView updateModelPhoto];
    //获取模特眼镜位置
    if ([self loadCompareModeViews]) {
        [self updateModelPhototPosition];
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

//Create Single Model View
- (void)loadSingleModelView{
    self.signleModeView = [IPCSingleModeView jk_loadInstanceFromNibWithName:@"IPCSingleModeView" owner:self];
    [self.signleModeView setFrame:self.matchPanelView.bounds];
    [self.matchPanelView addSubview:self.signleModeView];
    
    [[self.signleModeView rac_signalForSelector:@selector(deleteModel)] subscribeNext:^(id x) {
        IPCCompareItemView * compareView = self.compareBgView.subviews[[IPCTryMatch instance].activeMatchItemIndex];
        [compareView resetGlassView];
        [self updateCurrentGlass];
    }];
}

- (BOOL)loadCompareModeViews
{
    if ([self.compareBgView.subviews count] == 0) {
        __weak typeof (self) weakSelf = self;
        [[IPCTryMatch instance].matchItems enumerateObjectsUsingBlock:^(IPCMatchItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            IPCCompareItemView *item = [UIView jk_loadInstanceFromNibWithName:@"IPCCompareItemView" owner:self];
            CGRect frame = item.frame;
            if (idx == 1 || idx == 3) frame.origin.x = frame.size.width;
            if (idx == 2 || idx == 3) frame.origin.y = frame.size.height;
            item.frame  = frame;
            item.originalCenter = item.center;
            item.parentSingleModeView = strongSelf.signleModeView;
            item.tag = idx;
            item.delegate = self;
            item.matchItem = [IPCTryMatch instance].matchItems[idx];
            [item updateModelPhoto];
            [self.compareBgView addSubview:item];
        }];
        return YES;
    }
    return NO;
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

- (void)updateRecommdUI
{
    if (self.glassListViewMode.recommdGlassesList.count && !self.compareSwitch.isOn) {
        [self.recommdBgView setHidden:NO];
        [self.recommdScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        __block CGFloat width = (self.recommdBgView.jk_width-20)/3;
        __block CGFloat height = self.recommdBgView.jk_height;
        
        [self.glassListViewMode.recommdGlassesList enumerateObjectsUsingBlock:^(IPCGlasses * _Nonnull glass, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((width+5)*idx+5, 0, width, height)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            IPCGlassesImage * glassImage = [glass imageWithType:IPCGlassesImageTypeThumb];
            [imageView setImageWithURL:[NSURL URLWithString:glassImage.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];
            [imageView setUserInteractionEnabled:YES];

            [imageView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                [[IPCTryMatch instance] currentMatchItem].glass = glass;
                [self reload];
            }];
            [self.recommdScrollView addSubview:imageView];
        }];
        [self.recommdScrollView setContentOffset:CGPointZero];
        [self.recommdScrollView setContentSize:CGSizeMake(self.glassListViewMode.recommdGlassesList.count * (width+5), 0)];
    }else{
        [self.recommdBgView setHidden:YES];
    }
}

- (IPCCurrentTryGlassesView *)tryGlassesView
{
    if (!_tryGlassesView) {
        _tryGlassesView = [[IPCCurrentTryGlassesView alloc]initWithFrame:CGRectMake(0, 0, self.productTableView.jk_width, (SCREEN_HEIGHT-70)/4)
                                                         ChooseParameter:^{
                                                             [self showGlassesParameterView:[[IPCTryMatch instance] currentMatchItem].glass];
                                                         } EditParameter:^{
                                                             [self editGlassParameterView:[[IPCTryMatch instance] currentMatchItem].glass];
                                                         } Reload:^{
                                                             [_tryGlassesView reload];
                                                             [self.productTableView reloadData];
                                                         }];
        [_tryGlassesView setHidden:YES];
        [_tryGlassesView setDefaultGlasses];
    }
    return _tryGlassesView;
}

- (void)editGlassParameterView:(IPCGlasses *)glass{
    __weak typeof(self) weakSelf = self;
    self.editParameterView = [[IPCEditBatchParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds Glasses:glass Dismiss:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [self.productTableView reloadData];
        [strongSelf.tryGlassesView reload];;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.editParameterView];
    [self.editParameterView show];
}

- (void)showGlassesParameterView:(IPCGlasses *)glass{
    __weak typeof(self) weakSelf = self;
    self.parameterView = [[IPCGlassParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds  Complete:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [self.productTableView reloadData];
        [strongSelf.tryGlassesView reload];;
    }];
    self.parameterView.glasses = glass;
    [[UIApplication sharedApplication].keyWindow addSubview:self.parameterView];
    [self.parameterView show];
}

- (void)presentSearchViewController{
    IPCSearchGlassesViewController * searchViewMode = [[IPCSearchGlassesViewController alloc]initWithNibName:@"IPCSearchGlassesViewController" bundle:nil];
    searchViewMode.searchDelegate = self;
    searchViewMode.filterType = self.glassListViewMode.currentType;
    [searchViewMode showSearchProductViewWithSearchWord:self.glassListViewMode.searchWord];
    [self presentViewController:searchViewMode animated:YES completion:nil];
}

#pragma mark //UITableView Header & Footer Refresh Methods ----------------------------------------------------------------------------
- (void)beginRefresh
{
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
        [[IPCHttpRequest sharedClient] cancelAllRequest];
    }
    [self.refreshFooter resetDataStatus];
    [self loadNormalProducts:^{
        [self reloadTableView];
    }];
}

- (void)loadMore
{
    self.glassListViewMode.currentPage += 1;
    
    [self loadGlassesListData:^{
        [self reloadTableView];
    }];
}

#pragma mark //Load Normal Method
- (void)beginFilterClass
{
    self.productTableView.isBeginLoad = YES;
    [self loadNormalProducts:^{
        [self reloadTableView];
    }];
    [self.productTableView reloadData];
}

#pragma mark //Reload View
- (void)reloadTableView
{
    self.productTableView.isBeginLoad = NO;
    [self.productTableView reloadData];
    [self.glassListViewMode.filterView setCoverStatus:YES];
    
    [self stopRefresh];
}

#pragma mark //Request Data
- (void)queryRecommdGlasses
{
    if ([[IPCTryMatch instance] currentMatchItem].glass && !self.compareSwitch.isOn) {
        [self.glassListViewMode queryRecommdGlasses:[[IPCTryMatch instance] currentMatchItem].glass Complete:^{
            [self updateRecommdUI];
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
    [self.cameraBgView removeFromSuperview];
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
    [self removeCover];
    self.photoDeleteBtn.enabled = NO;
    
    for (IPCMatchItem *mi in [IPCTryMatch instance].matchItems) {
        mi.frontialPhoto = nil;
        mi.photoType = IPCPhotoTypeModel;
    }
    for (IPCCompareItemView *v in self.compareBgView.subviews)
        [v updateModelPhoto];
    
    [self.signleModeView updateModelPhoto];
    [self updateModelPhototPosition];
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
    self.photoDeleteBtn.enabled = NO;
    
    IPCMatchItem *mi = [IPCTryMatch instance].matchItems[0];
    if (mi.photoType == IPCPhotoTypeModel && mi.modelType == index) return;
    
    for (IPCMatchItem *item in [IPCTryMatch instance].matchItems) {
        item.modelType = sender.tag;
        item.photoType = IPCPhotoTypeModel;
        item.frontialPhoto = nil;
    }
    //更换模特照片
    [self.signleModeView updateModelPhoto];
    for (IPCCompareItemView *v in self.compareBgView.subviews)
        [v updateModelPhoto];
    //获取模特眼镜位置
    [self updateModelPhototPosition];
}

//获取模特眼镜位置
- (void)updateModelPhototPosition
{
    IPCMatchItem * item = [IPCTryMatch instance].currentMatchItem;
    UIImage * image =  [IPCAppManager modelPhotoWithType:item.modelType usage:IPCModelUsageSingleMode];
    //人脸识别
    [self outPutCameraImage:[image lsqImageScale:0.5]];
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
- (IBAction)removeCameraBgViewAction:(id)sender {
    [self removeCover];
}

- (IBAction)onCameraBtnTapped:(id)sender
{
    if ([self.cameraBgView superview]) {
        [self removeCover];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.cameraBgView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.cameraBgView];
    }
}

//Camera method
- (IBAction)onPickerFrontalBtnTapped:(id)sender
{
    [self removeCover];

    IPCDefineCameraBaseComponent * baseComponent = [[IPCDefineCameraBaseComponent alloc]initWithResultImage:^(UIImage *image) {
        [self outPutCameraImage:image];
        self.photoDeleteBtn.enabled = YES;
    }];
    [baseComponent showSampleWithController:self];
}

//Library method
- (IBAction)onPickerLibBtnTapped:(id)sender
{
    [self removeCover];

    IPCPhotoPickerBaseComponent * pickVC = [[IPCPhotoPickerBaseComponent alloc]initWithResultImage:^(UIImage *image) {
        [self outPutCameraImage:image];
        self.photoDeleteBtn.enabled = YES;
    }];
    [pickVC showSampleWithController:self];
}

//His head shot head modification model refresh glasses
- (void)outPutCameraImage:(UIImage *)image
{
    [IPCCommonUI showInfo:@"加载中..."];
    __weak typeof (self) weakSelf = self;
    //A network under the condition of priority calls online face recognition, if network error or request wrong call the offline face recognition
    self.offlineFaceDetector = [[IPCOfflineFaceDetector alloc]init];
    //Face recognition eye position
    self.faceRecognition = [[IPCOnlineFaceDetector alloc]initWithFaceFrame:^(CGPoint position, CGSize size) {
        [self updateModelFace:position Size:size];
    } Error:^(IFlySpeechError *error) {
        if (error) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.offlineFaceDetector offLineDecectorFace:image Face:^(CGPoint position,CGSize sizer) {
                [self updateModelFace:position Size:sizer];
            } ErrorBlock:^(NSError *error) {
                [IPCCommonUI showError:@"未检测到人脸轮廓"];
            }];
        }else{
            [IPCCommonUI showError:@"未检测到人脸轮廓"];
        }
    }];
    [self.faceRecognition postFaceRequest:image];
    [self changeCameraImage:image];
}

//Update Model Image Position & Size
- (void)updateModelFace:(CGPoint)position Size:(CGSize)size
{
    [self.signleModeView updateFaceUI:position :size];
    for (IPCCompareItemView * item in self.compareBgView.subviews)
        [item updateFaceUI:position :size];
    [IPCCommonUI hiden];
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
}

//Filter Products \ Search Products
- (void)onFilterProducts{
    [super onFilterProducts];
    
    if ([self.glassListViewMode.filterView superview]) {
        [self removeCover];
    }else{
        [self addCoverWithAlpha:0.2 Complete:^{
            [self removeCover];
        }];
        
        __weak typeof (self) weakSelf = self;
        [self.glassListViewMode showFilterCategory:self InView:self.coverView ReloadClose:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [self removeCover];
            [self beginFilterClass];
            [strongSelf.glassListViewMode queryBatchDegree];
        } ReloadUnClose:^{
            [self beginFilterClass];
        }];
    }
}

- (void)onSearchProducts{
    [super onSearchProducts];
    [self removeCover];
    [self presentSearchViewController];
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
    [self updateCompareBorder];
    [self setRecommdStatus:YES];
    
    for (IPCCompareItemView * item in self.compareBgView.subviews) {
        item.transform = CGAffineTransformIdentity;
        item.center = item.originalCenter;
        [item updateItem];
    }
    
    CGRect frame = self.signleModeView.frame;
    self.signleModeView.layer.anchorPoint = [[IPCTryMatch instance] singleModeViewAnchorPoint];
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

//更换当前试戴眼镜
- (void)updateCurrentGlass{
    if ([[IPCTryMatch instance] currentMatchItem].glass && !self.compareSwitch.isOn)
    {
        [self.tryGlassesView reload];
        self.tableViewTopConstant.constant = (SCREEN_HEIGHT - 70)/4;
        [self.tryGlassesView setHidden:NO];
    }else{
        self.tableViewTopConstant.constant = 0;
        [self.tryGlassesView setHidden:YES];
        [self.recommdBgView setHidden:YES];
    }
}

- (void)updateTryGlasses
{
    [self queryRecommdGlasses];
    self.signleModeView.matchItem = [[IPCTryMatch instance] currentMatchItem];
    if (self.compareBgView.subviews.count) {
        IPCCompareItemView * itemView = self.compareBgView.subviews[[IPCTryMatch instance].activeMatchItemIndex];
        itemView.matchItem = [[IPCTryMatch instance] currentMatchItem];
        [itemView updateItem];
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
    [self.signleModeView resetGlassView];
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
    IPCTryGlassesListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:glassListCellIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCTryGlassesListViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
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
            if (indexPath.row == self.glassListViewMode.glassesList.count -(self.glassListViewMode.limit - 10)) {
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
- (void)chooseParameter:(IPCTryGlassesListViewCell *)cell
{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.productTableView indexPathForCell:cell];
        [self showGlassesParameterView:self.glassListViewMode.glassesList[indexPath.row]];
    }
}

- (void)editBatchParameter:(IPCTryGlassesListViewCell *)cell
{
    if ([self.glassListViewMode.glassesList count] > 0) {
        NSIndexPath * indexPath = [self.productTableView indexPathForCell:cell];
        [self editGlassParameterView:self.glassListViewMode.glassesList[indexPath.row]];
    }
}

- (void)reloadProductList:(IPCTryGlassesListViewCell *)cell
{
    [self.tryGlassesView reload];;
    [self.productTableView reloadData];
}


- (void)tryGlasses:(IPCTryGlassesListViewCell *)cell
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
}

@end
