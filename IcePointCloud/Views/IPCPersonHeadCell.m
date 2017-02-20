//
//  PersonHeadCell.m
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPersonHeadCell.h"

@implementation IPCPersonHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(43);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(65);
    }];
}

- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_headImageView zy_cornerRadiusAdvance:65/2 rectCornerType:UIRectCornerAllCorners];
    }
    return _headImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
