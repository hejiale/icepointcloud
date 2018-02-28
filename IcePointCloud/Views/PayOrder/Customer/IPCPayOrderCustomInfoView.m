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

- (void)updateCustomerInfo:(IPCDetailCustomer *)customer
{
    if (customer) {
        [self.customerNameLabel setText:customer.customerName];
        [self.ageLabel setText:customer.age];
        [self.phoneLabel setText:customer.customerPhone];
        [self.sexLabel setText:[IPCCommon formatGender:customer.gender]];
        [self.birthdayLabel setText:customer.birthday];
        [self.totalPayLabel setText:[NSString stringWithFormat:@"￥%.2f", customer.consumptionAmount]];
    }
}

@end
