//
//  ShoppingCustomerCell.m
//  IcePointCloud
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPayOrderCustomerCell.h"

@implementation IPCPayOrderCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.mainView addSubview:self.userPhotoImageView];
    [self.userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.mas_left).with.offset(40);
        make.top.equalTo(self.mainView.mas_top).with.offset(64);
        make.width.mas_equalTo(139);
        make.height.mas_equalTo(194);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark //Set UI
- (UIImageView *)userPhotoImageView{
    if (!_userPhotoImageView) {
        _userPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_userPhotoImageView zy_cornerRadiusAdvance:15.f rectCornerType:UIRectCornerAllCorners];
    }
    return _userPhotoImageView;
}

- (void)setCurrentCustomer:(IPCDetailCustomer *)currentCustomer{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer) {
        [self.userNameLabel setText:_currentCustomer.customerName];
        [self.phoneLabel setText:_currentCustomer.customerPhone];
        [self.mailLabel setText:_currentCustomer.email];
     
        NSString * gender = [IPCCommon formatGender:_currentCustomer.contactorGengerString];
        
        if ([gender isEqualToString:@"男"] || [gender isEqualToString:@"未设置"]) {
            [self.userPhotoImageView setImageWithURL:[NSURL URLWithString:_currentCustomer.photo_url] placeholder:[UIImage imageNamed:@"icon_male"]];
        }else if ([gender isEqualToString:@"女"]){
            [self.userPhotoImageView setImageWithURL:[NSURL URLWithString:_currentCustomer.photo_url] placeholder:[UIImage imageNamed:@"icon_female"]];
        }
    }
}


@end
