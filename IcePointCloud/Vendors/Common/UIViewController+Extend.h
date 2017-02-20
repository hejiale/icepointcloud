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

- (void)setNavigationTitle:(NSString *)title;

-(void)startAnimationWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint;


@end
