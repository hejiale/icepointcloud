//
//  FilterClassViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/6/29.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCFilterClassViewCell.h"

@implementation IPCFilterClassViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView * selectedView = [[UIView alloc]initWithFrame:self.frame];
    [selectedView setBackgroundColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.09]];
    [self setSelectedBackgroundView:selectedView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
