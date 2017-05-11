//
//  IPCCustomsizedLeftParameterCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedLeftParameterCell.h"

@interface IPCCustomsizedLeftParameterCell()<IPCCustomsizedEyeDelegate>

@property (copy, nonatomic) void(^UpdateBlock)(void);

@end


@implementation IPCCustomsizedLeftParameterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.parameterContentView addSubview:self.parameterView];
}


- (IPCCustomsizedParameterView *)parameterView{
    if (!_parameterView) {
        _parameterView = [[IPCCustomsizedParameterView alloc] initWithFrame:CGRectMake(0, 0, self.parameterContentView.jk_width, 285) Direction:NO];
        [_parameterView setDelegate:self];
    }
    return _parameterView;
}


#pragma mark //Clicked Events
- (void)reloadUI:(void (^)())update
{
    self.UpdateBlock = update;
    [self.parameterView reloadOtherParameterView];
}

#pragma mark //IPCCustomsizedEyeDelegate
- (void)reloadParameterInfoView{
    if (self.UpdateBlock) {
        self.UpdateBlock();
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
