//
//  UILabel+Extend.m
//  IcePointCloud
//
//  Created by gerry on 2017/9/19.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "UILabel+Extend.h"

@implementation UILabel (Extend)

/**
 设置行间距 字间距
 
 @param text
 @param lineSpace
 @param wordSpace
 */
- (void)setSpaceWithText:(NSString *)text
               LineSpace:(CGFloat)lineSpace
               WordSpace:(CGFloat)wordSpace
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = self.lineBreakMode;
    paraStyle.lineSpacing = lineSpace; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:
                              paraStyle, NSKernAttributeName:@(wordSpace)
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    self.attributedText = attributeStr;
}


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
                    Color:(nonnull UIColor *)color
{
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    if (color){
        [aAttributedString addAttribute:NSForegroundColorAttributeName
                                  value:color
                                  range:NSMakeRange(beginRang, text.length-beginRang)];
    }else{
        [aAttributedString addAttribute:NSForegroundColorAttributeName
                                  value:self.textColor
                                  range:NSMakeRange(beginRang, text.length-beginRang)];
    }
    
    if (font){
        [aAttributedString addAttribute:NSFontAttributeName
                                  value:font
                                  range:NSMakeRange(beginRang, text.length-beginRang)];
    }else{
        [aAttributedString addAttribute:NSFontAttributeName
                                  value:self.font
                                  range:NSMakeRange(beginRang, text.length-beginRang)];
    }
    
    [self setAttributedText:aAttributedString];
    [self sizeToFit];
}

-(CGFloat)spaceHeightWithWidth:(CGFloat)width
                     LineSpace:(CGFloat)lineSpace
                     WordSpace:(CGFloat)wordSpace
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = self.lineBreakMode;
    paraStyle.alignment = self.textAlignment;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:
                              paraStyle, NSKernAttributeName:@(wordSpace)
                          };
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end
