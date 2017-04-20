//
//  IPCCustomsizedRightParameterCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedRightParameterCell.h"

@interface IPCCustomsizedRightParameterCell()

@property (copy, nonatomic) void(^UpdateBlock)(void);

@end

@implementation IPCCustomsizedRightParameterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.parameterContentView addSubview:self.parameterView];
    [[self.parameterView rac_signalForSelector:@selector(addOtherAction:)] subscribeNext:^(id x) {
        IPCCustomsizedOther * other = [[IPCCustomsizedOther alloc]init];
        [[IPCCustomsizedItem sharedItem].rightEye.otherArray addObject:other];
        if (self.UpdateBlock) {
            self.UpdateBlock();
        }
    }];
}


- (IPCCustomsizedParameterView *)parameterView{
    if (!_parameterView) {
        _parameterView = [[IPCCustomsizedParameterView alloc] initWithFrame:CGRectMake(0, 0, self.parameterContentView.jk_width, 400)];
        [_parameterView.distanceTextField setLeftText:@"双眼瞳距/PD(R)"];
    }
    return _parameterView;
}


#pragma mark //Clicked Events
- (void)reloadUI:(void (^)())update
{
    self.UpdateBlock = update;
    
    if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeUnified) {
        [self.unifiedButton setSelected:YES];
        [self.leftOrRightEyeButton setSelected:NO];
    }else if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeLeftOrRightEye){
        [self.leftOrRightEyeButton setSelected:YES];
        [self.unifiedButton setSelected:NO];
    }
    [self.parameterView reloadOtherParameterView];
}


- (IBAction)unifiedAction:(id)sender {
    [IPCCustomsizedItem sharedItem].customsizdType = IPCCustomsizedTypeUnified;
    if (self.UpdateBlock) {
        self.UpdateBlock();
    }
}

- (IBAction)leftOrRightEyeAction:(id)sender {
    [IPCCustomsizedItem sharedItem].customsizdType = IPCCustomsizedTypeLeftOrRightEye;
    if (self.UpdateBlock) {
        self.UpdateBlock();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
