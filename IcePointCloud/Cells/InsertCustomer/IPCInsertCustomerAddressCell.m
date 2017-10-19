//
//  IPCInsertCustomerAddressCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/10.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCInsertCustomerAddressCell.h"

@implementation IPCInsertCustomerAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    __weak typeof(self) weakSelf = self;
    
    self.addressView = [[IPCAddressView alloc]initWithFrame:CGRectMake(15, 10, self.jk_width-15, 80) Update:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [IPCInsertCustomer instance].contactorName = strongSelf.addressView.contacterTextField.text;
        [IPCInsertCustomer instance].contactorPhone = strongSelf.addressView.phoneTextField.text;
        [IPCInsertCustomer instance].contactorAddress = strongSelf.addressView.addressTextField.text;
        if (strongSelf.addressView.maleButton.selected) {
            [IPCInsertCustomer instance].contactorGenger = @"MALE";
        }else{
            [IPCInsertCustomer instance].contactorGenger = @"FEMALE";
        }
    }];
    [self.contentView addSubview:self.addressView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self updateInsertAddressUI];
}


- (void)updateInsertAddressUI
{
    if ([IPCInsertCustomer instance].contactorName.length) {
        [self.addressView.contacterTextField setText:[IPCInsertCustomer instance].contactorName];
    }
    if ([IPCInsertCustomer instance].contactorPhone.length) {
        [self.addressView.phoneTextField setText:[IPCInsertCustomer instance].contactorPhone];
    }
    if ([IPCInsertCustomer instance].contactorAddress.length) {
        [self.addressView.addressTextField setText:[IPCInsertCustomer instance].contactorAddress];
    }
    if ([IPCInsertCustomer instance].contactorGenger.length) {
        if ([[IPCInsertCustomer instance].contactorGenger isEqualToString:@"MALE"]) {
            [self.addressView.maleButton setSelected:YES];
            [self.addressView.femaleButton setSelected:NO];
        }else{
            [self.addressView.maleButton setSelected:NO];
            [self.addressView.femaleButton setSelected:YES];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
