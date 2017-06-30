//
//  IPCTryGlassView.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/30.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCMatchItem.h"

@interface IPCTryGlassView : UIView<UIGestureRecognizerDelegate>

@property (strong, nonatomic)  UIImageView *modelImageView;
@property (strong, nonatomic)  UIView  *bottomView;
@property (strong, nonatomic)  UILabel *glassNameLabel;
@property (strong, nonatomic)  UILabel *glassPriceLabel;
@property (strong, nonatomic)  UIButton *scaleButton;

@property (strong, nonatomic) UIView   *glassesView;
@property (strong, nonatomic) UIImageView  *glassImageView;
@property (strong, nonatomic) UIButton   *closeButton;
@property (assign, nonatomic) IPCModelUsage   modelUsage;

- (void)updateModelPhotoForItem:(IPCMatchItem *)matchItem;
- (void)updateFaceUIForItem:(IPCMatchItem *)matchItem :(CGPoint)point :(CGSize)size;
- (void)updateItemForItem:(IPCMatchItem *)matchItem : (BOOL)isDroped;

@end
