//
//  UserBaseOpometryCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/28.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCInsertCustomerOpometryCell.h"

@interface IPCInsertCustomerOpometryCell()

@property (copy, nonatomic) void(^CompleteBlock)();

@end

@implementation IPCInsertCustomerOpometryCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    __weak typeof(self) weakSelf = self;
    self.optometryView = [[IPCOptometryView alloc]initWithFrame:CGRectMake(15, 15, self.jk_width-35, 145) Update:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate && strongSelf) {
            if ([strongSelf.delegate respondsToSelector:@selector(updateOptometryMode:Cell:)]) {
                [strongSelf.delegate updateOptometryMode:strongSelf.optometryView.insertOptometry Cell:strongSelf];
            }
        }
    }];
    [self.contentView addSubview:self.optometryView];
    [self.contentView addSubview:self.removeButton];
    [self.contentView bringSubviewToFront:self.removeButton];
    
    [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
}

- (UIButton *)removeButton{
    if (!_removeButton) {
        _removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_removeButton setBackgroundColor:[UIColor clearColor]];
        [_removeButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        _removeButton.adjustsImageWhenHighlighted = NO;
        [_removeButton addTarget:self action:@selector(removeOptometryAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeButton;
}

- (void)setOptometryMode:(IPCOptometryMode *)optometryMode{
    _optometryMode = optometryMode;
    
    if (_optometryMode) {
        [self.optometryView subTextField:0].text = [IPCCommon formatPurpose:_optometryMode.purpose];
        [self.optometryView subTextField:1].text = _optometryMode.sphRight;
        [self.optometryView subTextField:2].text = _optometryMode.cylRight;
        [self.optometryView subTextField:3].text = _optometryMode.axisRight;
        [self.optometryView subTextField:4].text = _optometryMode.correctedVisionRight;
        [self.optometryView subTextField:5].text = _optometryMode.distanceRight;
        [self.optometryView subTextField:6].text = _optometryMode.addRight;
        [self.optometryView subTextField:7].text = _optometryMode.sphLeft;
        [self.optometryView subTextField:8].text = _optometryMode.cylLeft;
        [self.optometryView subTextField:9].text = _optometryMode.axisLeft;
        [self.optometryView subTextField:10].text = _optometryMode.correctedVisionLeft;
        [self.optometryView subTextField:11].text = _optometryMode.distanceLeft;
        [self.optometryView subTextField:12].text = _optometryMode.addLeft;
        [self.optometryView subTextField:13].text = _optometryMode.employeeName;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark //Clicked Events
- (void)removeOptometryAction:(id)sender {
    
}

@end
