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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strategyIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strategyIdentifier];
    }
    
    return cell;
}

#pragma mark //UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kIPCChoosePriceStrategyNotification object:nil];
    });
    
    [self dismiss];
}



@end
