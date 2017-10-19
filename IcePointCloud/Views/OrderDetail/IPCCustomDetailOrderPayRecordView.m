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
        [self.payTypeImageView setImage:[[IPCAppManager sharedManager] payTypeImage:_payType.payTypeInfo]];
        [self.payTypeNameLabel setText:_payType.payTypeInfo];
        [self.payDateLabel setText:[IPCCommon formatDate:[IPCCommon dateFromString:_payType.payDate] IsTime:YES]];
        [self.payPriceLabel setText:[NSString stringWithFormat:@"-￥%.2f",_payType.payPrice]];
    }
}

@end
