//
//  UIViewController+Extend.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCEmptyAlertView.h"

@interface UIViewController (Extend)

@property (nonatomic, strong) UIView *  backGroudView;

- (void)setNavigationTitle:(NSString *)title;

-(void)startAnimationWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint;

- (void)addBackgroundViewWithAlpha:(CGFloat)alpha Complete:(void(^)())completed;

@end
