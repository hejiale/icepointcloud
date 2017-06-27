//
//  IPCCustomDetailOrderPayRecordView.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/7.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomDetailOrderPayRecordView.h"

@interface IPCCustomDetailOrderPayRecordView()

@property (weak, nonatomic) IBOutlet UIImageView *payTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;

@end

@implementation IPCCustomDetailOrderPayRecordView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomDetailOrderPayRecordView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)setPayType:(IPCPayRecord *)payType{
    _payType = payType;
    
    if (_payType) {
        if ([_payType.payTypeInfo isEqualToString:@"储值余额"]) {
            [self.payTypeImageView setImage:[UIImage imageNamed:@"icon_card"]];
        }else if ([_payType.payTypeInfo isEqualToString:@"现金"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"cash"]];
        }else if ([_payType.payTypeInfo isEqualToString:@"刷卡"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"card"]];
        }else if ([_payType.payTypeInfo isEqualToString:@"支付宝"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"zhifubao"]];
        }else if ([_payType.payTypeInfo isEqualToString:@"微信"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"wexin"]];
        }else if ([_payType.payTypeInfo isEqualToString:@"其它"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"icon_ wallet"]];
        }
        
        [self.payTypeNameLabel setText:_payType.payTypeInfo];
        [self.payDateLabel setText:[IPCCommon formatDate:[IPCCommon dateFromString:_payType.payDate] IsTime:YES]];
        [self.payPriceLabel setText:[NSString stringWithFormat:@"-￥%.2f",_payType.payPrice]];
    }
}

@end
