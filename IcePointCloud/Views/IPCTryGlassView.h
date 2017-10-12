//
//  IPCTryGlassView.h
//  IcePointCloud
//
//  Created by gerry on 2017/7/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCMatchItem.h"
#import "IPCGlasses.h"

@interface IPCTryGlassView : UIView<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *glassesView;
@property (strong, nonatomic) UIImageView *glassImageView;
@property (strong, nonatomic) UIButton *closeButton;

@property (nonatomic, strong, readwrite) UIView * parentSingleModeView;
@property (nonatomic, assign, readwrite) CGPoint originalCenter;
@property (nonatomic, assign, readwrite) CGPoint singleModeViewAnchorPoint;

@property (nonatomic, assign, readwrite) CGPoint  cameraEyePoint;
@property (nonatomic, assign, readwrite) CGSize   cameraEyeSize;

//Update the model picture
- (void)updateModelPhoto;
- (void)updateItem;
- (void)updateGlassesPositionWithMatchItem:(IPCMatchItem *)item;
- (void)resetGlassView;
/**
 *  Updated photo like glasses
 */
- (void)updateFaceUI:(CGPoint)point :(CGSize)size;

- (void)amplificationLargeModelView;

- (void)showCloseCover;

- (void)hidenCloseCover;

@end
