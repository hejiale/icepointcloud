//
//  IPCEditOptometryCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCManagerOptometryCell.h"

@implementation IPCManagerOptometryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.defaultButton];
    [self.contentView bringSubviewToFront:self.defaultButton];
    [self.defaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark //Set UI
- (UIButton *)defaultButton{
    if (!_defaultButton) {
        _defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultButton setTitle:@"设为默认验光单" forState:UIControlStateNormal];
        [_defaultButton setTitle:@"默认验光单" forState:UIControlStateSelected];
        [_defaultButton setImage:[UIImage imageNamed:@"icon_undefault"] forState:UIControlStateNormal];
        [_defaultButton setImage:[UIImage imageNamed:@"icon_default"] forState:UIControlStateSelected];
        [_defaultButton setTitleColor:COLOR_RGB_BLUE forState:UIControlStateSelected];
        [_defaultButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_defaultButton.titleLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
        _defaultButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _defaultButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        [_defaultButton setBackgroundColor:[UIColor clearColor]];
        [_defaultButton addTarget:self action:@selector(setDefaultAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultButton;
}

- (void)setOptometryMode:(IPCOptometryMode *)optometryMode{
    _optometryMode = optometryMode;
    
    if (_optometryMode) {
        if (!self.optometryView) {
            self.optometryView = [[IPCMangerOptometryView alloc]initWithFrame:self.optometryContentView.bounds];
            [self.optometryView createUIWithOptometry:_optometryMode];
            [self.optometryContentView addSubview:self.optometryView];
            
            if (_optometryMode.employeeName.length && _optometryMode.employeeName) {
                [self.employeeLabel setText:[NSString stringWithFormat:@"验光师:%@",_optometryMode.employeeName]];
            }
            
            if (_optometryMode.insertDate && _optometryMode.insertDate.length) {
                [self.dateLabel setText:[NSString stringWithFormat:@"验光时间:%@",[IPCCommon formatDate:[IPCCommon dateFromString:_optometryMode.insertDate]  IsTime:YES]]];
            }else{
                [self.dateLabel setText:[NSString stringWithFormat:@"验光时间:%@",[IPCCommon formatDate:[NSDate date] IsTime:YES]]];
            }
        }
    }
}


- (IBAction)setDefaultAction:(id)sender {
    
}


@end
