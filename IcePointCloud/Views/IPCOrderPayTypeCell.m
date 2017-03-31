//
//  IPCOrderPayTypeCell.m
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOrderPayTypeCell.h"

typedef void(^PopEmployeBlock)();
typedef void(^UpdateBlock)();

@interface IPCOrderPayTypeCell()

@property (nonatomic, copy) PopEmployeBlock employeBlock;
@property (nonatomic, copy) UpdateBlock  updateBlock;

@end

@implementation IPCOrderPayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.employeSwitch setOnTintColor:COLOR_RGB_BLUE];
    [self.employeTextField setRightButton:self Action:@selector(showEmployeAction) OnView:self.contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUIWithEmployee:(void(^)())employe Update:(void(^)())update
{
    self.employeBlock = employe;
    self.updateBlock = update;
    
    if ([IPCPayOrderMode sharedManager].currentEmploye) {
        [self.employeTextField setText:[NSString stringWithFormat:@"员工号:%@/员工名:%@",[IPCPayOrderMode sharedManager].currentEmploye.jobNumber,[IPCPayOrderMode sharedManager].currentEmploye.name]];
    }
    [self.employeSwitch setSelected:[IPCPayOrderMode sharedManager].isSelectEmploye];
}

#pragma mark //Clicked Events
- (IBAction)selectEmployeAction:(UISwitch *)sender {
    if ([IPCPayOrderMode sharedManager].currentEmploye) {
        [IPCPayOrderMode sharedManager].isSelectEmploye = sender.isOn;
        if (self.updateBlock)
            self.updateBlock();
    }else{
        [sender setOn:NO animated:NO];
        [IPCCustomUI showError:@"请先选择员工号"];
    }
}


- (void)showEmployeAction{
    if (self.employeBlock) {
        self.employeBlock();
    }
}




@end
