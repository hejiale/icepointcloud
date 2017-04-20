//
//  IPCCustomsizedLeftParameterCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedLeftParameterCell.h"

@implementation IPCCustomsizedLeftParameterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.parameterContentView addSubview:self.parameterView];
}


- (IPCCustomsizedParameterView *)parameterView{
    if (!_parameterView) {
        _parameterView = [[IPCCustomsizedParameterView alloc] initWithFrame:CGRectMake(0, 0, self.parameterContentView.jk_width, 400)];
        [_parameterView.distanceTextField setLeftText:@"双眼瞳距/PD(L)"];
    }
    return _parameterView;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
