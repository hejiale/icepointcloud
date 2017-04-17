//
//  IPCPayOrderTypeTopView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderTypeTopView.h"

@interface IPCPayOrderTypeTopView()

@property (weak, nonatomic) IBOutlet UIView *payStyleContentView;
@property (weak, nonatomic) IBOutlet UILabel *payTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectStoreValueButton;
@property (weak, nonatomic) IBOutlet UILabel *storeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerStoreValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectPayStyleButton;
@property (weak, nonatomic) IBOutlet UILabel * paysStyleAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectCashButton;
@property (weak, nonatomic) IBOutlet UIButton *selectAlipayButton;
@property (weak, nonatomic) IBOutlet UIButton *selectWeixinButton;
@property (weak, nonatomic) IBOutlet UIButton *selectCardButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payStyleAmountTop;
@property (copy, nonatomic) void(^UpdateBlock)(void);

@end

@implementation IPCPayOrderTypeTopView

- (instancetype)initWithFrame:(CGRect)frame Update:(void(^)())update
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderTypeTopView" owner:self];
        [view setFrame:frame];
        [self addSubview:view];
        
        self.UpdateBlock = update;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self.payStyleContentView addBorder:1 Width:1];
    [self.payTotalPriceLabel setTextColor:COLOR_RGB_RED];
    [self.paysStyleAmountLabel setTextColor:COLOR_RGB_RED];
    [self.customerStoreValueLabel setTextColor:COLOR_RGB_RED];
    
    [self.payTotalPriceLabel setText:[NSString stringWithFormat:@"支付￥%.2f",[[IPCPayOrderMode sharedManager] waitPayAmount]]];
    [self.storeValueLabel setText:[NSString stringWithFormat:@"储值余额(可用余额￥%.2f)",[IPCPayOrderMode sharedManager].balanceAmount]];
    [self.paysStyleAmountLabel setText:[NSString stringWithFormat:@"支付￥%.2f",[[IPCPayOrderMode sharedManager] waitPayAmount]]];
}


#pragma mark //Clicked Events
- (IBAction)closeAction:(id)sender {
    
}


- (IBAction)selectStoreValueAction:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    [IPCPayOrderMode sharedManager].isSelectStoreValue = sender.selected;
    
    if ([[IPCPayOrderMode sharedManager].otherPayTypeArray count] > 0) {
        [[IPCPayOrderMode sharedManager].otherPayTypeArray removeAllObjects];
        
        if (self.UpdateBlock) {
            self.UpdateBlock();
        }
    }
    
    if ([IPCPayOrderMode sharedManager].isSelectStoreValue) {
        if ([IPCPayOrderMode sharedManager].balanceAmount >= [[IPCPayOrderMode sharedManager] waitPayAmount] - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount])
        {
            [IPCPayOrderMode sharedManager].usedBalanceAmount = [[IPCPayOrderMode sharedManager] waitPayAmount] - - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount];
            [IPCPayOrderMode sharedManager].isSelectPayType = NO;
        }else if([IPCPayOrderMode sharedManager].balanceAmount < [[IPCPayOrderMode sharedManager] waitPayAmount] - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount])
        {
            [IPCPayOrderMode sharedManager].usedBalanceAmount = [IPCPayOrderMode sharedManager].balanceAmount;
        }
    }else{
        [IPCPayOrderMode sharedManager].usedBalanceAmount = 0;
        [IPCPayOrderMode sharedManager].isSelectPayType = YES;
    }
    //待支付金额
    [IPCPayOrderMode sharedManager].payTypeAmount = [[IPCPayOrderMode sharedManager] waitPayAmount] - [IPCPayOrderMode sharedManager].usedBalanceAmount - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount];
    if ([IPCPayOrderMode sharedManager].payTypeAmount <= 0) {
        [IPCPayOrderMode sharedManager].payTypeAmount = 0;
    }
    [self reloadUI];
}

- (IBAction)selectNormalPayTypeAction:(UIButton *)sender {
    if (sender.selected)return;
    [sender setSelected:!sender.selected];
    
    if (sender.selected) {
        if ([IPCPayOrderMode sharedManager].isSelectStoreValue && [IPCPayOrderMode sharedManager].usedBalanceAmount >= [[IPCPayOrderMode sharedManager] waitPayAmount] - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount])
        {
            [IPCPayOrderMode sharedManager].isSelectStoreValue = NO;
            [IPCPayOrderMode sharedManager].usedBalanceAmount = 0;
            [IPCPayOrderMode sharedManager].payTypeAmount = [[IPCPayOrderMode sharedManager]waitPayAmount] - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount];
        }else{
            [IPCPayOrderMode sharedManager].isSelectStoreValue = YES;
        }
        [IPCPayOrderMode sharedManager].isSelectPayType = sender.selected;
        [self reloadUI];
    }
}



- (IBAction)selectPayTypeAction:(UIButton *)sender {
    [self resetPayStyleStatus];
    [sender setSelected:YES];
    self.payStyleAmountTop.constant = sender.tag * sender.jk_height + 5;
    
    switch (sender.tag) {
        case 0:
            [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeCash;
            [IPCPayOrderMode sharedManager].payStyleName = @"CASH";
            break;
        case 1:
            [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeAlipay;
            [IPCPayOrderMode sharedManager].payStyleName = @"ALIPAY";
            break;
        case 2:
            [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeWechat;
            [IPCPayOrderMode sharedManager].payStyleName = @"WECHAT";
            break;
        case 3:
            [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeCard;
            [IPCPayOrderMode sharedManager].payStyleName = @"CARD";
            break;
        default:
            break;
    }
}


- (void)resetPayStyleStatus{
    [self.selectCashButton setSelected:NO];
    [self.selectAlipayButton setSelected:NO];
    [self.selectWeixinButton setSelected:NO];
    [self.selectCardButton setSelected:NO];
}


- (void)reloadUI
{
    [self.customerStoreValueLabel setText:[NSString stringWithFormat:@"支付￥%.2f",[IPCPayOrderMode sharedManager].usedBalanceAmount]];
    [self.paysStyleAmountLabel setText:[NSString stringWithFormat:@"支付￥%.2f",[IPCPayOrderMode sharedManager].payTypeAmount]];
    
    if ([IPCPayOrderMode sharedManager].balanceAmount ==0 ) {
        [self.selectStoreValueButton setEnabled:NO];
    }else{
        [self.selectStoreValueButton setEnabled:YES];
    }
    
    if ([IPCPayOrderMode sharedManager].isSelectStoreValue) {
        [self.selectStoreValueButton setSelected:YES];
    }else{
        [self.selectStoreValueButton setSelected:NO];
    }
    if ([IPCPayOrderMode sharedManager].isSelectPayType) {
        [self.selectPayStyleButton setSelected:YES];
        [self.paysStyleAmountLabel setHidden:NO];
        [self.selectCashButton setSelected:YES];
        self.payStyleAmountTop.constant = 5;
    }else{
        [self.selectPayStyleButton setSelected:NO];
        [self resetPayStyleStatus];
        [self.paysStyleAmountLabel setHidden:YES];
    }
}



@end
