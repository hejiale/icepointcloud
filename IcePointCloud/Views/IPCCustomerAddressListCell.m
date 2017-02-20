//
//  CustomerAddressListCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerAddressListCell.h"

@interface IPCCustomerAddressListCell()



@end

@implementation IPCCustomerAddressListCell

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

    if (_addressMode) {
        [self.addressLabel setText:[NSString stringWithFormat:@"收货地址:%@",addressMode.detailAddress]];
        [self.contactNameLabel setText:[NSString stringWithFormat:@"收货人:%@",addressMode.contactName]];
        [self.contactPhoneLabel setText:[NSString stringWithFormat:@"联系电话: %@",addressMode.phone]];
    }
}

- (IBAction)chooseAction:(id)sender {
  
}

@end
