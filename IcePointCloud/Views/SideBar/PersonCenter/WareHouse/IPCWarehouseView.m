//
//  IPCWarehouseView.m
//  IcePointCloud
//
//  Created by gerry on 2017/9/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCWarehouseView.h"

static NSString * const wareHouseIdentifier = @"IPCWareHouseCellIdentifier";

@interface IPCWarehouseView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *wareHouseTableView;

@end

@implementation IPCWarehouseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCWarehouseView" owner:self];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topView addBottomLine];
    [self.wareHouseTableView setTableHeaderView:[[UIView alloc]init]];
    [self.wareHouseTableView setTableFooterView:[[UIView alloc]init]];
    self.wareHouseTableView.estimatedSectionHeaderHeight = 0;
    self.wareHouseTableView.estimatedSectionFooterHeight = 0;
    [self.wareHouseTableView reloadData];
}

#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender {
    [self dismiss];
}

#pragma mark //UITabelViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [IPCAppManager sharedManager].wareHouse.wareHouseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:wareHouseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wareHouseIdentifier];
    }
    IPCWareHouse * house = [IPCAppManager sharedManager].wareHouse.wareHouseArray[indexPath.row];
    [cell.textLabel setText:house.wareHouseName];
    
    return cell;
}

#pragma mark //UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        IPCWareHouse * house = [IPCAppManager sharedManager].wareHouse.wareHouseArray[indexPath.row];
        [IPCAppManager sharedManager].currentWareHouse = house;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:IPCChooseWareHouseNotification object:nil];
    });
    
    [self dismiss];
}

@end
