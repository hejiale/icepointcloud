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
    
    self.addressView = [[IPCAddressView alloc]initWithFrame:CGRectMake(15, 10, self.jk_width-15, 80)];
    [self.contentView addSubview:self.addressView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
