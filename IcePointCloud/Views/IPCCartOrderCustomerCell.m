//
//  ShoppingCustomerCell.m
//  IcePointCloud
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCartOrderCustomerCell.h"

@implementation IPCCartOrderCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.mainView addSubview:self.userPhotoImageView];
    [self.userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.mas_left).with.offset(40);
        make.top.equalTo(self.mainView.mas_top).with.offset(64);
        make.width.mas_equalTo(139);
        make.height.mas_equalTo(192);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)closeAction:(id)sender {
    [[NSNotificationCenter defaultCenter] jk_postNotificationOnMainThreadName:@"IPCCloseOrderChange" object:nil];
}


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
        [self.userNameTextField setText:_currentCustomer.customerName];
        [self.phoneTextField setText:_currentCustomer.customerPhone];
        [self.birthdayTextField setText:_currentCustomer.birthday];
        [self.ageTextFiled setText:_currentCustomer.age];
        [self.mailTextField setText:_currentCustomer.email];
        [self.genderTextField setText:[IPCCommon formatGender:_currentCustomer.contactorGengerString]];
        
        if ([self.genderTextField.text isEqualToString:@"男"] || [self.genderTextField.text isEqualToString:@"未设置"]) {
            [self.userPhotoImageView setImageWithURL:[NSURL URLWithString:_currentCustomer.photo_url] placeholder:[UIImage imageNamed:@"icon_male@2x"]];
        }else if ([self.genderTextField.text isEqualToString:@"女"]){
            [self.userPhotoImageView setImageWithURL:[NSURL URLWithString:_currentCustomer.photo_url] placeholder:[UIImage imageNamed:@"icon_female@2x"]];
        }
    }
}


@end
