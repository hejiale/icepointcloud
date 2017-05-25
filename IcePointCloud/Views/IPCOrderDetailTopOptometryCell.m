//
//  IPCOrderDetailOptometryCell.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/29.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCOrderDetailTopOptometryCell.h"

@implementation IPCOrderDetailTopOptometryCell

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
    
    [self.packUpButton setSelected:[IPCCustomOrderDetailList instance].orderInfo.isPackUpOptometry];
}


- (IBAction)packUpAction:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    
   [IPCCustomOrderDetailList instance].orderInfo.isPackUpOptometry = sender.selected;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadOrderDetailTableView)]) {
            [self.delegate reloadOrderDetailTableView];
        }
    }
}


@end
