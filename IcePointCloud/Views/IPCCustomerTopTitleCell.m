//
//  UserBaseTopTitleCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerTopTitleCell.h"

@interface IPCCustomerTopTitleCell()


@end

@implementation IPCCustomerTopTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.titleButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IPCImageTextButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [IPCImageTextButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setFrame:CGRectMake(40, 32, 0, 20)];
        [_titleButton setBackgroundColor:[UIColor clearColor]];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleButton.titleLabel setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightThin]];
        [_titleButton addTarget:self action:@selector(insertAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (void)setButtonTitle:(NSString *)title IsShow:(BOOL)isShow
{
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    
    CGFloat width = [title jk_widthWithFont:self.titleButton.titleLabel.font constrainedToHeight:self.titleButton.jk_height];
    self.titleButton.jk_width = width + 18 + (isShow ? 18 : 0);
    
    if (isShow){
        [self.titleButton setImage:[UIImage imageNamed:@"icon_insert-1"] forState:UIControlStateNormal];
        [self.titleButton setImgTextDistance:20];
        [self.titleButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft];
    }
}

- (void)insertAction:(id)sender {
}


@end
