//
//  HistoryOptometryCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerOptometryCell.h"


@implementation IPCCustomerOptometryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setOptometryMode:(IPCOptometryMode *)optometryMode
{
    _optometryMode = optometryMode;
    
    if (_optometryMode) {
        if (!self.optometryView) {
            self.optometryView = [[IPCMangerOptometryView alloc]initWithFrame:self.optometryContentView.bounds];
            [self.optometryView createUIWithOptometry:_optometryMode];
            [self.optometryContentView addSubview:self.optometryView];
        }
        
        if (_optometryMode.isUpdateStatus) {
            if (_optometryMode.optometryEmployee) {
                [self.employeeLabel setText:[NSString stringWithFormat:@"验光师:%@",_optometryMode.optometryEmployee]];
            }
            if (_optometryMode.optometryInsertDate) {
                [self.insertDateLabel setText:[NSString stringWithFormat:@"验光时间:%@",[IPCCommon formatDate:[IPCCommon dateFromString:_optometryMode.optometryInsertDate]  IsTime:YES]]];
            }
        }else{
            if (_optometryMode.employeeName) {
                [self.employeeLabel setText:[NSString stringWithFormat:@"验光师:%@",_optometryMode.employeeName]];
            }
            if (_optometryMode.insertDate) {
                [self.insertDateLabel setText:[NSString stringWithFormat:@"验光时间:%@",[IPCCommon formatDate:[IPCCommon dateFromString:_optometryMode.insertDate]  IsTime:YES]]];
            }
        }
    }
}


@end
