//
//  DefineCameraBaseComponent.m
//  IcePointCloud
//
//  Created by mac on 15/5/11.
//  Copyright (c) 2016年 Doray. All rights reserved.
//

#import "IPCDefineCameraBaseComponent.h"

@interface IPCDefineCameraBaseComponent()

@property (nonatomic, copy) void(^ResultImageBlock)(UIImage *);

@end

#pragma mark - DefineCameraBaseComponent
/**
 *  Based camera custom
 */
@implementation IPCDefineCameraBaseComponent


- (instancetype)initWithResultImage:(void(^)(UIImage * image))imageBlock
{
    self = [super init];
    if (self) {
        self.ResultImageBlock = imageBlock;
    }
    return self;
}

/**
 *
 *  @param controller
 */
- (void)showSampleWithController:(UIViewController *)controller;
{
    if (!controller) return;
    [controller presentViewController:[[IPCDefineCameraViewController alloc] initWithImageBlock:^(UIImage *image) {
        if (self.ResultImageBlock)
            self.ResultImageBlock(image);
        
    }] animated:YES completion:nil];
}
@end


#pragma mark - DefineCameraViewController
/**
 *  Basic camera view controller
 */
@interface IPCDefineCameraViewController ()<TuSDKStillCameraDelegate, TuSDKPFCameraFilterGroupViewDelegate>
{
    // The camera object
    id<TuSDKStillCameraInterface> _camera;
    // The camera view
    UIView *_cameraView;
    // The camera configuration section
    UIView *_configBar;
    // Cancel button
    UIButton *_cancelButton;
    // Camera before and after the switch button
    UIButton *_switchCameraButton;
    // Flash Settings view
    UIView *_flashBar;
    // The flash button collection
    NSMutableArray *_flashButtons;
    // Flash mode
    AVCaptureFlashMode _flashMode;
    // Bottom bar
    UIView *_bottomBar;
    // Photo button
    UIButton *_captureButton;
    // Camera filters the view
    TuSDKPFCameraFilterGroupView *_filterBar;
    // Filter switch
    UIButton *_filterButton;
    // Photo preview view
    UIButton *_preview;
    //The title
    UILabel * _topTitleLabel;
    //The face of a frame
    UIImageView * _personLayer;
}

@property (copy, nonatomic) void(^OutImageBlock)(UIImage *);

@end

@implementation IPCDefineCameraViewController

- (instancetype)initWithImageBlock:(void(^)(UIImage *image))imageBlock
{
    self = [super init];
    if (self) {
        self.OutImageBlock = imageBlock;
    }
    return self;
}


#pragma mark - camera action
- (BOOL)prefersStatusBarHidden;
{
    return YES;
}

-(void)loadView
{
    [super loadView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


-(void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
    // Camera open access
    [TuSDKTSDeviceSettings checkAllowWithController:self
                                               type:lsqDeviceSettingsCamera
                                          completed:^(lsqDeviceSettingsType type, BOOL openSetting)
     {
         if (openSetting) {
             lsqLError(@"Can not open camera");
             return;
         }
         [self startCamera];
     }];
}

// To start the camera
-(void)startCamera;
{
    [self destoryCamera];
    
    _camera = [TuSDK cameraWithSessionPreset:AVCaptureSessionPresetHigh
                              cameraPosition:[AVCaptureDevice lsqFirstFrontCameraPosition] // AVCaptureDevicePositionBack
                                  cameraView:_cameraView];
    _camera.captureDelegate = self;
    
    // Optional: binding manual focus view, set the view to show the size size automatically
    TuSDKCPFocusTouchView *focusView = [TuSDKCPFocusTouchView initWithFrame:CGRectZero];
    [_camera bindFocusTouchView:focusView];
    // Whether open long press shoot (default: NO)
    _camera.enableLongTouchCapture = YES;
    // Disable the front-facing camera automatic level mirror (default: NO, a front-facing camera shooting results, automatically level mirror)
    _camera.disableMirrorFrontFacing = YES;
    _camera.enableFaceDetection = YES;
    //Start the camera
    [_camera tryStartCameraCapture];
}


- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    
    [self destoryCamera];
}

/**
 *  Select a filter
 *
 *  @param filterName The name of the filter
 *  @return
 */
- (BOOL)onSelectedFilterCode:(NSString *)code;
{
    if (!_camera) return YES;
    return [_camera switchFilterWithCode:code];
}

/**
 *  Before and after the switch camera
 *
 *  @param sender
 */
- (void)onSwitchCamera:(UIButton *)sender;
{
    if (!_camera) return;
    
    [_camera rotateCamera];
}


/**
 *  Click on the photo button
 *
 *  @param sender
 */
- (void)onCapturePhoto:(UIButton *)sender;
{
    if (!_camera) return;
    [IPCCustomUI show];
    [_camera captureImage];
}

/**
 *  Destruction of the camera
 */
- (void)destoryCamera;
{
    if (_camera) {
        [_camera destory];
        _camera = nil;
    }
}

- (void)dealloc;
{
    [self controllerWillDestory];

    if (self.isViewLoaded && self.view) {
        [self.view viewWillDestory];
        self.view = nil;
    }
    lsqLDebug(@"dealloc controller %@: %@" , self.title, self);
}
#pragma mark - TuSDKPFCameraFilterGroupViewDelegate
/**
 *  Select a filter
 *
 *  @param view    Camera filters the view
 *  @param item    Filter grouping element
 *  @param capture Whether to allow filming
 *
 *  @return 是否允许继续执行
 */
- (BOOL)onTuSDKPFCameraFilterGroup:(TuSDKPFCameraFilterGroupView *)view
                      selectedItem:(TuSDKCPGroupFilterItem *)item
                           capture:(BOOL)capture;
{
    if (capture) {
        [self onCapturePhoto:nil];
        return YES;
    }
    
    switch (item.type) {
        case lsqGroupFilterItemFilter:
            return [self onSelectedFilterCode:[item filterCode]];
        default:
            break;
    }
    return YES;
}

/**
 *  Camera filters view state changes
 *
 *  @param view   Camera filters the view
 *  @param isShow Whether or not shown
 */
- (void)onTuSDKPFCameraFilterGroup:(TuSDKPFCameraFilterGroupView *)view
                      stateChanged:(BOOL)isShow;
{
    
}
#pragma mark - TuSDKStillCameraDelegate
/**
 *  Camera state changes (for operating the UI thread, please check whether the current thread is given priority to the thread)
 *
 *  @param camera The camera object
 *  @param state  The running state of the camera
 */
- (void)onStillCamera:(id<TuSDKStillCameraInterface>)camera stateChanged:(lsqCameraState)state;
{
    
}

/**
 *  Pictures (for operating the UI thread, please check whether the current thread is given priority to the thread)
 *
 *  @param camera The camera object
 *  @param result To obtain the result of
 *  @param error
 */
- (void)onStillCamera:(id<TuSDKStillCameraInterface>)camera takedResult:(TuSDKResult *)result error:(NSError *)error;
{
    if (error) return;
    
    lsqLDebug(@"Result(%ld): %@",result.image.imageOrientation, NSStringFromCGSize(result.image.size));
    
    [self performSelectorOnMainThread:@selector(onPreviewShow:) withObject:result waitUntilDone:YES];
}


// According to the preview view
- (void)onPreviewShow:(TuSDKResult *)result;
{
    [_preview removeAllSubviews];
    
    UIImageView *imgView = [UIImageView initWithFrame:_preview.bounds];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage * sourceImage = [result.image lsqImageScale:1.5];
    
    UIImage *image = [result.image lsqImageCorpWithSize:sourceImage.size rect:self.view.bounds outputSize:CGSizeMake(569, 748) orientation:UIImageOrientationUp interpolationQuality:kCGInterpolationHigh];
    
    lsqLDebug(@"image: %@", NSStringFromCGSize(image.size));
    
    imgView.image = image;
    [_preview addSubview:imgView];
    
    _preview.alpha = 0;
    _preview.hidden = NO;
    [UIView animateWithDuration:0.32 animations:^{
        _preview.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [IPCCustomUI hiden];
            
            if (self.OutImageBlock)
                self.OutImageBlock(image);
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

// Close the preview view
- (void)onClosePreview:(id)sender;
{
    [UIView animateWithDuration:0.32 animations:^{
        _preview.alpha = 0;
    } completion:^(BOOL finished) {
        [_preview removeAllSubviews];
        _preview.hidden = YES;
        
        [_camera resumeCameraCapture];
    }];
}
#pragma mark - init
-(void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view = [UIView initWithFrame:CGRectMake(0, 0, lsqScreenHeight,lsqScreenWidth)];
    self.view.backgroundColor = lsqRGB(122, 122, 122);
    
    // The camera configuration section
    _configBar = [UIView initWithFrame:CGRectMake(0, 0, self.view.getSizeWidth, 60)];
    [_configBar setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_configBar];
    
    // Bottom bar
    _bottomBar = [UIView initWithFrame:CGRectMake(0, self.view.getSizeHeight - 100, self.view.getSizeWidth, 100)];
    [_bottomBar setBackgroundColor:COLOR_RGB_BLUE];
    [self.view addSubview:_bottomBar];
    
    // The camera view
    _cameraView = [UIView initWithFrame:CGRectMake(0, _configBar.getBottomY, self.view.getSizeWidth, self.view.getSizeHeight-_configBar.getSizeHeight-_bottomBar.getSizeHeight)];
    [self.view addSubview:_cameraView];
    
    // Cancel button
    _cancelButton = [UIButton buttonWithFrame:CGRectMake(0, 10, 60, _configBar.getSizeHeight)
                                    imageName:@"icon_back"];
    
    [_cancelButton addTouchUpInsideTarget:self action:@selector(onWindowExit:)];
    [_configBar addSubview:_cancelButton];
    
    // Camera before and after the switch button
    _switchCameraButton = [UIButton buttonWithFrame:CGRectMake(_configBar.getSizeWidth - 60, 10, 60, _configBar.getSizeHeight)
                                          imageName:@"camera_swap_btn"];
    
    [_switchCameraButton addTouchUpInsideTarget:self action:@selector(onSwitchCamera:)];
    [_configBar addSubview:_switchCameraButton];
    
    //The title bar
    _topTitleLabel = [UILabel initWithFrame:CGRectMake(_configBar.center.x - 200, 15, 400, _configBar.getSizeHeight-15) font:[UIFont systemFontOfSize:20 weight:UIFontWeightThin] color:COLOR_RGB_BLUE aligment:NSTextAlignmentCenter];
    [_topTitleLabel setText:@"请把脸调整至虚线框内，点击拍摄按钮保存"];
    [_configBar addSubview:_topTitleLabel];
    
    // If there is only one camera
    _switchCameraButton.hidden = ([AVCaptureDevice lsqCameraCounts] == 0);
    
    //The face of a frame
    _personLayer = [UIImageView initWithFrame:CGRectMake(0, _configBar.getBottomY+50, self.view.getSizeWidth, self.view.getSizeHeight-_configBar.getSizeHeight-_bottomBar.getSizeHeight-50) imageNamed:@"camera_person_frame"];
    [self.view addSubview:_personLayer];
    
    // Photo button
    CGFloat capBtnSize = _bottomBar.getSizeHeight - 20;
    _captureButton = [UIButton initWithFrame:CGRectMake([_bottomBar getCenterX:capBtnSize], [_bottomBar getCenterY:capBtnSize], capBtnSize, capBtnSize)];
    [_captureButton setStateNormalImageName:@"camera_shoot_btn"];
    _captureButton.layer.cornerRadius = capBtnSize * 0.5f;
    _captureButton.layer.masksToBounds = YES;
    [_captureButton addTouchUpInsideTarget:self action:@selector(onCapturePhoto:)];
    [_bottomBar addSubview:_captureButton];
    
    [self buildFilterWindow];
}

/**
 *  To create a filter list window
 */
- (void)buildFilterWindow;
{
    // Camera filters the view
    _filterBar = [TuSDKPFCameraFilterGroupView initWithFrame:self.view.bounds];
    [self.view addSubview:_filterBar];
    [_filterBar setDefaultShowState: YES];
    _filterBar.autoSelectGroupDefaultFilter = YES;
    _filterBar.delegate = self;
    [_filterBar loadFilters];
    
    // Filter switch
    _filterButton = [UIButton buttonWithFrame:CGRectZero imageName:@"filter"];
    [_filterButton addTouchUpInsideTarget:self action:@selector(onFilterWindowToggle)];
    [_bottomBar addSubview:_filterButton];
    [_filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomBar.mas_right).with.offset(0);
        make.centerY.mas_equalTo(_bottomBar.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
}

/**
 *  Filter view switch
 */
- (void)onFilterWindowToggle;
{
    [_filterBar showGroupView];
}

/**
 *  Out of the camera
 *
 *  @param sender
 */
- (void)onWindowExit: (id)sender;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
