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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOptometryMode:(IPCOptometryMode *)optometryMode{
    _optometryMode = optometryMode;
    
    if (_optometryMode) {
        if (!self.optometryView) {
            self.optometryView = [[IPCMangerOptometryView alloc]initWithFrame:self.optometryContentView.bounds];
            [self.optometryView createUIWithOptometry:_optometryMode];
            [self.optometryContentView addSubview:self.optometryView];
        }
    }
}

@end
