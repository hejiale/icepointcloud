//
//  IPCCustomDetailOrderPayRecordView.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/7.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomDetailOrderPayRecordView.h"

@interface IPCCustomDetailOrderPayRecordView()

@property (strong, nonatomic)  UILabel *payTypeNameLabel;
@property (strong, nonatomic)  UILabel *payDateLabel;
@property (strong, nonatomic)  UILabel *payPriceLabel;

@end

@implementation IPCCustomDetailOrderPayRecordView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.payTypeNameLabel];
    [self addSubview:self.payDateLabel];
    [self addSubview:self.payPriceLabel];
    
    [self.payTypeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.width.mas_equalTo(80);
    }];
    
    [self.payDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payTypeNameLabel.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.width.mas_equalTo(150);
    }];
    
    [self.payPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.width.mas_equalTo(150);
    }];
    
    
}

#pragma mark //Set UI
- (UILabel *)payTypeNameLabel
{
    if (!_payTypeNameLabel) {
        _payTypeNameLabel = [[UILabel alloc]init];
        [_payTypeNameLabel setFont:[UIFont systemFontOfSize:14]];
        [_payTypeNameLabel setTextColor:[UIColor colorWithHexString:@"#555555"]];
    }
    return _payTypeNameLabel;
}

- (UILabel *)payDateLabel{
    if (!_payDateLabel) {
        _payDateLabel = [[UILabel alloc]init];
        [_payDateLabel setFont:[UIFont systemFontOfSize:14]];
        [_payDateLabel setTextColor:[UIColor colorWithHexString:@"#555555"]];
    }
    return _payDateLabel;
}

- (UILabel *)payPriceLabel{
    if (!_payPriceLabel) {
        _payPriceLabel = [[UILabel alloc]init];
        [_payPriceLabel setFont:[UIFont systemFontOfSize:14]];
        [_payPriceLabel setTextColor:[UIColor redColor]];
        [_payPriceLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _payPriceLabel;
}


- (void)setPayType:(IPCPayRecord *)payType{
    _payType = payType;
    
    if (_payType) {
        [self.payTypeNameLabel setText:_payType.payOrderType.payType];
        [self.payDateLabel setText:[IPCCommon formatDate:[IPCCommon dateFromString:_payType.payDate] IsTime:YES]];
        [self.payPriceLabel setText:[NSString stringWithFormat:@"-￥%.2f",_payType.payPrice]];
    }
}

@end
