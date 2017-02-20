//
//  UIView+Extend.h
//  IcePointCloud
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extend)

- (void)addTopLine;
- (void)addBottomLine;
- (void)addLeftLine;
- (void)addRightLine;
- (void)addBorder:(CGFloat)corner Width:(CGFloat)width;
- (void)addSignleCorner:(UIRectCorner)corner Size:(CGFloat)size;

@end
