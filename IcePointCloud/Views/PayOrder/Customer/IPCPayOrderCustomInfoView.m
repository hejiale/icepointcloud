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
@property (weak, nonatomic) IBOutlet UILabel *memberLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *encryptedPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *growthValueLabel;
@property (weak, nonatomic) IBOutlet UIView *memberIdentifyView;
@property (weak, nonatomic) IBOutlet UIView *memberRightView;
@property (weak, nonatomic) IBOutlet UILabel *memberIdentityLabel;


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



#pragma mark //Clicked Events
- (IBAction)editCustomerInfoAction:(id)sender
{
    
}

- (void)updateCustomerInfo
{
    IPCDetailCustomer * customer = [IPCPayOrderCurrentCustomer sharedManager].currentCustomer;
    
    [self.customerNameLabel setText:customer.customerName];
    [self.ageLabel setText:customer.age];
    [self.phoneLabel setText:customer.customerPhone];
    [self.sexLabel setText:[IPCCommon formatGender:customer.gender]];
    [self.birthdayLabel setText:customer.birthday];
    [self.memberIdentityLabel setText:(customer.memberFlag ? @"会员" : @"非会员")];
    
    if (customer.memberFlag) {
        [self showMemberInfoView];
        [self.pointLabel setText:[NSString stringWithFormat:@"%d",customer.integral]];
        [self.memberLevelLabel setText:customer.memberLevel];
        [self.growthValueLabel setText:customer.membergrowth];
        [self.encryptedPhoneLabel setText:customer.memberPhone];
        [self.discountLabel setText:[NSString stringWithFormat:@"%.f%%%",customer.discount*10]];
        [self.balanceLabel setText:[NSString stringWithFormat:@"%.f",customer.balance]];
    }else{
        [self hideMemberInfoView];
    }
}

- (void)showMemberInfoView
{
    [self.memberRightView setHidden:NO];
    [self.memberIdentifyView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)obj;
            if (label.tag > 0) {
                [label setHidden:NO];
            }
        }
    }];
}

- (void)hideMemberInfoView
{
    [self.memberRightView setHidden:YES];
    [self.memberIdentifyView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)obj;
            if (label.tag > 0) {
                [label setHidden:YES];
            }
        }
    }];
}


@end
