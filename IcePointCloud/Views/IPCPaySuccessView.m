//
//  IPCPaySuccessView.m
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPaySuccessView.h"


@interface IPCPaySuccessView()

@property (weak, nonatomic) IBOutlet UIView         *mainOrderPopoverView;
@property (weak, nonatomic) IBOutlet UIImageView *scanCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel        *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel        *orderPriceLabel;
@property (copy,  nonatomic) void(^DismissBlock)();

@end

@implementation IPCPaySuccessView

- (instancetype)initWithFrame:(CGRect)frame OrderInfo:(IPCOrder *)orderInfo Dismiss:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPaySuccessView" owner:self];
        [self addSubview:view];
        
        [self.mainOrderPopoverView addBorder:5 Width:0];
        self.DismissBlock = dismiss;
        
        [self.orderCodeLabel setText:[NSString stringWithFormat:@"订单编号: %@",orderInfo.orderNumber]];
        [self.scanCodeImageView setImageURL:[IPCPayOrderMode sharedManager].payStyle == IPCPayStyleTypeAlipay?  [NSURL URLWithString:orderInfo.alipayPhotoURL]:[NSURL URLWithString:orderInfo.wechatURL]];
    
        NSString * priceStr = [NSString stringWithFormat:@"￥%.f",orderInfo.totalPrice];
        [self.orderPriceLabel setAttributedText:[IPCCustomUI subStringWithText:priceStr BeginRang:1 Rang:priceStr.length - 1 Font:[UIFont systemFontOfSize:18 weight:UIFontWeightThin] Color:COLOR_RGB_BLUE]];
    }
    return self;
}


- (IBAction)closePopoverOrderBgViewAction:(id)sender {
    if (self.DismissBlock) {
        self.DismissBlock();
    }
}

@end
