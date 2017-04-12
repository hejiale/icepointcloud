//
//  IPCPayOrderPayTypeView.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/23.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderPayTypeView.h"

typedef void(^UpdateBlock)();

@interface IPCPayOrderPayTypeView()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (nonatomic, copy) UpdateBlock updateBlock;

@end

@implementation IPCPayOrderPayTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderPayTypeView" owner:self];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentView addSignleCorner:UIRectCornerAllCorners Size:5];
    [self.completeButton setBackgroundColor:COLOR_RGB_BLUE];
    [self.completeButton addSignleCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight Size:5];
}


#pragma mark //Clicked Events
- (IBAction)selectWechatAction:(UIButton *)sender {
    if (!sender.selected)[sender setSelected:!sender.selected];
    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeWechat;
    [IPCPayOrderMode sharedManager].payStyleName = @"WECHAT";
    if (self.updateBlock)
        self.updateBlock();
}


- (IBAction)selectAlipayAction:(UIButton *)sender {
    if (!sender.selected)[sender setSelected:!sender.selected];
    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeAlipay;
    [IPCPayOrderMode sharedManager].payStyleName = @"ALIPAY";
    if (self.updateBlock)
        self.updateBlock();
}

- (IBAction)selectCashAction:(UIButton *)sender {
    if (!sender.selected)[sender setSelected:!sender.selected];
    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeCash;
    [IPCPayOrderMode sharedManager].payStyleName = @"CASH";
    if (self.updateBlock)
        self.updateBlock();
}


- (IBAction)selectCardAction:(UIButton *)sender {
    if (!sender.selected)[sender setSelected:!sender.selected];
    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeCard;
    [IPCPayOrderMode sharedManager].payStyleName = @"CARD";
    if (self.updateBlock)
        self.updateBlock();
}


@end
