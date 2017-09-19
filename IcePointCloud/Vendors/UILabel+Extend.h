//
//  UILabel+Extend.h
//  IcePointCloud
//
//  Created by gerry on 2017/9/19.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extend)


/**
 设置行间距 字间距
 
 @param text
 @param lineSpace
 @param wordSpace
 */
- (void)setSpaceWithText:(NSString *)text
               LineSpace:(CGFloat)lineSpace
               WordSpace:(CGFloat)wordSpace;


/**
 设置字体样式
 
 @param text
 @param beginRang
 @param rang
 @param font
 @param color
 */
- (void)subStringWithText:(nonnull NSString *)text
                BeginRang:(NSInteger)beginRang
                     Font:(nonnull UIFont *)font
                    Color:(nonnull UIColor *)color;


/**
 计算带行间距 字间距 的label 高度

 @param width
 @param lineSpace
 @param wordSpace
 @return 
 */
-(CGFloat)spaceHeightWithWidth:(CGFloat)width
                     LineSpace:(CGFloat)lineSpace
                     WordSpace:(CGFloat)wordSpace;

@end
