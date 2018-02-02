//
//  IPCCustomAlertView.h
//  IcePointCloud
//
//  Created by gerry on 2018/2/2.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomAlertView : UIView

+ (void)showWithTitle:(NSString *)title Message:(NSString *)message CancelTitle:(NSString *)cancelTitle SureTitle:(NSString *)sureTitle Done:(void(^)())done Cancel:(void(^)())cancel;

@end
