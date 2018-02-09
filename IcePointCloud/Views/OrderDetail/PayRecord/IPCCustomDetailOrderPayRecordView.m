//
//  IPCCustomDetailOrderPayRecordView.m
//  IcePointCloud
//
//  Created by gerry on 2017/6/7.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomDetailOrderPayRecordView.h"

@interface IPCCustomDetailOrderPayRecordView()

@property (weak, nonatomic) IBOutlet UILabel *payTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTypeWidth;

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
        CGFloat width = [_payType.payOrderType.payType jk_sizeWithFont:self.payTypeNameLabel.font constrainedToHeight:self.payTypeNameLabel.jk_height].width;
        self.payTypeWidth.constant = width;
        
        [self.payTypeNameLabel setText:_payType.payOrderType.payType];
        [self.payDateLabel setText:[IPCCommon formatDate:[IPCCommon dateFromString:_payType.payDate] IsTime:YES]];
        [self.payPriceLabel setText:[NSString stringWithFormat:@"-￥%.2f",_payType.payPrice]];
    }
}

@end
