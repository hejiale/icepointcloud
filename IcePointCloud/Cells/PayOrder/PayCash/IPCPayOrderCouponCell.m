//
//  IPCPayOrderCouponCell.m
//  IcePointCloud
//
//  Created by gerry on 2018/6/20.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderCouponCell.h"

@implementation IPCPayOrderCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCoupon:(IPCPayOrderCoupon *)coupon
{
    _coupon = coupon;
    
    if (_coupon) {
        [self.couponNameLabel setText:_coupon.title];
        
        if (_coupon.sillPrice > 0) {
            [self.useConditionsLabel setText:[NSString stringWithFormat:@"满%.f元", _coupon.sillPrice]];
        }else{
            [self.useConditionsLabel setText:@"无门槛"];
        }
        
        [self.couponAmountLabel setText:[NSString stringWithFormat:@"%.f",_coupon.denomination]];
        [self.useScenarioLabel setText:([_coupon.cashCouponSceneType isEqualToString:@"OFFLINE_RETAIL"] ? @"门店消费":@"线上使用")];
        
        if(_coupon.effectiveEndTime)
        {
            [self.useDateLabel setText:[NSString stringWithFormat:@"%@-%@",[IPCCommon formatDate:[IPCCommon dateFromString:_coupon.effectiveStartTime]  IsTime:NO],[IPCCommon formatDate:[IPCCommon dateFromString:_coupon.effectiveEndTime]  IsTime:NO]]];
        }else{
            [self.useDateLabel setText:@"永久有效"];
        }
    }
}

- (void)refreshStatus:(BOOL)isSelect
{
    [self.selectImage setHidden:!isSelect];
    
    if (isSelect) {
        [self.couponNameLabel setTextColor:[UIColor colorWithHexString:@"#3DA8F5"]];
        [self.useScenarioLabel setTextColor:[UIColor colorWithHexString:@"#3DA8F5"]];
        [self.useConditionsLabel setTextColor:[UIColor colorWithHexString:@"#3DA8F5"]];
        [self.couponAmountLabel setTextColor:[UIColor colorWithHexString:@"#3DA8F5"]];
        [self.useDateLabel setTextColor:[UIColor colorWithHexString:@"#3DA8F5"]];
    }else{
        [self.couponNameLabel setTextColor:[UIColor colorWithHexString:@"#000"]];
        [self.useScenarioLabel setTextColor:[UIColor colorWithHexString:@"#000"]];
        [self.useConditionsLabel setTextColor:[UIColor colorWithHexString:@"#000"]];
        [self.couponAmountLabel setTextColor:[UIColor colorWithHexString:@"#000"]];
        [self.useDateLabel setTextColor:[UIColor colorWithHexString:@"#000"]];
    }
}

@end
