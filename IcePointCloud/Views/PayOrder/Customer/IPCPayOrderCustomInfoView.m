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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customerNameWidth;
@property (weak, nonatomic) IBOutlet UIButton *upgradeMemberButton;
@property (weak, nonatomic) IBOutlet UIButton *memberValiteStatus;
@property (weak, nonatomic) IBOutlet UIButton *forcedButton;
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
        
        [self.upgradeMemberButton addBorder:13 Width:1 Color:COLOR_RGB_BLUE];
        [self.forcedButton addBorder:13 Width:1 Color:COLOR_RGB_BLUE];
    }
    return self;
}

#pragma mark //Clicked Events
- (IBAction)editCustomerInfoAction:(id)sender
{
    
}

- (IBAction)upgradeMemberAction:(id)sender
{
    
}

- (IBAction)forcedMemberAction:(id)sender
{
    
}


- (IBAction)selectMemberCardAction:(id)sender {
}

- (void)updateCustomerInfo
{
    IPCDetailCustomer * customer = [IPCPayOrderCurrentCustomer sharedManager].currentCustomer;
    
    CGFloat width = [customer.customerName jk_sizeWithFont:self.customerNameLabel.font constrainedToHeight:self.customerNameLabel.jk_height].width;
    self.customerNameWidth.constant = width;
    
    [self.customerNameLabel setText:customer.customerName];
    [self.ageLabel setText:customer.age];
    [self.phoneLabel setText:customer.customerPhone];
    [self.sexLabel setText:[IPCCommon formatGender:customer.gender]];
    [self.birthdayLabel setText:customer.birthday];
    [self.memberIdentityLabel setText:(customer.memberLevel ? @"会员" : @"非会员")];
    [self.totalPayLabel setText:[NSString stringWithFormat:@"%.2f", customer.consumptionAmount]];
    
    if (customer.memberLevel) {
        [self.upgradeMemberButton setHidden:YES];
        [self.pointLabel setText:[NSString stringWithFormat:@"%d",customer.integral]];
        [self.memberLevelLabel setText:customer.memberLevel];
        [self.growthValueLabel setText:customer.membergrowth];
        [self.encryptedPhoneLabel setText:customer.memberPhone];
        [self.discountLabel setText:[NSString stringWithFormat:@"%.f%%%",customer.discount*10]];
        [self.balanceLabel setText:[NSString stringWithFormat:@"%.2f",customer.balance]];
    }else{
        [self.upgradeMemberButton setHidden:NO];
    }

    if (customer.memberLevel && ![IPCAppManager sharedManager].companyCofig.isCheckMember) {
        if ([IPCPayOrderManager sharedManager].isValiateMember){
            [self.forcedButton setHidden:YES];
            [self.memberValiteStatus setHidden:NO];
            [self.memberValiteStatus setSelected:YES];
        }else{
            if ([IPCAppManager sharedManager].authList.forceVerifyMember) {
                [self.forcedButton setHidden:NO];
                [self.memberValiteStatus setHidden:YES];
            }else{
                [self.forcedButton setHidden:YES];
                [self.memberValiteStatus setHidden:NO];
                [self.memberValiteStatus setSelected:NO];
            }
        }
    }else{
        [self.memberValiteStatus setHidden:YES];
        [self.forcedButton setHidden:YES];
    }
}

@end
