//
//  IPCPayTypeRecordView.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/6.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayTypeRecordView.h"

@interface IPCPayTypeRecordView()

@property (weak, nonatomic) IBOutlet UIImageView *payTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *payDateLabel;


@end

@implementation IPCPayTypeRecordView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayTypeRecordView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)setPayRecord:(IPCPayRecord *)payRecord{
    _payRecord = payRecord;
    
    if (_payRecord) {
        [self.payTypeNameLabel setText:_payRecord.payTypeInfo];
        [self.payAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",_payRecord.payPrice]];
        
        if ([_payRecord.payTypeInfo isEqualToString:@"储值余额"]) {
            [self.payTypeImageView setImage:[UIImage imageNamed:@"icon_card"]];
        }else if ([_payRecord.payTypeInfo isEqualToString:@"现金"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"cash"]];
        }else if ([_payRecord.payTypeInfo isEqualToString:@"刷卡"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"card"]];
        }else if ([_payRecord.payTypeInfo isEqualToString:@"支付宝"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"zhifubao"]];
        }else if ([_payRecord.payTypeInfo isEqualToString:@"微信"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"wexin"]];
        }else if ([_payRecord.payTypeInfo isEqualToString:@"其它"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"icon_ wallet"]];
        }
        
        if (_payRecord.isHavePay) {
            [self.payDateLabel setHidden:NO];
            [self.payDateLabel setText:[IPCCommon formatDate:[IPCCommon dateFromString:_payRecord.payDate] IsTime:YES]];
        }
    }
}

@end
