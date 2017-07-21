//
//  IPCUpdateOrderEmployeeCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCUpdateOrderEmployeeCell.h"
#import "IPCEmployeePerformanceView.h"

@implementation IPCUpdateOrderEmployeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self updateUI];
}

- (void)updateUI
{
    CGFloat width = (self.jk_width - 56)/5;
    
    __weak typeof(self) weakSelf = self;
    
    [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block IPCEmployeePerformanceView * employeeView = [[IPCEmployeePerformanceView alloc]initWithFrame:CGRectMake(28+(width+10)*idx, 0, width, 90) Update:nil];
        employeeView.employeeResult = obj;
        [self.contentView addSubview:employeeView];
    }];
}

@end
