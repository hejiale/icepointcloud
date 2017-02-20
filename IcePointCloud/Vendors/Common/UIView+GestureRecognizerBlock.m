//
//  UIView+GestureRecognizerBlock.m
//  IcePointCloud
//
//  Created by mac on 2016/12/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "UIView+GestureRecognizerBlock.h"

static NSString * const IPC_ActionHandlerTapGestureKey = @"IPC_ActionHandlerTapGestureKey";
static NSString * const IPC_ActionHandlerLongPressGestureKey = @"IPC_ActionHandlerLongPressGestureKey";
static NSString * const IPC_ActionHandlerPanGestureKey = @"IPC_ActionHandlerPanGestureKey";
static NSString * const IPC_ActionHandlerPinGestureKey  = @"IPC_ActionHandlerPinGestureKey";
static NSString * const IPC_ActionHandlerRotationGestureKey = @"IPC_ActionHandlerRotationGestureKey";

@implementation UIView (GestureRecognizerBlock)


- (void)addTapActionWithDelegate:(id<UIGestureRecognizerDelegate>)delegate Block:(IPCGestureActionBlock)block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &IPC_ActionHandlerTapGestureKey);
    if (!gesture){
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        gesture.delegate = delegate;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &IPC_ActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &IPC_ActionHandlerTapGestureKey, block, OBJC_ASSOCIATION_COPY);
}


- (void)handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized){
        IPCGestureActionBlock block = objc_getAssociatedObject(self, &IPC_ActionHandlerTapGestureKey);
        if (block){
            block(gesture);
        }
    }
}


- (void)addLongPressActionWithDelegate:(id<UIGestureRecognizerDelegate>)delegate Block:(IPCGestureActionBlock)block{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &IPC_ActionHandlerLongPressGestureKey);
    if (!gesture){
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForLongPressGesture:)];
        gesture.delegate = delegate;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &IPC_ActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &IPC_ActionHandlerLongPressGestureKey, block, OBJC_ASSOCIATION_COPY);
}



- (void)handleActionForLongPressGesture:(UILongPressGestureRecognizer *)gesture{
    IPCGestureActionBlock block = objc_getAssociatedObject(self, &IPC_ActionHandlerLongPressGestureKey);
    if (block){
        block(gesture);
    }
}


- (void)addPanGestureActionWithDelegate:(id<UIGestureRecognizerDelegate>)delegate Block:(IPCGestureActionBlock)block{
    UIPanGestureRecognizer *gesture = objc_getAssociatedObject(self, &IPC_ActionHandlerPanGestureKey);
    if (!gesture){
        gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForPanGesture:)];
        gesture.delegate = delegate;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &IPC_ActionHandlerPanGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &IPC_ActionHandlerPanGestureKey, block, OBJC_ASSOCIATION_COPY);
}


- (void)handleActionForPanGesture:(UIPanGestureRecognizer *)gesture{
    IPCGestureActionBlock block = objc_getAssociatedObject(self, &IPC_ActionHandlerPanGestureKey);
    if (block){
        block(gesture);
    }
}


- (void)addPinGestureActionWithDelegate:(id<UIGestureRecognizerDelegate>)delegate Block:(IPCGestureActionBlock)block{
    UIPinchGestureRecognizer *gesture = objc_getAssociatedObject(self, &IPC_ActionHandlerPinGestureKey);
    if (!gesture){
        gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForPinGesture:)];
        gesture.delegate = delegate;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &IPC_ActionHandlerPinGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &IPC_ActionHandlerPinGestureKey, block, OBJC_ASSOCIATION_COPY);
}


- (void)handleActionForPinGesture:(UIPinchGestureRecognizer *)gesture{
    IPCGestureActionBlock block = objc_getAssociatedObject(self, &IPC_ActionHandlerPinGestureKey);
    if (block){
        block(gesture);
    }
}


- (void)addRotationGestureActionWithDelegate:(id<UIGestureRecognizerDelegate>)delegate Block:(IPCGestureActionBlock)block{
    UIRotationGestureRecognizer *gesture = objc_getAssociatedObject(self, &IPC_ActionHandlerRotationGestureKey);
    if (!gesture){
        gesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForRotationGesture:)];
        gesture.delegate = delegate;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &IPC_ActionHandlerRotationGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &IPC_ActionHandlerRotationGestureKey, block, OBJC_ASSOCIATION_COPY);
}



- (void)handleActionForRotationGesture:(UIRotationGestureRecognizer *)gesture{
    IPCGestureActionBlock block = objc_getAssociatedObject(self, &IPC_ActionHandlerRotationGestureKey);
    if (block){
        block(gesture);
    }
}




@end
