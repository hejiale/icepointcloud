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
    self.optometryView = [[IPCOptometryView alloc]initWithFrame:CGRectMake(15, 5, self.jk_width-35, 145) Update:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.delegate) {
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


- (void)reloadUIWithOptometry:(IPCOptometryMode *)optometry
{
    [self.optometryView subTextField:0].text = optometry.purpose;
    [self.optometryView subTextField:1].text = optometry.sphRight;
    [self.optometryView subTextField:2].text = optometry.cylRight;
    [self.optometryView subTextField:3].text = optometry.axisRight;
    [self.optometryView subTextField:4].text = optometry.correctedVisionRight;
    [self.optometryView subTextField:5].text = optometry.distanceRight;
    [self.optometryView subTextField:6].text = optometry.addRight;
    [self.optometryView subTextField:7].text = optometry.sphLeft;
    [self.optometryView subTextField:8].text = optometry.cylLeft;
    [self.optometryView subTextField:9].text = optometry.axisLeft;
    [self.optometryView subTextField:10].text = optometry.correctedVisionLeft;
    [self.optometryView subTextField:11].text = optometry.distanceLeft;
    [self.optometryView subTextField:12].text = optometry.addLeft;
    [self.optometryView subTextField:13].text = optometry.employeeName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark //Clicked Events
- (void)removeOptometryAction:(id)sender {
    
}

@end
