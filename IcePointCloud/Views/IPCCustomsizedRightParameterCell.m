//
//  IPCCustomsizedRightParameterCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedRightParameterCell.h"

@interface IPCCustomsizedRightParameterCell()<IPCCustomsizedEyeDelegate>


@end

@implementation IPCCustomsizedRightParameterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.parameterContentView addSubview:self.parameterView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self reloadUI];
}


- (IPCCustomsizedParameterView *)parameterView{
    if (!_parameterView) {
        _parameterView = [[IPCCustomsizedParameterView alloc] initWithFrame:CGRectMake(0, 0, 930, 285) Direction:YES];
        [_parameterView setDelegate:self];
    }
    return _parameterView;
}


#pragma mark //Clicked Events
- (void)reloadUI
{
    if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeUnified) {
        [self.unifiedButton setSelected:YES];
        [self.leftOrRightEyeButton setSelected:NO];
    }else if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeLeftOrRightEye){
        [self.rightEyeImageView setHidden:NO];
        [self.leftOrRightEyeButton setSelected:YES];
        [self.unifiedButton setSelected:NO];
    }
    [self.parameterView reloadOtherParameterView];
}


- (IBAction)unifiedAction:(id)sender {
    [IPCCustomsizedItem sharedItem].customsizdType = IPCCustomsizedTypeUnified;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

- (IBAction)leftOrRightEyeAction:(id)sender {
    [IPCCustomsizedItem sharedItem].customsizdType = IPCCustomsizedTypeLeftOrRightEye;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

#pragma mark //IPCCustomsizedEyeDelegate
- (void)reloadParameterInfoView{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
