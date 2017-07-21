//
//  IPCPayOrderCustomerCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderCustomerCell.h"

@implementation IPCPayOrderCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.imageContentView addSubview:self.headImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:self.imageContentView.bounds];
        [_headImageView zy_cornerRadiusAdvance:self.imageContentView.jk_height/2  rectCornerType:UIRectCornerAllCorners];
    }
    return _headImageView;
}

- (void)setCurrentCustomer:(IPCDetailCustomer *)currentCustomer
{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer)
    {
        if (_currentCustomer.photo_url.length) {
            [self.headImageView setImageURL:[NSURL URLWithString:_currentCustomer.photo_url]];
        }
        
        [self.customerNameLabel setText:_currentCustomer.customerName];
        [self.phoneLabel setText:_currentCustomer.customerPhone];
        [self.memberLevlLabel setText:_currentCustomer.memberLevel];
        [self.pointLabel setText:[NSString stringWithFormat:@"%d",_currentCustomer.integral]];
    }
}


@end
