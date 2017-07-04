//
//  UserBaseTopTitleCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/25.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomTopCell.h"

@interface IPCCustomTopCell()


@end

@implementation IPCCustomTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

- (void)setRightTitle:(NSString *)title{
    [self.rightLabel setHidden:NO];
    [self.rightLabel setAttributedText:title];
}

- (void)setNoPayTitle:(NSString *)title{
    [self.noPayPriceView setHidden:NO];
    [self.noPayPriceLabel setText:title];
}

- (void)setRightManagerTitle:(NSString *)title{
    [self.topTitleLabel setText:title];
    [self.rightButton setTitle:@"管理" forState:UIControlStateNormal];
}

#pragma mark //Clicked Events
- (IBAction)insertAction:(id)sender {
    
}


- (IBAction)editAction:(id)sender {
}


- (IBAction)searchCustomerAction:(id)sender {
}


- (IBAction)rightButtonAction:(id)sender {
}

@end
