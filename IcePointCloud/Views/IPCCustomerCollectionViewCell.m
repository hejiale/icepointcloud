//
//  CustomerCollectionViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/20.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerCollectionViewCell.h"

@implementation IPCCustomerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self addBorder:5 Width:0.5];
    [self addSubview:self.customImageView];
    [self.customImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
}

- (UIImageView *)customImageView{
    if (!_customImageView) {
        _customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_customImageView zy_cornerRadiusAdvance:50.f rectCornerType:UIRectCornerAllCorners];
    }
    return _customImageView;
}

- (void)setCurrentCustomer:(IPCCustomerMode *)currentCustomer{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer) {
        [self.customerNameLabel setText:[NSString stringWithFormat:@"姓名: %@",_currentCustomer.customerName]];
        [self.customerPhoneLabel setText:[NSString stringWithFormat:@"电话: %@",_currentCustomer.customerPhone]];
        
        if ([_currentCustomer.gender isEqualToString:@"MALE"] || [_currentCustomer.gender isEqualToString:@"NOTSET"]) {
            [self.customImageView setImageWithURL:[NSURL URLWithString:_currentCustomer.photo_url] placeholder:[UIImage imageNamed:@"icon_male"]];
        }else if ([_currentCustomer.gender isEqualToString:@"FEMALE"]){
            [self.customImageView setImageWithURL:[NSURL URLWithString:_currentCustomer.photo_url] placeholder:[UIImage imageNamed:@"icon_female"]];
        }
    }
}

@end
