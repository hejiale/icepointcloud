//
//  UIView+Border.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/31.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "UIView+Border.h"

@implementation UIView (Border)

- (void)addTopLine{
    [self jk_addTopBorderWithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.2] width:0.5];
}


- (void)addBottomLine{
    [self jk_addBottomBorderWithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.2] width:0.5];
}

- (void)addLeftLine{
    [self jk_addLeftBorderWithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.2] width:0.5];
}

- (void)addRightLine{
    [self jk_addRightBorderWithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.2] width:0.5];
}

- (void)addBorder:(CGFloat)corner Width:(CGFloat)width
{
    [self.layer setBorderWidth:width];
    [self.layer setBorderColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor];
    [self.layer setCornerRadius:corner];
}

- (void)addSignleCorner:(UIRectCorner)corner Size:(CGFloat)size
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(size, size)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
