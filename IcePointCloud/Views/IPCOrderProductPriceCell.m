//
//  OrderProductPriceCell.m
//  IcePointCloud
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOrderProductPriceCell.h"

@implementation IPCOrderProductPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)inputBeforeDiscountPrice:(double)beforePrice AfterPrice:(double)afterPrice
{
    NSString * beforePriceText = [NSString stringWithFormat:@"合计:￥%.f",afterPrice];
//    NSString * afterPriceText = [NSString stringWithFormat:@"折后金额:￥%.f",afterPrice];
    
    CGFloat beforeWidth = [beforePriceText jk_widthWithFont:self.beforePriceLabel.font constrainedToHeight:self.beforePriceLabel.jk_height];
//    CGFloat afterWith = [afterPriceText jk_widthWithFont:self.afterPriceLabel.font constrainedToHeight:self.afterPriceLabel.jk_height];
    
    [self.beforePriceLabel setAttributedText:[IPCUIKit subStringWithText:beforePriceText BeginRang:3 Rang:beforePriceText.length - 3 Font:[UIFont systemFontOfSize:16 weight:UIFontWeightThin] Color:[UIColor darkGrayColor]]];
    
//    [self.afterPriceLabel setAttributedText:[IPCUIKit subStringWithText:afterPriceText BeginRang:5 Rang:afterPriceText.length - 5 Font:[UIFont systemFontOfSize:16 weight:UIFontWeightThin] Color:[UIColor darkGrayColor]]];
    
    self.beforePriceWidth.constant = beforeWidth + 10;
//    self.afterPriceWidth.constant = afterWith + 20;
}

@end
