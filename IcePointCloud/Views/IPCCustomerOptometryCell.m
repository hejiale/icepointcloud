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
    
    [self.contentView addSubview:self.optometryView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setOptometryMode:(IPCOptometryMode *)optometryMode
{
    _optometryMode = optometryMode;
    
    if (_optometryMode) {
        [self.optometryView createUIWithOptometry:_optometryMode];
    }
}

- (IPCMangerOptometryView *)optometryView{
    if (!_optometryView) {
        _optometryView = [[IPCMangerOptometryView alloc]initWithFrame:self.contentView.bounds];
    }
    return _optometryView;
}


@end
