//
//  UITextField+Extend.h
//  IcePointCloud
//
//  Created by gerry on 2017/3/30.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extend)

- (void)setLeftImageView:(NSString *)imageName;
- (void)setRightView:(id)target Action:(SEL)action;
- (void)setRightButton:(id)target Action:(SEL)action OnView:(UIView *)onView;
- (void)setLeftSpace:(double)spaceWidth;

@end
