//
//  ZYProGressView.h
//  ProgressBar
//
//  Created by mac on 2017/4/12.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCProgressView : UIView

/**
    进度值
 */
@property (nonatomic,copy) NSString *progressValue;

/**
    进度条的颜色
 */
@property (nonatomic,strong) UIColor *progressColor;

/**
    进度条的背景色
 */
@property (nonatomic,strong) UIColor *bottomColor;







@end
