//
//  OrderDetailMemoCell.m
//  IcePointCloud
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCOrderDetailMemoCell.h"

@implementation IPCOrderDetailMemoCell

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
    
    [self inputMemoText:[IPCCustomerOrderDetail instance].orderInfo.remark];
}

- (void)inputMemoText:(NSString *)memo{
    if (memo && memo.length) {
        [self.memoLabel setText:memo];
        
//        CGFloat height = [self.memoLabel.text jk_heightWithFont:self.memoLabel.font constrainedToWidth:self.memoLabel.jk_width];
//        
//        if (height >= 45) {
//            self.memoHeightConstraint.constant = 45;
//        }else{
//            self.memoHeightConstraint.constant = MAX(height, 30);
//        }
    }
}

@end
