//
//  IPCPriceStrategyView.m
//  IcePointCloud
//
//  Created by gerry on 2017/12/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPriceStrategyView.h"

static NSString * const strategyIdentifier = @"IPCPriceStrategyCellIdentifier";

@interface IPCPriceStrategyView()

@property (weak, nonatomic) IBOutlet UITableView *priceTableView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation IPCPriceStrategyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPriceStrategyView" owner:self];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topView addBottomLine];
    [self.priceTableView setTableHeaderView:[[UIView alloc]init]];
    [self.priceTableView setTableFooterView:[[UIView alloc]init]];
    self.priceTableView.estimatedSectionHeaderHeight = 0;
    self.priceTableView.estimatedSectionFooterHeight = 0;
    [self.priceTableView reloadData];
}


#pragma mark //Clicked Events
- (IBAction)dismissAction:(id)sender {
    [self dismiss];
}

#pragma mark //UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [IPCAppManager sharedManager].priceStrategy.strategyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strategyIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strategyIdentifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[UIColor jk_colorWithHexString:@"#888888"]];
    }
    IPCPriceStrategy * strategy = [IPCAppManager sharedManager].priceStrategy.strategyArray[indexPath.row];
    [cell.textLabel setText:strategy.strategyName];
    
    return cell;
}

#pragma mark //UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        IPCPriceStrategy * strategy = [IPCAppManager sharedManager].priceStrategy.strategyArray[indexPath.row];
        [IPCAppManager sharedManager].currentStrategy = strategy;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kIPCChoosePriceStrategyNotification object:nil];
    });
    
    [self dismiss];
}



@end
