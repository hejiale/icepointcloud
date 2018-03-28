//
//  IPCPayOrderMemberCollectionViewCell.m
//  IcePointCloud
//
//  Created by gerry on 2018/2/27.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderMemberCollectionViewCell.h"

@implementation IPCPayOrderMemberCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCurrentCustomer:(IPCCustomerMode *)currentCustomer
{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer) {
        [self.encryptedPhoneLabel setText:_currentCustomer.memberPhone];
        
        if (_currentCustomer.memberLevel) {
            [self.memberLevelLabel setText:_currentCustomer.memberLevel];
        }
        
        if ([_currentCustomer.memberCustomerId integerValue] == [[IPCPayOrderManager sharedManager].currentMemberCustomerId integerValue] && [_currentCustomer.memberCustomerId integerValue] > 0)
        {
            [self.encryptedPhoneLabel setTextColor:COLOR_RGB_BLUE];
            [self.memberLevelLabel setTextColor:COLOR_RGB_BLUE];
            [self addBorder:0 Width:1 Color:COLOR_RGB_BLUE];
        }else{
            [self.encryptedPhoneLabel setTextColor:[UIColor jk_colorWithHexString:@"#888888"]];
            [self.memberLevelLabel setTextColor:[UIColor jk_colorWithHexString:@"#888888"]];
            [self addBorder:0 Width:0 Color:nil];
        }
    }
}

@end
