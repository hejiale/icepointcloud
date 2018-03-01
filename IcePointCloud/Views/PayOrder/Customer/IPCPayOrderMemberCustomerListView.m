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

@end

@implementation IPCPayOrderMemberCustomerListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderMemberCustomerListView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.customerListTableView setTableHeaderView:[[UIView alloc]init]];
        [self.customerListTableView setTableFooterView:[[UIView alloc]init]];
    }
    return self;
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCPayOrderMemberCustomerListCell * cell = [tableView dequeueReusableCellWithIdentifier:customerListIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCPayOrderMemberCustomerListCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    return cell;
}

#pragma mark //UITableViewDelegate

@end
