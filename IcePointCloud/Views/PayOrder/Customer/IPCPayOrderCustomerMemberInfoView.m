//
//  IPCPayOrderCustomerMemberInfoView.m
//  IcePointCloud
//
//  Created by gerry on 2018/2/27.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderCustomerMemberInfoView.h"

@interface IPCPayOrderCustomerMemberInfoView()

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *encryptedPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *growthValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLevelLabel;


@end



@implementation IPCPayOrderCustomerMemberInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderCustomerMemberInfoView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}


- (void)updateCustomerInfo
{
    IPCDetailCustomer * customer = [IPCPayOrderCurrentCustomer sharedManager].currentCustomer;
    
    [self.pointLabel setText:[NSString stringWithFormat:@"%.f", [customer userIntegral]]];
    [self.memberLevelLabel setText:[customer useMemberLevel]];
    [self.growthValueLabel setText:[customer useMemberGrowth]];
    [self.encryptedPhoneLabel setText:[customer useMemberPhone]];
    [self.discountLabel setText:[NSString stringWithFormat:@"%.f%%%", [customer useDiscount]]];
    [self.balanceLabel setText:[NSString stringWithFormat:@"￥%.2f", [customer useBalance]]];
}


@end
