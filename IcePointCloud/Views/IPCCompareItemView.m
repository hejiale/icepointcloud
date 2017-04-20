//
//  CompareItemView.m
//  IcePointCloud
//
//  Created by mac on 8/7/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCCompareItemView.h"

@interface IPCCompareItemView()<UIGestureRecognizerDelegate>
{
    CGPoint  draggedPosition;
    CGPoint  cameraEyePoint;
    CGSize   cameraEyeSize;
}
@property (nonatomic, weak) IBOutlet UIImageView *modelView;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *glassesPriceLbl;

@property (strong, nonatomic) UIView *glassesView;
@property (strong, nonatomic) UIImageView *glassImageView;
@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation IPCCompareItemView

@synthesize delegate = _delegate;


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self addLeftLine];
    
    [self addSubview:self.glassesView];
    [self.glassesView addSubview:self.glassImageView];
    [self.glassesView addSubview:self.closeButton];
    [self initGlassView];
    
    //Rotate the kneading mobile hand gesture
    [self.glassesView addRotationGestureActionWithDelegate:self Block:^(UIGestureRecognizer *gestureRecoginzer) {
        UIRotationGestureRecognizer * rotationGesture = (UIRotationGestureRecognizer *)gestureRecoginzer;
        rotationGesture.view.transform = CGAffineTransformRotate(rotationGesture.view.transform, rotationGesture.rotation);
        rotationGesture.rotation = 0;
    }];
    
    __weak typeof (self) weakSelf = self;
    [self.glassesView addPanGestureActionWithDelegate:self Block:^(UIGestureRecognizer *gestureRecoginzer) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf glassPanGestureRecognizer:gestureRecoginzer];
    }];
    
    [self.glassesView addPinGestureActionWithDelegate:self Block:^(UIGestureRecognizer *gestureRecoginzer) {
        UIPinchGestureRecognizer * pinchGesture = (UIPinchGestureRecognizer *)gestureRecoginzer;
        pinchGesture.view.transform = CGAffineTransformScale(pinchGesture.view.transform, pinchGesture.scale, pinchGesture.scale);
        pinchGesture.scale = 1;
    }];
    
    [self.glassesView addTapActionWithDelegate:nil Block:^(UIGestureRecognizer *gestureRecoginzer) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf showClose];
    }];
}


- (void)setMatchItem:(IPCMatchItem *)matchItem{
    _matchItem = matchItem;
    [self updateItem:NO];
}

#pragma mark //Set UI
- (UIView *)glassesView{
    if (!_glassesView) {
        _glassesView = [[UIView alloc]initWithFrame:self.bounds];
        [_glassesView addBorder:0 Width:0];
    }
    return _glassesView;
}

- (UIImageView *)glassImageView{
    if (!_glassImageView) {
        _glassImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _glassImageView;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setFrame:CGRectZero];
        [_closeButton setImage:[UIImage imageNamed:@"icon_dark_close"] forState:UIControlStateNormal];
        [_closeButton setBackgroundColor:[UIColor clearColor]];
        [_closeButton addTarget:self action:@selector(hidenGlassBgView) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setHidden:YES];
    }
    return _closeButton;
}

#pragma mark //Clicked Events
- (void)initGlassView{
    self.glassesView.transform = CGAffineTransformIdentity;
    draggedPosition = CGPointMake(-100, -100);
}

- (IBAction)onScaleTapped:(id)sender
{
    [self amplificationLargeModelView];
}

- (void)amplificationLargeModelView
{
    [self.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != self) {
            [UIView animateWithDuration:.2 delay:.1 * idx options:0 animations:^{
                obj.alpha = 0;
            } completion:nil];
        }
    }];
    
    CGRect parentFrame = self.superview.frame;
    
    [UIView animateWithDuration:.2 delay:.2 options:0 animations:^{
        self.transform = CGAffineTransformScale(self.transform, 2.0, 2.0);
        self.center = CGPointMake(parentFrame.size.width / 2, parentFrame.size.height / 2);
    } completion:^(BOOL finished) {
        if (finished) {
            self.parentSingleModeView.alpha = 0;
            self.parentSingleModeView.transform = CGAffineTransformIdentity;
            self.parentSingleModeView.hidden = NO;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didAnimateToSingleMode:withIndex:)])
                [self.delegate didAnimateToSingleMode:self withIndex:self.tag];
            
            [UIView animateWithDuration:.3 animations:^{
                self.alpha = 0;
                self.parentSingleModeView.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }
    }];
}

//Modify the model photos
- (void)updateModelPhoto
{
    UIImage *img;
    switch (self.matchItem.photoType) {
        case IPCPhotoTypeModel:
            img = [IPCAppManager modelPhotoWithType:self.matchItem.modelType usage:IPCModelUsageSingleMode];
            break;
        case IPCPhotoTypeFrontial:
            img = self.matchItem.frontialPhoto;
            break;
        default:
            break;
    }
    self.modelView.image = img;
    
    if (self.matchItem.photoType == IPCPhotoTypeModel){
        [self updateEyeRect];
    }
}


/**
 *  Updated photo like glasses
 */
- (void)updateFaceUI:(CGPoint)point :(CGSize)size
{
    cameraEyePoint = CGPointMake(point.x/2, point.y/2);
    cameraEyeSize  = CGSizeMake(size.width/2, 0);
    [self updateGlassFrame];
}


/**
 *  Update the position of the glasses
 */
- (void)updateGlassFrame{
    CGRect frame           = self.glassesView.frame;
    frame.origin.y         = [self defaultGlassesPosition].y;
    frame.size.width       = [self defaultGlassesSize].width;
    self.glassesView.frame = frame;
    
    [self updateItem:NO];
}


- (void)updateItem:(BOOL)isDroped
{
    [self.glassesView addBorder:0 Width:0];
    [self.closeButton setHidden:YES];
    [self updateGlassesPhoto:isDroped];
    
    IPCGlasses *glasses = self.matchItem.glass;
    
    if (glasses) {
        self.glassesNameLbl.text = glasses.glassName;
        self.glassesPriceLbl.text = [NSString stringWithFormat:@"￥%.f", glasses.price];
    }else{
        [self.glassesNameLbl setText:@""];[self.glassesPriceLbl setText:@""];
    }
}


- (IBAction)tapModelViewAction:(id)sender {
    [self hidenClose];
}


- (IBAction)doubleTapAction:(id)sender {
    self.modelView.transform = CGAffineTransformIdentity;
    self.glassesView.transform = CGAffineTransformIdentity;
}


- (void)glassPanGestureRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x,
                                         recognizer.view.center.y);
        
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.bounds.size.height);
        recognizer.view.center = finalPoint;
        
        draggedPosition = finalPoint;
    }
}

- (void)hidenGlassBgView{
    [self.glassesView setHidden:YES];
    [self initGlassView];
    self.matchItem.glass = nil;
    [self updateItem:NO];
    if ([self.delegate respondsToSelector:@selector(deleteCompareGlasses:)]) {
        [self.delegate deleteCompareGlasses:self];
    }
}


#pragma mark //Modify the glasses location
- (void)dropGlasses:(IPCGlasses *)glasses onLocaton:(CGPoint)location
{
    self.matchItem.glass = glasses;
    [self initGlassView];
    [self updateItem:YES];
}


- (void)updateGlassesPhoto:(BOOL)isDroped
{
    IPCGlassesImage *gi = [self.matchItem.glass imageWithType:IPCGlassesImageTypeFrontialMatch];
    
    if (gi.imageURL.length){
        [self.glassImageView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
    }else{
        [self.glassImageView setImage:nil];
    }
    
    if (self.glassImageView.image) {
        CGFloat scale = self.glassesView.bounds.size.width / gi.width;
        CGRect bounds = self.glassesView.bounds;
        bounds.size.height = (gi ?  gi.height*scale : [self defaultGlassesSize].height);
        self.glassesView.bounds = bounds;
        
        if (isDroped) {
            CGPoint center;
            if ([self isDraggedPositionDefault]) {
                CGPoint p = [self defaultGlassesPosition];
                center = CGPointMake(p.x + bounds.size.width / 2, p.y + bounds.size.height / 2);
            } else {
                center = draggedPosition;
            }
            __weak typeof (self) weakSelf = self;
            [UIView animateWithDuration:.2 animations:^{
                __strong typeof (weakSelf) strongSelf = weakSelf;
                strongSelf.glassesView.center = center;
            }];
        }else {
            CGPoint p = [self defaultGlassesPosition];
            self.glassesView.center = CGPointMake(p.x + bounds.size.width / 2, p.y + bounds.size.height / 2);
        }
        
        [self.glassImageView setFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
        [self.closeButton setFrame:CGRectMake(bounds.size.width - 20, 0, 20, 20)];
    }
}

#pragma mark //Default Position
- (CGPoint)defaultGlassesPosition
{
    return cameraEyePoint;
}

- (CGSize)defaultGlassesSize
{
    return cameraEyeSize;
}

//Access to the anchor
- (CGPoint)singleModeViewAnchorPoint
{
    switch (self.tag) {
        case 0:
            return CGPointMake(0, 0);
        case 1:
            return CGPointMake(1, 0);
        case 2:
            return CGPointMake(0, 1);
        case 3:
            return CGPointMake(1, 1);
        default:
            return CGPointZero;
    }
}

- (BOOL)isDraggedPositionDefault
{
    return draggedPosition.x == -100 && draggedPosition.y == -100;
}

#pragma mark -  UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    [self showClose];
    
    return YES;
}


#pragma mark //Show or hide to shut down
- (void)showClose{
    [self.glassesView addBorder:3 Width:0.5];
    [self.closeButton setHidden:NO];
}

- (void)hidenClose{
    [self.glassesView addBorder:0 Width:0];
    [self.closeButton setHidden:YES];
}

#pragma mark //Figure eye position detecting local models
- (void)updateEyeRect
{
    __block CGFloat orignY = 0;
    
    if (self.matchItem.modelType == IPCModelTypeGirlWithLongHair) {
        orignY = 90;
    }else if (self.matchItem.modelType == IPCModelTypeGirlWithShortHair){
        orignY = 110;
    }else{
        orignY = 100;
    }
    
    cameraEyePoint = CGPointMake(20, orignY);
    cameraEyeSize  = CGSizeMake(220, 0);
    
    [self updateGlassFrame];
}


@end
