//
//  IPCProgressHUD.h
//  IcePointCloud
//
//  Created by gerry on 2017/8/8.
//  Copyright © 2017年 Doray. All rights reserved.
//

@interface IPCProgressHUD : UIView

+ (void)showAnimationImages:(NSArray<NSString *> *)images;
+ (void)showAnimationImages:(NSArray<NSString *> *)images status:(NSString*)status;

+ (void)dismiss;
+ (void)dismissWithDuration:(NSTimeInterval)duration Delay:(NSTimeInterval)delay;

+ (BOOL)isVisible;

@end
