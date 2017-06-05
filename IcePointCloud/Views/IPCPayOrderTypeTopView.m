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
    
    [self addSignleCorner:UIRectCornerTopLeft | UIRectCornerTopRight Size:5];
    [self.payTotalPriceLabel setTextColor:COLOR_RGB_RED];
    [self.payStyleContentView addBorder:3 Width:0.5];
    
//    [self.payTotalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",[[IPCPayOrderMode sharedManager] waitPayAmount]]];
    [self.storeValueLabel setText:[NSString stringWithFormat:@"储值余额(可用余额￥%.2f)",[IPCPayOrderMode sharedManager].balanceAmount]];
    
//    [IPCPayOrderMode sharedManager].payTypeAmount = [[IPCPayOrderMode sharedManager] waitPayAmount];
    NSString * payStyleText = [NSString stringWithFormat:@"支付￥%.2f",[IPCPayOrderMode sharedManager].payTypeAmount];
    [self.paysStyleAmountLabel setAttributedText:[IPCCustomUI subStringWithText:payStyleText BeginRang:2 Rang:payStyleText.length - 2 Font:[UIFont systemFontOfSize:14 weight:UIFontWeightThin] Color:COLOR_RGB_RED]];
    [self reloadUI];
}


#pragma mark //Clicked Events
- (IBAction)closeAction:(id)sender {
    
}


- (IBAction)selectStoreValueAction:(UIButton *)sender
{
//    if ([[IPCPayOrderMode sharedManager].otherPayTypeArray count] > 0 && !sender.selected && ([IPCPayOrderMode sharedManager].balanceAmount >= [[IPCPayOrderMode sharedManager] waitPayAmount] - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount]))
//    {
//        __weak typeof(self) weakSelf = self;
//        [IPCCustomUI showAlert:@"友情提示" Message:@"您确定选择使用储值余额支付并清空其它支付方式吗?" Owner:[UIApplication sharedApplication].keyWindow.rootViewController Done:^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [[IPCPayOrderMode sharedManager].otherPayTypeArray removeAllObjects];
//            
//            if (strongSelf.UpdateBlock) {
//                strongSelf.UpdateBlock();
//            }
//            [strongSelf chooseStoreValue:sender];
//        }];
//    }else{
//        [self chooseStoreValue:sender];
//    }
    
}


- (void)chooseStoreValue:(UIButton *)button{
    [button setSelected:!button.selected];
    [IPCPayOrderMode sharedManager].isSelectStoreValue = button.selected;
    
    
    [self reloadUI];
}

- (IBAction)selectNormalPayTypeAction:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    [IPCPayOrderMode sharedManager].isSelectPayType = sender.selected;
    
    if ([IPCPayOrderMode sharedManager].isSelectPayType)
    {
//        if ([IPCPayOrderMode sharedManager].isSelectStoreValue && [IPCPayOrderMode sharedManager].usedBalanceAmount > [[IPCPayOrderMode sharedManager] waitPayAmount] - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount])
//        {
//            [IPCPayOrderMode sharedManager].isSelectStoreValue = NO;
//            [IPCPayOrderMode sharedManager].usedBalanceAmount = 0;
//            [IPCPayOrderMode sharedManager].payTypeAmount = [[IPCPayOrderMode sharedManager]waitPayAmount] - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount];
//        }else{
//            if ([[IPCPayOrderMode sharedManager] waitPayAmount] - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount]  - [IPCPayOrderMode sharedManager].payTypeAmount > 0) {
//                [IPCPayOrderMode sharedManager].isSelectStoreValue = YES;
//            }else{
//                [IPCPayOrderMode sharedManager].isSelectStoreValue = NO;
//            }
//        }
        [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeCash;
        //待支付金额
//        [IPCPayOrderMode sharedManager].payTypeAmount = [[IPCPayOrderMode sharedManager] waitPayAmount] - [IPCPayOrderMode sharedManager].usedBalanceAmount - [[IPCPayOrderMode sharedManager] totalOtherPayTypeAmount];
        [self reloadUI];
    }else{
        [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeNone;
        [IPCPayOrderMode sharedManager].payTypeAmount = 0;
        [self reloadUI];
    }
}



- (IBAction)selectPayTypeAction:(UIButton *)sender {
    if (![IPCPayOrderMode sharedManager].isSelectPayType)return;

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
    NSString * usedBalanceText = [NSString stringWithFormat:@"支付￥%.2f",[IPCPayOrderMode sharedManager].usedBalanceAmount];
    [self.customerStoreValueLabel setAttributedText:[IPCCustomUI subStringWithText:usedBalanceText BeginRang:2 Rang:usedBalanceText.length - 2 Font:[UIFont systemFontOfSize:14 weight:UIFontWeightThin] Color:COLOR_RGB_RED]];
    
    NSString * payStyleText = [NSString stringWithFormat:@"支付￥%.2f",[IPCPayOrderMode sharedManager].payTypeAmount];
    [self.paysStyleAmountLabel setAttributedText:[IPCCustomUI subStringWithText:payStyleText BeginRang:2 Rang:payStyleText.length - 2 Font:[UIFont systemFontOfSize:14 weight:UIFontWeightThin] Color:COLOR_RGB_RED]];
    
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
    }else{
        [self.selectPayStyleButton setSelected:NO];
    }
    [self reloadPayStyleView];
}


- (void)reloadPayStyleView{
    if ([IPCPayOrderMode sharedManager].payStyle == IPCPayStyleTypeNone) {
        [self resetPayStyleStatus];
        [self.paysStyleAmountLabel setHidden:YES];
    }
    if ([IPCPayOrderMode sharedManager].payStyle == IPCPayStyleTypeCash) {
        [self.selectCashButton setSelected:YES];
        [self.paysStyleAmountLabel setHidden:NO];
        self.payStyleAmountTop.constant = 5;
    }
    if ([IPCPayOrderMode sharedManager].payStyle == IPCPayStyleTypeCard) {
        [self.selectCardButton setSelected:YES];
        [self.paysStyleAmountLabel setHidden:NO];
        self.payStyleAmountTop.constant = self.selectCardButton.tag * self.selectCardButton.jk_height + 5;
    }
    if ([IPCPayOrderMode sharedManager].payStyle == IPCPayStyleTypeWechat) {
        [self.selectWeixinButton setSelected:YES];
        [self.paysStyleAmountLabel setHidden:NO];
        self.payStyleAmountTop.constant = self.selectWeixinButton.tag * self.selectWeixinButton.jk_height + 5;
    }
    if ([IPCPayOrderMode sharedManager].payStyle == IPCPayStyleTypeAlipay) {
        [self.selectAlipayButton setSelected:YES];
        [self.paysStyleAmountLabel setHidden:NO];
        self.payStyleAmountTop.constant = self.selectAlipayButton.tag * self.selectAlipayButton.jk_height + 5;
    }
}


@end
