//
//  IPCProgressHUD.h
//  IcePointCloud
//
//  Created by gerry on 2017/8/8.
//  Copyright © 2017年 Doray. All rights reserved.
//

@interface IPCProgressHUD : UIView

+ (IPCProgressHUD*)sharedView;

@property (assign, nonatomic) UIWindowLevel maxSupportedWindowLevel; // default is UIWindowLevelNormal

+ (void)showWithStatus:(NSString *)status;
+ (void)showAnimationImages:(NSArray<NSString *> *)images;
+ (void)showAnimationImages:(NSArray<NSString *> *)images status:(NSString*)status;

+ (void)showError:(NSString *)error Duration:(NSTimeInterval)duration;
+ (void)showSuccess:(NSString *)success Duration:(NSTimeInterval)duration;

+ (void)dismiss;
+ (void)dismissWithDuration:(NSTimeInterval)duration Delay:(NSTimeInterval)delay;

+ (BOOL)isVisible;

@end
