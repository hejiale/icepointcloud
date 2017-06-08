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
        [self.payTypeNameLabel setText:_payRecord.payStyleName];
        [self.payAmountLabel setText:[NSString stringWithFormat:@"￥%.2f",_payRecord.payAmount]];
        
        if ([payRecord.payStyleName isEqualToString:@"储值余额"]) {
            [self.payTypeImageView setImage:[UIImage imageNamed:@"icon_card"]];
        }else if ([payRecord.payStyleName isEqualToString:@"现金"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"cash"]];
        }else if ([payRecord.payStyleName isEqualToString:@"刷卡"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"card"]];
        }else if ([payRecord.payStyleName isEqualToString:@"支付宝"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"zhifubao"]];
        }else if ([payRecord.payStyleName isEqualToString:@"微信"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"wexin"]];
        }else if ([payRecord.payStyleName isEqualToString:@"其它"]){
            [self.payTypeImageView setImage:[UIImage imageNamed:@"icon_ wallet"]];
        }
    }
}

@end
