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
            if (_optometryMode.optometryEmployee.length && _optometryMode.optometryEmployee) {
                [self.employeeLabel setText:[NSString stringWithFormat:@"验光师:%@",_optometryMode.optometryEmployee]];
            }
        }else{
            if (_optometryMode.employeeName.length && _optometryMode.employeeName) {
                [self.employeeLabel setText:[NSString stringWithFormat:@"验光师:%@",_optometryMode.employeeName]];
            }
        }
        
        if (_optometryMode.insertDate && _optometryMode.insertDate.length) {
            [self.insertDateLabel setText:[NSString stringWithFormat:@"验光时间:%@",[IPCCommon formatDate:[IPCCommon dateFromString:_optometryMode.insertDate]  IsTime:YES]]];
        }
    }
}


@end
