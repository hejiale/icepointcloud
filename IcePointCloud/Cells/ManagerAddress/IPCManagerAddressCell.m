//
//  IPCEditAddressCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCManagerAddressCell.h"

@implementation IPCManagerAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddressMode:(IPCCustomerAddressMode *)addressMode{
    _addressMode = addressMode;
    
    if (_addressMode)
    {
        CGFloat width = [_addressMode.contactorName jk_sizeWithFont:self.addressLabel.font constrainedToHeight:self.addressLabel.jk_height].width;
        self.contactNameWidth.constant = width;
        
        if (_addressMode.detailAddress.length) {
            [self.addressLabel setText:_addressMode.detailAddress];
        }
        
        if (_addressMode.contactorAddress.length) {
            [self.addressLabel setText:_addressMode.contactorAddress];
        }
        
        if (_addressMode.gender.length) {
            [self.genderLabel setText:[IPCCommon formatGender:_addressMode.gender]];
        }
        
        if (_addressMode.contactorGender.length) {
            [self.genderLabel setText:[IPCCommon formatGender:_addressMode.contactorGender]];
        }
        
        [self.contactNameLabel setText:_addressMode.contactorName];
        [self.contactPhoneLabel setText:_addressMode.contactorPhone];
    }
}


- (IBAction)setDefaultAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setDefaultAddressForCell:)]) {
        [self.delegate setDefaultAddressForCell:self];
    }
}

@end
