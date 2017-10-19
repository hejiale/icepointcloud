//
//  IPCPayAmountStyleCell.m
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderEmployeeCell.h"

@interface IPCPayOrderEmployeeCell()

@end

@implementation IPCPayOrderEmployeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self updateUI];
}

- (void)updateUI
{
    CGFloat width = (self.jk_width - 76)/3;
    
    __weak typeof(self) weakSelf = self;
    
    [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block IPCEmployeePerformanceView * employeeView = [[IPCEmployeePerformanceView alloc]initWithFrame:CGRectMake(28+(width+10)*idx, 0, width, 90) Update:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf replaceEmployee:employeeView.employeeResult];
        }];
        [[employeeView rac_signalForSelector:@selector(removeAction:)] subscribeNext:^(id x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf removeEmployee:employeeView.employeeResult];
        }];
        employeeView.employeeResult = obj;
        [self.employeeScrollView addSubview:employeeView];
    }];
    
    [self.employeeScrollView setContentSize:CGSizeMake([IPCPayOrderManager sharedManager].employeeResultArray.count * (width+10) + 28, 0)];
}


- (void)replaceEmployee:(IPCEmployeeResult *)employeeResult{
   [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if ([employeeResult.employee.jobID isEqualToString:obj.employee.jobID]) {
           [[IPCPayOrderManager sharedManager].employeeResultArray replaceObjectAtIndex:idx withObject:employeeResult];
       }
   }];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}

- (void)removeEmployee:(IPCEmployeeResult *)employeeResult{
    [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([employeeResult.employee.jobID isEqualToString:obj.employee.jobID]) {
            [[IPCPayOrderManager sharedManager].employeeResultArray removeObject:employeeResult];
        }
    }];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadUI)]) {
            [self.delegate reloadUI];
        }
    }
}



@end
