//
//  IPCTryGlassView.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCTryGlassView.h"

@implementation IPCTryGlassView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addLeftLine];
    
    [self addSubview:self.glassesView];
    [self.glassesView addSubview:self.glassImageView];
    [self.glassesView addSubview:self.closeButton];
    
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
    
    [self.glassesView addTapActionWithDelegate:self Block:^(UIGestureRecognizer *gestureRecoginzer) {
        [self showCloseCover];
    }];
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
        [_closeButton setHidden:YES];
    }
    return _closeButton;
}

//Update the model picture
- (void)updateModelPhoto
{
    
}
- (void)updateItem
{
    
}

- (void)resetGlassView
{
    self.glassesView.transform = CGAffineTransformIdentity;
    self.glassImageView.transform = CGAffineTransformIdentity;
    [self.glassImageView setImage:nil];
}
/**
 *  Updated photo like glasses
 */
- (void)updateFaceUI:(CGPoint)point :(CGSize)size
{
    
}

- (void)amplificationLargeModelView
{
    
}

- (void)updateGlassesPositionWithMatchItem:(IPCMatchItem *)item
{
    [self.glassesView setHidden:YES];
    [self.glassesView addBorder:0 Width:0 Color:nil];
    [self.closeButton setHidden:YES];
    [self resetGlassView];
    
    if (item) {
        IPCGlassesImage *gi = [item.glass imageWithType:IPCGlassesImageTypeFrontialMatch];
        
        if (gi.imageURL.length)
        {
            [self.glassImageView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
            
            if (self.glassImageView.image)
            {
                [self.glassesView setHidden:NO];
                
                CGFloat scale          = self.glassesView.bounds.size.width / MAX(gi.width, 410);
                CGRect bounds       = self.glassesView.bounds;
                bounds.size.height = MAX(gi.height, 140) * scale;
                self.glassesView.bounds = bounds;
                self.glassesView.center = self.cameraEyePoint;
                
                [self.glassImageView setFrame:CGRectMake(0,0, bounds.size.width, bounds.size.height)];
                [self.closeButton setFrame:CGRectMake(bounds.size.width-25, 0, 25, 25)];
                [self.glassesView bringSubviewToFront:self.closeButton];
            }
        }
    }
}

#pragma mark //Show or hide to shut down
- (void)showCloseCover
{
    [self.glassesView addBorder:3 Width:0.5 Color:nil];
    [self.closeButton setHidden:NO];
}

- (void)hidenCloseCover
{
    [self.glassesView addBorder:0 Width:0 Color:nil];
    [self.closeButton setHidden:YES];
}

#pragma mark -  UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    [self showCloseCover];
    return YES;
}


@end
