//
//  CompareItemView.m
//  IcePointCloud
//
//  Created by mac on 8/7/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCCompareItemView.h"

@interface IPCCompareItemView()

@property (nonatomic, weak) IBOutlet UIImageView *modelView;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *glassesPriceLbl;

@end

@implementation IPCCompareItemView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.closeButton addTarget:self action:@selector(hidenGlassBgView) forControlEvents:UIControlEventTouchUpInside];
    [self resetGlassView];
}

- (void)setMatchItem:(IPCMatchItem *)matchItem{
    _matchItem = matchItem;
    [self updateItem];
}

#pragma mark //Clicked Events
- (void)resetGlassView{
    [super resetGlassView];
    self.modelView.transform = CGAffineTransformIdentity;
}

- (IBAction)onScaleTapped:(id)sender
{
    [self amplificationLargeModelView];
}

- (void)amplificationLargeModelView
{
    [super amplificationLargeModelView];
    
    [self.superview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != self) {
            [UIView animateWithDuration:.2 delay:.1 * idx options:0 animations:^{
                obj.alpha = 0;
            } completion:nil];
        }
    }];
    
    CGRect parentFrame = self.superview.frame;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.2 delay:.2 options:0 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.transform = CGAffineTransformScale(strongSelf.transform, 2.0, 2.0);
        strongSelf.center = CGPointMake(parentFrame.size.width / 2, parentFrame.size.height / 2);
    } completion:^(BOOL finished) {
        if (finished) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.parentSingleModeView.alpha = 0;
            strongSelf.parentSingleModeView.transform = CGAffineTransformIdentity;
            strongSelf.parentSingleModeView.hidden = NO;
            
            [IPCTryMatch instance].activeMatchItemIndex = self.tag;
            
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(didAnimateToSingleMode:)])
                [strongSelf.delegate didAnimateToSingleMode:strongSelf];
            
            [UIView animateWithDuration:.3 animations:^{
                strongSelf.alpha = 0;
                strongSelf.parentSingleModeView.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }
    }];
}

- (IBAction)tapModelViewAction:(id)sender {
    if (!self.closeButton.isHidden) {
        [self hidenCloseCover];
    }else{
        if ([self.delegate respondsToSelector:@selector(selectCompareIndex:)]) {
            [self.delegate selectCompareIndex:self];
        }
    }
}


- (IBAction)doubleTapAction:(id)sender {
    [self updateItem];
}

- (void)hidenGlassBgView
{
    self.matchItem.glass = nil;
    [self updateItem];
    
    if ([self.delegate respondsToSelector:@selector(deleteCompareGlasses:)]) {
        [self.delegate deleteCompareGlasses:self];
    }
}


#pragma mark //Modify the glasses location
//Modify the model photos
- (void)updateModelPhoto
{
    [super updateModelPhoto];
    
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
    
    self.cameraEyePoint = CGPointMake(point.x/2, point.y/2);
    self.cameraEyeSize  = CGSizeMake(size.width/2, 0);
    [self updateGlassFrame];
}

/**
 *  Update the position of the glasses
 */
- (void)updateGlassFrame{
    CGRect frame           = self.glassesView.frame;
    frame.size.width       = self.cameraEyeSize.width;
    self.glassesView.frame = frame;

    [self updateItem];
}

- (void)updateGlassesDescription
{
    if (self.matchItem) {
        IPCGlasses *glasses = self.matchItem.glass;
        
        if (glasses) {
            self.glassesNameLbl.text = glasses.glassName;
            self.glassesPriceLbl.text = [NSString stringWithFormat:@"￥%.f", glasses.price];
        }else{
            [self.glassesNameLbl setText:@""];[self.glassesPriceLbl setText:@""];
        }
    }
}

- (void)updateItem
{
    [super updateItem];
    
    [self updateGlassesDescription];
    [self updateGlassesPositionWithMatchItem:self.matchItem];
}


@end
