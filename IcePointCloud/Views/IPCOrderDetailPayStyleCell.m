//
//  IPCOrderDetailPayStyleCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/29.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCOrderDetailPayStyleCell.h"

@implementation IPCOrderDetailPayStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSString * payType = [IPCCustomOrderDetailList instance].orderInfo.payType;
    NSString * payTypeName = nil;
    
    if ([payType isEqualToString:@"CASH"]) {
        payTypeName = @"现金";
    }else if ([payType isEqualToString:@"ALIPAY"]){
        payTypeName = @"支付宝";
    }else if ([payType isEqualToString:@"WECHAT"]){
        payTypeName = @"微信支付";
    }else{
        payTypeName = @"刷卡";
    }
    
    [self.payStyleLabel setText:[NSString stringWithFormat:@"%@ %.f",payTypeName,[IPCCustomOrderDetailList instance].orderInfo.payTypeAmount]];
    
    NSString * remark = [NSString stringWithFormat:@"本次消费产生积分%d",[IPCCustomOrderDetailList instance].orderInfo.integral];
    [self.pointRemarkLabel setAttributedText:[IPCCustomUI subStringWithText:remark BeginRang:8 Rang:remark.length - 8 Font:self.pointRemarkLabel.font Color:COLOR_RGB_RED]];
}

@end
