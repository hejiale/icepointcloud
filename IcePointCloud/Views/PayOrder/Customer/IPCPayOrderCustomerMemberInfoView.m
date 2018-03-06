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
@property (weak, nonatomic) IBOutlet UIView *memberLevelView;
@property (weak, nonatomic) IBOutlet UILabel *memberLevelLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberLevelWidth;

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

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.memberLevelView addBorder:3 Width:0 Color:nil];
}

- (void)updateMemberCardInfo:(IPCCustomerMode *)customer
{
    CGFloat width = [customer.memberLevel jk_sizeWithFont:self.memberLevelLabel.font constrainedToHeight:self.memberLevelLabel.jk_height].width;
    self.memberLevelWidth.constant = width + 10;
    
    [self.pointLabel setText:[NSString stringWithFormat:@"%.f", customer.integral]];
    [self.memberLevelLabel setText:customer.memberLevel];
    [self.growthValueLabel setText:customer.membergrowth];
    [self.encryptedPhoneLabel setText:customer.memberPhone];
    [self.discountLabel setText:[NSString stringWithFormat:@"%.f%%%", [customer useDiscount]]];
    [self.balanceLabel setText:[NSString stringWithFormat:@"￥%.2f", customer.balance]];
}


@end
