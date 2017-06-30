//
//  IPCTryGlassView.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/30.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCTryGlassView.h"

@interface IPCTryGlassView()

@property (nonatomic, assign) CGPoint  draggedPosition;
@property (nonatomic, assign) CGPoint  cameraEyePoint;
@property (nonatomic, assign) CGSize   cameraEyeSize;

@end

@implementation IPCTryGlassView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    __block CGFloat scale  = (self.modelUsage == IPCModelUsageSingleMode ? 1 : 0.5);
    
    [self addSubview:self.modelImageView];
    [self addSubview:self.bottomView];
    [self bringSubviewToFront:self.bottomView];
    [self.bottomView addSubview:self.glassNameLabel];
    [self.bottomView addSubview:self.glassPriceLabel];
    [self.bottomView addSubview:self.scaleButton];
    
//    [self addSubview:self.glassesView];
//    [self.glassesView addSubview:self.glassImageView];
//    [self.glassesView addSubview:self.closeButton];
//    [self addGlassesGestureRecognizer];
//    [self addModelGestureRecognizer];
    
    [self.modelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.mas_equalTo(80*scale);
    }];
    
    __block CGFloat scaleSize = 80*scale - 10;
    
    [self.glassNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).with.offset(20);
        make.top.equalTo(self.bottomView.mas_top).with.offset(10);
        make.right.equalTo(self.bottomView.mas_right).with.offset(-scaleSize);
        make.height.mas_equalTo(20);
    }];
    
    [self.glassPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).with.offset(20);
        make.bottom.equalTo(self.bottomView.mas_bottom).with.offset(-10);
        make.right.equalTo(self.mas_right).with.offset(-scaleSize);
        make.height.mas_equalTo(20);
    }];
    
    [self.scaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY).with.offset(0);
        make.right.equalTo(self.bottomView.mas_right).with.offset(0);
        make.width.mas_equalTo(scaleSize);
        make.height.mas_equalTo(scaleSize);
    }];
    
    [self initGlassView];
}

#pragma mark //Set UI
- (UIImageView *)modelImageView{
    if (!_modelImageView) {
        _modelImageView = [[UIImageView alloc]init];
        _modelImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _modelImageView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        [_bottomView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.1]];
    }
    return _bottomView;
}

- (UILabel *)glassNameLabel{
    if (!_glassNameLabel) {
        _glassNameLabel = [[UILabel alloc]init];
        [_glassNameLabel setFont:[UIFont systemFontOfSize:UIFontWeightThin weight:14]];
        [_glassNameLabel setTextColor:[UIColor whiteColor]];
    }
    return _glassNameLabel;
}

- (UILabel *)glassPriceLabel{
    if (!_glassPriceLabel) {
        _glassPriceLabel = [[UILabel alloc]init];
        [_glassPriceLabel setFont:[UIFont systemFontOfSize:UIFontWeightThin weight:14]];
        [_glassPriceLabel setTextColor:[UIColor whiteColor]];
    }
    return _glassPriceLabel;
}


- (UIButton *)scaleButton{
    if (!_scaleButton) {
        _scaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scaleButton setImage:[UIImage imageNamed:@"icon_fullscreen"] forState:UIControlStateNormal];
        [_scaleButton setImage:[UIImage imageNamed:@"icon_shrinkscreen"] forState:UIControlStateSelected];
        [_scaleButton addTarget:self action:@selector(scaleAction:) forControlEvents:UIControlEventTouchUpInside];
        _scaleButton.adjustsImageWhenHighlighted = NO;
    }
    return _scaleButton;
}

- (UIView *)glassesView{
    if (!_glassesView) {
        _glassesView = [[UIView alloc]initWithFrame:self.bounds];
        _glassesView.userInteractionEnabled = YES;
        [_glassesView addBorder:0 Width:0];
        [_glassesView setHidden:YES];
    }
    return _glassesView;
}

- (UIImageView *)glassImageView{
    if (!_glassImageView) {
        _glassImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _glassImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _glassImageView;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setFrame:CGRectZero];
        [_closeButton setImage:[UIImage imageNamed:@"icon_dark_close"] forState:UIControlStateNormal];
        [_closeButton setBackgroundColor:[UIColor clearColor]];
        [_closeButton addTarget:self action:@selector(hidenGlassBgView:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setHidden:YES];
    }
    return _closeButton;
}

- (void)addModelGestureRecognizer{
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenGlassBgView:)];
    [self.modelImageView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapModelAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.modelImageView addGestureRecognizer:doubleTap];
    
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchModelAction:)];
    [self.modelImageView addGestureRecognizer:pinch];
}

- (void)addGlassesGestureRecognizer{
    //Rotating mobile kneading gestures
    [self.glassesView addRotationGestureActionWithDelegate:self Block:^(UIGestureRecognizer *gestureRecoginzer) {
        UIRotationGestureRecognizer * rotationRecognizer = (UIRotationGestureRecognizer *)gestureRecoginzer;
        rotationRecognizer.view.transform = CGAffineTransformRotate(rotationRecognizer.view.transform, rotationRecognizer.rotation);
        rotationRecognizer.rotation = 0;
    }];
    
    
    [self.glassesView addPanGestureActionWithDelegate:self Block:^(UIGestureRecognizer *gestureRecoginzer) {
        UIPanGestureRecognizer * panGesture = (UIPanGestureRecognizer *)gestureRecoginzer;
        CGPoint translation = [panGesture translationInView:self];
        panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x,
                                             panGesture.view.center.y + translation.y);
        [panGesture setTranslation:CGPointMake(0, 0) inView:self];
        
        if (panGesture.state == UIGestureRecognizerStateEnded) {
            CGPoint finalPoint = CGPointMake(panGesture.view.center.x,
                                             panGesture.view.center.y);
            finalPoint.x = MIN(MAX(finalPoint.x, 0), self.bounds.size.width);
            finalPoint.y = MIN(MAX(finalPoint.y, 0), self.bounds.size.height);
            panGesture.view.center = finalPoint;
            self.draggedPosition = finalPoint;
        }
    }];
    
    [self.glassesView addPinGestureActionWithDelegate:self Block:^(UIGestureRecognizer *gestureRecoginzer) {
        UIPinchGestureRecognizer * pinGesture = (UIPinchGestureRecognizer *)gestureRecoginzer;
        pinGesture.view.transform = CGAffineTransformScale(pinGesture.view.transform, pinGesture.scale, pinGesture.scale);
        pinGesture.scale = 1;
    }];
    
    [self.glassesView addTapActionWithDelegate:nil Block:^(UIGestureRecognizer *gestureRecoginzer) {
        [self showClose];
    }];
}

#pragma mark //Clicked Events
- (void)initGlassView{
    self.glassesView.transform = CGAffineTransformIdentity;
    self.draggedPosition = CGPointMake(-100, -100);
    [self.glassImageView setImage:nil];
}

- (void)scaleAction:(id)sender {
    
}

- (void)closeGlassCoverAction:(id)sender {
    [self hidenClose];
}

- (void)pinchModelAction:(UIPinchGestureRecognizer *)recognizer
{
    CGFloat scale = recognizer.scale;
    self.modelImageView.transform = CGAffineTransformScale(self.modelImageView.transform, scale, scale);
    self.glassesView.transform = CGAffineTransformScale(self.glassesView.transform, scale, scale);
    recognizer.scale = 1;
}

- (void)doubleTapModelAction:(id)sender {
    self.modelImageView.transform = CGAffineTransformIdentity;
    self.modelImageView.transform = CGAffineTransformIdentity;
}

- (void)hidenGlassBgView:(id)sender
{
    [self.glassesView setHidden:YES];
//    [self initGlassView];
    [self updateItemForItem:nil :NO];
}

//Show or hide to shut down
- (void)showClose{
    [self.glassesView addBorder:3 Width:0.5];
    [self.closeButton setHidden:NO];
}

- (void)hidenClose{
    [self.glassesView addBorder:0 Width:0];
    [self.closeButton setHidden:YES];
}

#pragma mark //Update Glass Frame
- (void)updateModelPhotoForItem:(IPCMatchItem *)matchItem
{
    UIImage *img;
    switch (matchItem.photoType) {
        case IPCPhotoTypeModel:
            img = [IPCAppManager modelPhotoWithType:matchItem.modelType usage:self.modelUsage];
            break;
        case IPCPhotoTypeFrontial:
            img = matchItem.frontialPhoto;
            break;
        default:
            break;
    }
    self.modelImageView.image = img;
    
    if (matchItem.photoType == IPCPhotoTypeModel){
        [self updateEyeRectForItem:matchItem];
    }
}


- (void)updateFaceUIForItem:(IPCMatchItem *)matchItem :(CGPoint)point :(CGSize)size
{
    self.cameraEyePoint = point;
    self.cameraEyeSize = size;
    [self updateGlassFrameForItem:matchItem];
}


- (void)updateGlassFrameForItem:(IPCMatchItem *)matchItem
{
    CGRect frame           = self.glassesView.frame;
    frame.origin.y           = self.cameraEyePoint .y;
    frame.size.width       = self.cameraEyeSize.width;
    self.glassesView.frame = frame;
    
    [self updateItemForItem:matchItem :NO];
}


- (void)updateItemForItem:(IPCMatchItem *)matchItem : (BOOL)isDroped
{
    [self.glassesView addBorder:0 Width:0];
    [self.closeButton setHidden:YES];
    [self updateGlassesPhotoForItem:matchItem : isDroped];
    
    if (matchItem.glass) {
        self.glassNameLabel.text = matchItem.glass.glassName;
        self.glassPriceLabel.text  = [NSString stringWithFormat:@"￥%.f", matchItem.glass.price];
    }else{
        [self.glassNameLabel setText:@""];
        [self.glassPriceLabel setText:@""];
    }
}


- (void)updateGlassesPhotoForItem:(IPCMatchItem *)matchItem : (BOOL)isDroped
{
    IPCGlassesImage *gi = [matchItem.glass imageWithType:IPCGlassesImageTypeFrontialMatch];
    
    if (gi.imageURL.length){
        [self.glassImageView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
    }else{
        [self.glassesView setHidden:YES];
        [self.glassImageView setImage:nil];
    }
    
    if (self.glassImageView.image)
    {
        [self.glassesView setHidden:NO];
        
        CGFloat scale          = self.glassesView.bounds.size.width / gi.width;
        CGRect bounds       = self.glassesView.bounds;
        bounds.size.height = gi ? gi.height*scale : self.cameraEyeSize.height;
        self.glassesView.bounds = bounds;
        
        if (isDroped) {
            CGPoint center;
            if ([self isDraggedPositionDefault]) {
                CGPoint p = self.cameraEyePoint;
                center = CGPointMake(p.x + bounds.size.width / 2, p.y + bounds.size.height / 2);
            } else {
                center = self.draggedPosition;
            }
            
            [UIView animateWithDuration:.2 animations:^{
                self.glassesView.center = center;
            }];
        }else{
            CGPoint p = self.cameraEyePoint;
            self.glassesView.center = CGPointMake(p.x + bounds.size.width / 2, p.y + bounds.size.height / 2);
        }
        [self.glassImageView setFrame:CGRectMake(0,0, bounds.size.width, bounds.size.height)];
        
        __block CGFloat usageScale  = (self.modelUsage == IPCModelUsageSingleMode ? 1 : 0.5);
        [self.closeButton setFrame:CGRectMake(bounds.size.width-(40*usageScale), -5, 40*usageScale, 40*usageScale)];
        [self.glassesView bringSubviewToFront:self.closeButton];
    }
}

#pragma mark //Default Position
- (BOOL)isDraggedPositionDefault
{
    return self.draggedPosition.x == -100 && self.draggedPosition.y == -100;
}

#pragma mark -  UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    [self showClose];
    return YES;
}

#pragma mark //SingleMode / CompareMode Frame
- (void)updateEyeRectForItem:(IPCMatchItem *)matchItem
{
    __block CGFloat orignY = 0;
    __block CGFloat scale  = (self.modelUsage == IPCModelUsageSingleMode ? 1 : 0.5);
    
    if (matchItem.modelType == IPCModelTypeGirlWithLongHair) {
        orignY = 170 * scale;
    }else if (matchItem.modelType == IPCModelTypeGirlWithShortHair){
        orignY = 225 * scale;
    }else{
        orignY = 200 * scale;
    }
    
    self.cameraEyePoint = CGPointMake(32 * scale, orignY);
    self.cameraEyeSize  = CGSizeMake(460 * scale, 0);
    
    [self updateGlassFrameForItem:matchItem];
}


@end
