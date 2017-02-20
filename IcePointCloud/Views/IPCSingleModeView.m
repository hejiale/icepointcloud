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
@property (weak, nonatomic) IBOutlet UILabel *glassNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) UIView *glassesView;
@property (strong, nonatomic) UIImageView *glassImageView;
@property (strong, nonatomic) UIButton *closeButton;
@property (nonatomic) CGPoint draggedPosition;

@end

@implementation IPCSingleModeView


- (void)awakeFromNib{
    [super awakeFromNib];
    [self commitInitUI];
}


- (void)commitInitUI
{
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


- (void)setMatchItem:(IPCMatchItem *)matchItem
{
    _matchItem = matchItem;
    [self updateItem:NO];
}


#pragma mark //Set UI
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
    self.modelView.transform = CGAffineTransformIdentity;
    self.glassesView.transform = CGAffineTransformIdentity;
}

- (void)initGlassView{
    self.glassesView.transform = CGAffineTransformIdentity;
    self.draggedPosition = CGPointMake(-100, -100);
    [self.glassImageView setImage:nil];
}

//Update the model picture
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
    cameraEyePoint = point;
    cameraEyeSize = size;
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

//Place the glasses
- (void)dropGlasses:(IPCGlasses *)glasses onLocaton:(CGPoint)location
{
    self.matchItem.glass = glasses;
    [self initGlassView];
    [self updateItem:YES];
}

- (void)updateItem:(BOOL)isDroped{
    [self.glassesView addBorder:0 Width:0];
    [self.closeButton setHidden:YES];
    [self updateGlassesPhoto:isDroped];
    
    if (self.matchItem.glass) {
        self.glassNameLabel.text = self.matchItem.glass.glassName;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.f", self.matchItem.glass.price];
    }else{
        [self.glassNameLabel setText:@""];[self.priceLabel setText:@""];
    }
}


- (void)updateGlassesPhoto:(BOOL)isDroped
{
    IPCGlassesImage *gi = [self.matchItem.glass imageWithType:IPCGlassesImageTypeFrontialMatch];
    
    if (gi.imageURL.length){
        [self.glassImageView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
    }else{
        [self.glassesView setHidden:YES];
        [self.glassImageView setImage:nil];
    }
    
    if (self.glassImageView.image)
    {
        [self.glassesView setHidden:NO];
        
        CGFloat scale      = self.glassesView.bounds.size.width / gi.width;
        CGRect bounds      = self.glassesView.bounds;
        bounds.size.height = gi ? gi.height*scale : [self defaultGlassesSize].height;
        self.glassesView.bounds = bounds;
        
        if (isDroped) {
            CGPoint center;
            if ([self isDraggedPositionDefault]) {
                CGPoint p = [self defaultGlassesPosition];
                center = CGPointMake(p.x + bounds.size.width / 2, p.y + bounds.size.height / 2);
            } else {
                center = self.draggedPosition;
            }
            
            [UIView animateWithDuration:.2 animations:^{
                self.glassesView.center = center;
            }];
        }else{
            CGPoint p = [self defaultGlassesPosition];
            self.glassesView.center = CGPointMake(p.x + bounds.size.width / 2, p.y + bounds.size.height / 2);
        }
        [self.glassImageView setFrame:CGRectMake(0,0, bounds.size.width, bounds.size.height)];
        [self.closeButton setFrame:CGRectMake(bounds.size.width-35, -5, 40, 40)];
        [self.glassesView bringSubviewToFront:self.closeButton];
    }
}



- (IBAction)scaleAction:(id)sender {
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
    [self updateItem:NO];
    [self deleteModel];
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

#pragma mark //Show or hide to shut down
- (void)showClose{
    [self.glassesView addBorder:3 Width:1];
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
        orignY = 170;
    }else if (self.matchItem.modelType == IPCModelTypeGirlWithShortHair){
        orignY = 225;
    }else{
        orignY = 200;
    }
    
    cameraEyePoint = CGPointMake(32, orignY);
    cameraEyeSize  = CGSizeMake(460, 0);
    
    [self updateGlassFrame];
}


@end
