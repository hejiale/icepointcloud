//
//  CustomerAddressListCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerAddressCell.h"


@implementation IPCCustomerAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setAddressMode:(IPCCustomerAddressMode *)addressMode{
    _addressMode = addressMode;

    if (_addressMode) {
        [self.addressContentView setHidden:NO];
        
        CGFloat width = [_addressMode.contactorName jk_sizeWithFont:self.addressLabel.font constrainedToHeight:self.addressLabel.jk_height].width;
        self.contactNameWidth.constant = width;
        
        if (_addressMode.detailAddress.length) {
            [self.addressLabel setText:_addressMode.detailAddress];
        }
        
        if (_addressMode.contactorAddress.length) {
            [self.addressLabel setText:_addressMode.contactorAddress];
        }
        
        [self.contactNameLabel setText:_addressMode.contactorName];
        
        if (_addressMode.gender.length) {
            [self.genderLabel setText:[IPCCommon formatGender:_addressMode.gender]];
        }
        
        if (_addressMode.contactorGender.length) {
            [self.genderLabel setText:[IPCCommon formatGender:_addressMode.contactorGender]];
        }
        
        [self.contactPhoneLabel setText:_addressMode.contactorPhone];
    }
}

@end
