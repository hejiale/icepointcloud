//
//  IPCPayOrderCustomInfoView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderCustomInfoView.h"

@interface IPCPayOrderCustomInfoView()

@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerTypeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidth;
@property (weak, nonatomic) IBOutlet UIView *searchOrderContentView;


@end

@implementation IPCPayOrderCustomInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderCustomInfoView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    
    [self.searchOrderContentView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakSelf searchCustomerOrderList];
    }];
}

- (void)updateCustomerInfo:(IPCCustomerMode *)customer isShowOrder:(BOOL)isShow
{
    if (customer) {
        [self.customerNameLabel setText:customer.customerName];
        [self.ageLabel setText:customer.age ? [NSString stringWithFormat:@"%@岁",customer.age] : @"0岁"];
        [self.phoneLabel setText:customer.customerPhone];
        [self.sexLabel setText:[IPCCommon formatGender:customer.gender]];
        [self.birthdayLabel setText:customer.birthday];
        [self.totalPayLabel setText:[NSString stringWithFormat:@"￥%.2f", customer.consumptionAmount]];
        [self.customerTypeLabel setText:customer.customerType];
        
        CGFloat width = [customer.customerName jk_sizeWithFont:self.customerNameLabel.font constrainedToHeight:self.customerNameLabel.jk_height].width;
        self.nameWidth.constant = MIN(160, MAX(width, 70));
        
        if (!isShow) {
            [self.searchOrderContentView setHidden:YES];
        }
    }
}

- (void)searchCustomerOrderList
{
    
}


@end
