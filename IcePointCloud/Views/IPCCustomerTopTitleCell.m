//
//  UserBaseTopTitleCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerTopTitleCell.h"

@interface IPCCustomerTopTitleCell()


@end

@implementation IPCCustomerTopTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.addButton setTitleColor:COLOR_RGB_BLUE forState:UIControlStateNormal];
    [self.editButton setTitleColor:COLOR_RGB_BLUE forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopTitle:(NSString *)title
{
    [self.topTitleLabel setText:title];
}

- (void)setInsertTitle:(NSString *)title
{
    [self.topTitleLabel setText:title];
    [self.addButton setHidden:NO];
}

- (void)setEditTitle:(NSString *)title
{
    [self.topTitleLabel setText:title];
    [self.editButton setHidden:NO];
}



#pragma mark //Clicked Events
- (IBAction)insertAction:(id)sender {
    
}


- (IBAction)editAction:(id)sender {
}


- (IBAction)searchCustomerAction:(id)sender {
}



@end
