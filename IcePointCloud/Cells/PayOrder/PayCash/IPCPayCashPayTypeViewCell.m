//
//  IPCPayCashPayTypeViewCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/12/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayCashPayTypeViewCell.h"

@implementation IPCPayCashPayTypeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPayType:(IPCPayOrderPayType *)payType
{
    _payType = payType;
    
    if (_payType) {
        [self.payTypeNameLabel setText:_payType.payType];
    }
}

- (void)updateBorder:(BOOL)isUpdate
{
    if (isUpdate) {
        [self addBorder:0 Width:1 Color:COLOR_RGB_BLUE];
        [self.payTypeNameLabel setTextColor:COLOR_RGB_BLUE];
    }else{
        [self addBorder:0 Width:0 Color:nil];
        [self.payTypeNameLabel setTextColor:[UIColor jk_colorWithHexString:@"#888888"]];
    }
}

@end
