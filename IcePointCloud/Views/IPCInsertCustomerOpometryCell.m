//
//  UserBaseOpometryCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/28.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCInsertCustomerOpometryCell.h"

@interface IPCInsertCustomerOpometryCell()

@property (copy, nonatomic) void(^CompleteBlock)();

@end

@implementation IPCInsertCustomerOpometryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.optometryView = [[IPCOptometryView alloc]initWithFrame:CGRectMake(15, 5, self.jk_width-35, 145)];
    [self.contentView addSubview:self.optometryView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
