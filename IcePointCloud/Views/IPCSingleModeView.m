//
//  IPCSingleModeView.m
//  IcePointCloud
//
//  Created by mac on 8/15/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCSingleModeView.h"

@interface IPCSingleModeView()
{
    CGPoint  cameraEyePoint;
    CGSize   cameraEyeSize;
}
@property (nonatomic, weak)  IBOutlet UIImageView *modelView;
@property (strong, nonatomic) UIView *glassesView;
@property (strong, nonatomic) UIImageView *glassImageView;
@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation IPCSingleModeView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self addLeftLine];
    [self addSubview:self.glassesView];
    [self.glassesView addSubview:self.glassImageView];
    [self.glassesView addSubview:self.closeButton];
    [self initGlassView];
    
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


- (void)setMatchItem:(IPCMatchItem *)matchItem
{
    _matchItem = matchItem;
    [self updateItem];
}


#pragma mark //Set UI
- (UIView *)glassesView{
    if (!_glassesView) {
        _glassesView = [[UIView alloc]init];
        _glassesView.userInteractionEnabled = YES;
        [_glassesView addBorder:0 Width:0 Color:nil];
        [_glassesView setHidden:YES];
    }
    return _glassesView;
}

- (UIImageView *)glassImageView{
    if (!_glassImageView) {
        _glassImageView = [[UIImageView alloc]init];
        _glassImageView.contentMode = UIViewContentModeScaleAspectFit;
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
- (IBAction)handlePhotoPinch:(UIPinchGestureRecognizer *)recognizer
{
    CGFloat scale = recognizer.scale;
    self.modelView.transform = CGAffineTransformScale(self.modelView.transform, scale, scale);
    self.glassesView.transform = CGAffineTransformScale(self.glassesView.transform, scale, scale);
    recognizer.scale = 1;
}

- (IBAction)doubleTapPhotoAction:(UITapGestureRecognizer *)recognizer{
    [self updateItem];
}

- (void)initGlassView{
    [super initGlassView];
    
    self.modelView.transform = CGAffineTransformIdentity;
    self.glassesView.transform = CGAffineTransformIdentity;
    [self.glassImageView setImage:nil];
}

//Update the model picture
- (void)updateModelPhoto
{
    [super updateModelPhoto];
    
    self.modelView.transform = CGAffineTransformIdentity;
    self.glassesView.transform = CGAffineTransformIdentity;
    
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
}

/**
 *  Updated photo like glasses
 */
- (void)updateFaceUI:(CGPoint)point :(CGSize)size
{
    [super updateFaceUI:point :size];
    
    self.modelView.transform = CGAffineTransformIdentity;
    self.glassesView.transform = CGAffineTransformIdentity;
    
    cameraEyePoint = point;
    cameraEyeSize = size;
    
    [self updateGlassFrame];
}


/**
 *  Update the position of the glasses
 */
- (void)updateGlassFrame{
    CGRect frame           = self.glassesView.frame;
    frame.size.width       = cameraEyeSize.width;
    self.glassesView.frame = frame;
    
    [self updateItem];
}

//Place the glasses
- (void)updateItem{
    [super updateItem];
    
    self.modelView.transform = CGAffineTransformIdentity;
    self.glassesView.transform = CGAffineTransformIdentity;
    
    [self.glassesView addBorder:0 Width:0 Color:nil];
    [self.closeButton setHidden:YES];
    [self updateGlassesPhoto];
}


- (void)updateGlassesPhoto
{
    IPCGlassesImage *gi = [self.matchItem.glass imageWithType:IPCGlassesImageTypeFrontialMatch];
    
    if (gi.imageURL.length){
        [self.glassImageView sd_setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholderImage:[UIImage imageNamed:@"glasses_placeholder"]];
    }else{
        [self.glassesView setHidden:YES];
        [self.glassImageView setImage:nil];
    }
    
    if (self.glassImageView.image)
    {
        [self.glassesView setHidden:NO];
        
        CGFloat scale          = self.glassesView.bounds.size.width / gi.width;
        CGRect bounds       = self.glassesView.bounds;
        bounds.size.height = gi.height * scale;
        self.glassesView.bounds = bounds;
        self.glassesView.center = cameraEyePoint;
        
        [self.glassImageView setFrame:CGRectMake(0,0, bounds.size.width, bounds.size.height)];
        [self.closeButton setFrame:CGRectMake(bounds.size.width-25, 0, 25, 25)];
        [self.glassesView bringSubviewToFront:self.closeButton];
    }
}


- (void)deleteModel{
}

- (IBAction)tapModelViewAction:(id)sender {
    [self hidenClose];
}

- (void)hidenGlassBgView{
    [self.glassesView setHidden:YES];
    [self initGlassView];
    self.matchItem.glass = nil;
    [self updateItem];
    [self deleteModel];
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

#pragma mark //Show or hide to shut down
- (void)showClose{
    if (self.matchItem.glass) {
        [self.glassesView addBorder:3 Width:2 Color:nil];
        [self.closeButton setHidden:NO];
    }
}

- (void)hidenClose{
    [self.glassesView addBorder:0 Width:0 Color:nil];
    [self.closeButton setHidden:YES];
}


@end
