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

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if ([IPCCustomOrderDetailList instance].orderInfo) {
        [self setCustomer:[IPCCustomOrderDetailList instance].orderInfo];
    }
}

- (void)setAddressMode:(IPCCustomerAddressMode *)addressMode{
    _addressMode = addressMode;

    if (_addressMode) {
        [self.addressContentView setHidden:NO];
        
        CGFloat width = [_addressMode.contactName jk_sizeWithFont:self.addressLabel.font constrainedToHeight:self.addressLabel.jk_height].width;
        self.contactNameWidth.constant = width;
        
        [self.addressLabel setText:_addressMode.detailAddress];
        [self.contactNameLabel setText:_addressMode.contactName];
        [self.genderLabel setText:[IPCCommon formatGender:_addressMode.gender]];
        [self.contactPhoneLabel setText:_addressMode.phone];
    }
}

- (void)setCustomer:(IPCCustomerOrderInfo *)customer
{
    if (customer) {
        if ([customer isEmptyAddress]) {
            [self.noAddressLabel setHidden:NO];
        }else{
            [self.addressContentView setHidden:NO];
            [self.defaultButton setHidden:YES];
            
            CGFloat width = [customer.contactorName jk_sizeWithFont:self.contactNameLabel.font constrainedToHeight:self.contactNameLabel.jk_height].width;
            self.contactNameWidth.constant = width;
            
            [self.contactNameLabel setText:customer.contactorName];
            [self.contactPhoneLabel setText:customer.contactorPhone];
            [self.genderLabel setText:[IPCCommon formatGender:customer.contactorGender]];
            [self.addressLabel setText:customer.contactorAddress];
        }
    }
}

- (IBAction)setDefaultAction:(id)sender {
  
}

@end
