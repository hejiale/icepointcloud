//
//  UIView+GestureRecognizerBlock.h
//  IcePointCloud
//
//  Created by mac on 2016/12/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IPCGestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (GestureRecognizerBlock)

- (void)addTapActionWithDelegate:(id<UIGestureRecognizerDelegate>)delegate Block:(IPCGestureActionBlock)block;
- (void)addLongPressActionWithDelegate:(id<UIGestureRecognizerDelegate>)delegate Block:(IPCGestureActionBlock)block;
- (void)addPanGestureActionWithDelegate:(id<UIGestureRecognizerDelegate>)delegate Block:(IPCGestureActionBlock)block;
- (void)addPinGestureActionWithDelegate:(id<UIGestureRecognizerDelegate>)delegate Block:(IPCGestureActionBlock)block;
- (void)addRotationGestureActionWithDelegate:(id<UIGestureRecognizerDelegate>)delegate Block:(IPCGestureActionBlock)block;

@end
