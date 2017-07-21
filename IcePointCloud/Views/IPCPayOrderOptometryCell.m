//
//  IPCPayOrderOptometryCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOptometryCell.h"

@implementation IPCPayOrderOptometryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentView addSubview:self.optometryView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setOptometry:(IPCOptometryMode *)optometry{
    _optometry = optometry;
    
    if (_optometry) {
        [self.optometryView createUIWithOptometry:_optometry];
    }
}

- (IPCShowOptometryView *)optometryView{
    if (!_optometryView) {
        _optometryView = [[IPCShowOptometryView alloc]initWithFrame:self.contentView.bounds];
    }
    return _optometryView;
}

@end
