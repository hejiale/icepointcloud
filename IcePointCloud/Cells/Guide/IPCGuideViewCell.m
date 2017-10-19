//
//  HcdGuideViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCGuideViewCell.h"

@interface IPCGuideViewCell()

@end

@implementation IPCGuideViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.layer.masksToBounds = YES;
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.button];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
    }];
}


- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setFrame:CGRectMake(0, 0, 300, 44)];
        [_button setTitleColor:COLOR_RGB_BLUE forState:UIControlStateNormal];
        [_button.layer setCornerRadius:22];
        [_button.layer setBorderWidth:1.0f];
        _button.layer.borderColor = [COLOR_RGB_BLUE CGColor];
        [_button setBackgroundColor:[UIColor clearColor]];
        [_button setTitle:@"立即进入" forState:UIControlStateNormal];
        [_button setCenter:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 180)];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:22 weight:UIFontWeightThin]];
        [_button setHidden:YES];
    }
    return _button;
}

@end
