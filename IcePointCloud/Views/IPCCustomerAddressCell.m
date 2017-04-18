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
    [self.defaultButton setTitleColor:COLOR_RGB_BLUE forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddressMode:(IPCCustomerAddressMode *)addressMode{
    _addressMode = addressMode;

    if (_addressMode) {
        CGFloat width = [_addressMode.contactName jk_sizeWithFont:self.addressLabel.font constrainedToHeight:self.addressLabel.jk_height].width;
        self.contactNameWidth.constant = width;
        [self.addressLabel setText:_addressMode.detailAddress];
        [self.contactNameLabel setText:_addressMode.contactName];
        [self.genderLabel setText:[IPCCommon formatGender:_addressMode.gender]];
        [self.contactPhoneLabel setText:_addressMode.phone];
    }
}

- (IBAction)setDefaultAction:(id)sender {
  
}

@end
