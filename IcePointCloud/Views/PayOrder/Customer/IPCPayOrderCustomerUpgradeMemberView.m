//
//  IPCPayOrderCustomerUpgradeMemberView.m
//  IcePointCloud
//
//  Created by gerry on 2018/2/27.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderCustomerUpgradeMemberView.h"

@interface IPCPayOrderCustomerUpgradeMemberView()

@property (weak, nonatomic) IBOutlet UIButton *upgradeMemberButton;


@end

@implementation IPCPayOrderCustomerUpgradeMemberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderCustomerUpgradeMemberView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.upgradeMemberButton addBorder:18 Width:1 Color:COLOR_RGB_BLUE];
    }
    return self;
}

- (IBAction)upgradeMemberAction:(id)sender {
}


@end
