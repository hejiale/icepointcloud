//
//  IPCPayAmountStyleCell.m
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderEmployeeCell.h"

@interface IPCPayOrderEmployeeCell()

@property (copy, nonatomic) void(^UpdateBlock)(void);

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

- (void)updateUI:(void (^)())update
{
    self.UpdateBlock = update;
    
    CGFloat width = (self.jk_width - 100)/5;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __weak typeof(self) weakSelf = self;
    
    [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block IPCEmployeePerformanceView * employeeView = [[IPCEmployeePerformanceView alloc]initWithFrame:CGRectMake(20+(width+15)*idx, 45/2, width, 90) Update:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf replaceEmployee:employeeView.employeeResult];
        }];
        [[employeeView rac_signalForSelector:@selector(removeAction:)] subscribeNext:^(id x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf removeEmployee:employeeView.employeeResult];
        }];
        employeeView.employeeResult = obj;
        [self.contentView addSubview:employeeView];
    }];
}


- (void)replaceEmployee:(IPCEmployeeResult *)employeeResult{
   [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if ([employeeResult.employe.jobID isEqualToString:obj.employe.jobID]) {
           [[IPCPayOrderMode sharedManager].employeeResultArray replaceObjectAtIndex:idx withObject:employeeResult];
       }
   }];
    
    if (self.UpdateBlock) {
        self.UpdateBlock();
    }
}

- (void)removeEmployee:(IPCEmployeeResult *)employeeResult{
    [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([employeeResult.employe.jobID isEqualToString:obj.employe.jobID]) {
            [[IPCPayOrderMode sharedManager].employeeResultArray removeObject:employeeResult];
        }
    }];
    
    if (self.UpdateBlock) {
        self.UpdateBlock();
    }
}



@end
