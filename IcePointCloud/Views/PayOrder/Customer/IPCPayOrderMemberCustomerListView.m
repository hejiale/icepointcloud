//
//  IPCPayOrderMemberCustomerListView.m
//  IcePointCloud
//
//  Created by gerry on 2018/2/28.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayOrderMemberCustomerListView.h"
#import "IPCPayOrderMemberCustomerListCell.h"

static NSString * const  customerListIdentifier = @"IPCPayOrderMemberCustomerListCellIdentifier";

@interface IPCPayOrderMemberCustomerListView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *customerListTableView;
@property (copy, nonatomic) NSArray<IPCCustomerMode *> * customerList;
@property (copy, nonatomic) void(^SelectCustomerBlock)(NSString *customerId);

@end

@implementation IPCPayOrderMemberCustomerListView

- (instancetype)initWithFrame:(CGRect)frame Select:(void(^)(NSString *customerId))select
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderMemberCustomerListView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        self.SelectCustomerBlock = select;
        [self.customerListTableView setTableHeaderView:[[UIView alloc]init]];
        [self.customerListTableView setTableFooterView:[[UIView alloc]init]];
    }
    return self;
}

- (void)reloadCustomerListView:(NSArray<IPCCustomerMode *> *)customerList
{
    _customerList = customerList;
    [self.customerListTableView reloadData];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.customerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCPayOrderMemberCustomerListCell * cell = [tableView dequeueReusableCellWithIdentifier:customerListIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCPayOrderMemberCustomerListCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    IPCCustomerMode * customer = self.customerList[indexPath.row];
    [cell.customerNameLabel setText:customer.customerName];
    
    return cell;
}

#pragma mark //UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCCustomerMode * customer = self.customerList[indexPath.row];
    if (self.SelectCustomerBlock) {
        self.SelectCustomerBlock(customer.customerID);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

@end
