//
//  IPCSwipeView.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/6.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwipeBlock) ();

@interface IPCSwipeView : UIView

@property (nonatomic, copy) UIView * contentView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isCanEdit;
@property (nonatomic, copy)SwipeBlock swipeBlock;

@end
