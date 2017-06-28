//
//  UIViewController+Extend.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extend)

@property (nonatomic, strong) UIView *  backGroudView;

- (void)setBackground;

- (void)addBackgroundViewWithAlpha:(CGFloat)alpha InView:(UIView *)view Complete:(void (^)())completed;


@end
