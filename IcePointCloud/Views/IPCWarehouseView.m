//
//  IPCWarehouseView.m
//  IcePointCloud
//
//  Created by gerry on 2017/9/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCWarehouseView.h"
#import "IPCWareHouseCell.h"

static NSString * const wareHouseIdentifier = @"IPCWareHouseCellIdentifier";

@interface IPCWarehouseView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *wareHouseTableView;
@property (copy, nonatomic) void(^CloseBlock)(void);

@end

@implementation IPCWarehouseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCWarehouseView" owner:self];
        [self addSubview:view];
        
        [self.topView addBottomLine];
        [self.wareHouseTableView setTableHeaderView:[[UIView alloc]init]];
        [self.wareHouseTableView setTableFooterView:[[UIView alloc]init]];
        self.wareHouseTableView.estimatedSectionHeaderHeight = 0;
        self.wareHouseTableView.estimatedSectionFooterHeight = 0;
    }
    return self;
}


#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender {
    [self dismiss];
}

- (void)showWithClose:(void (^)())closeBlock
{
    self.CloseBlock = closeBlock;
    
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.frame;
        frame.origin.x -= self.jk_width;
        self.frame = frame;
    } completion:nil];
}

- (void)dismiss{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.frame;
        frame.origin.x += self.jk_width;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.CloseBlock) {
                self.CloseBlock();
            }
        }
    }];
}


#pragma mark //UITabelViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [IPCAppManager sharedManager].wareHouse.wareHouseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCWareHouseCell * cell = [tableView dequeueReusableCellWithIdentifier:wareHouseIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCWareHouseCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    IPCWareHouse * house = [IPCAppManager sharedManager].wareHouse.wareHouseArray[indexPath.row];
    [cell.wareHouseTitleLabel setText:house.wareHouseName];
    return cell;
}

#pragma mark //UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    IPCWareHouse * house = [IPCAppManager sharedManager].wareHouse.wareHouseArray[indexPath.row];
    [IPCAppManager sharedManager].currentWareHouse = house;
    [IPCAppManager sharedManager].isChangeHouse = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IPCChooseWareHouseNotification object:nil];
    
    [self dismiss];
}

@end
