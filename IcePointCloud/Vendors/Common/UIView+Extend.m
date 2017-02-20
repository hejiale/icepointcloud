//
//  UIView+Extend.m
//  IcePointCloud
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)

- (void)addTopLine{
    [self jk_addTopBorderWithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.3] width:0.7];
}


- (void)addBottomLine{
    [self jk_addBottomBorderWithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.3] width:0.7];
}

- (void)addLeftLine{
    [self jk_addLeftBorderWithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.3] width:0.7];
}

- (void)addRightLine{
    [self jk_addRightBorderWithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.3] width:0.7];
}

- (void)addBorder:(CGFloat)corner Width:(CGFloat)width
{
    [self.layer setBorderWidth:width];
    [self.layer setBorderColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.5].CGColor];
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
