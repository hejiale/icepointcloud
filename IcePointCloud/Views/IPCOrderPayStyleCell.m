//
//  IPCOrderPayStyleCell.m
//  IcePointCloud
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOrderPayStyleCell.h"

typedef void(^UpdateBlock)();

@interface IPCOrderPayStyleCell()

@property (nonatomic, copy) UpdateBlock updateBlock;

@end

@implementation IPCOrderPayStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateUIWithUpdate:(void (^)())update
{
    self.updateBlock = update;
    [self unSelectAllButton];
    
    switch ([IPCPayOrderMode sharedManager].payStyle) {
        case IPCPayStyleTypeWechat:
            [self.wechatButton setSelected:YES];
            break;
        case IPCPayStyleTypeAlipay:
            [self.alipayButton setSelected:YES];
            break;
        case IPCPayStyleTypeCash:
            [self.cashButton setSelected:YES];
            break;
        case IPCPayStyleTypeCard:
            [self.cardButton setSelected:YES];
            break;
        default:
            break;
    }
}

- (void)unSelectAllButton{
    [self.wechatButton setSelected:NO];
    [self.alipayButton setSelected:NO];
    [self.cashButton setSelected:NO];
    [self.cardButton setSelected:NO];
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
