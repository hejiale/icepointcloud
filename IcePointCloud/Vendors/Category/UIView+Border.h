//
//  UIView+Border.h
//  IcePointCloud
//
//  Created by gerry on 2017/3/31.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)

- (void)addTopLine;
- (void)addBottomLine;
- (void)addLeftLine;
- (void)addRightLine;
- (void)addBorder:(CGFloat)corner Width:(CGFloat)width Color:(UIColor *)color;
- (void)addSignleCorner:(UIRectCorner)corner Size:(CGFloat)size;

@end
