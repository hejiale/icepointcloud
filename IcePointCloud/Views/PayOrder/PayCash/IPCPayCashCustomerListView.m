//
//  IPCPayCashCustomerListView.m
//  IcePointCloud
//
//  Created by gerry on 2018/1/31.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayCashCustomerListView.h"
#import "IPCPayCashCustomerListCell.h"

static NSString * const customerListCellIdentifier = @"IPCPayCashCustomerListCellIdentifier";

@interface IPCPayCashCustomerListView()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSInteger  currentPage;
    NSString * keyword;
}
@property (weak, nonatomic) IBOutlet UITextField *searchCustomerTextField;
@property (weak, nonatomic) IBOutlet UITableView *customerListTableView;
@property (strong, nonatomic) IPCRefreshAnimationFooter * refreshFooter;
@property (strong, nonatomic) NSMutableArray<IPCCustomerMode *> * customerList;
@property (copy, nonatomic) void(^Complete)(IPCCustomerMode *);

@end

@implementation IPCPayCashCustomerListView

- (instancetype)initWithFrame:(CGRect)frame Complete:(void(^)(IPCCustomerMode * customer))complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.Complete = complete;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayCashCustomerListView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.customerListTableView setTableHeaderView:[[UIView alloc]init]];
        [self.customerListTableView setTableFooterView:[[UIView alloc]init]];
        self.customerListTableView.mj_footer = self.refreshFooter;
        
        currentPage = 1;
        self.customerListTableView.isBeginLoad = YES;
        [self loadCustomerList];
        [self.customerListTableView reloadData];
    }
    return self;
}

- (NSMutableArray<IPCCustomerMode *> *)customerList{
    if (!_customerList) {
        _customerList = [[NSMutableArray alloc]init];
    }
    return _customerList;
}

#pragma mark //Set UI
- (IPCRefreshAnimationFooter *)refreshFooter
{
    if (!_refreshFooter) {
        _refreshFooter = [IPCRefreshAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _refreshFooter;
}

#pragma mark //Request Data
- (void)loadCustomerList
{
    __weak typeof(self) weakSelf = self;
    [IPCCustomerRequestManager queryCustomerListWithKeyword:keyword ? : @""
                                                       Page:currentPage
                                               SuccessBlock:^(id responseValue)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        IPCCustomerList * customerlist = [[IPCCustomerList alloc]initWithResponseValue:responseValue];
        [customerlist.list enumerateObjectsUsingBlock:^(IPCCustomerMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.memberLevel) {
                [strongSelf.customerList addObject:obj];
            }
        }];
        [weakSelf reload];
    } FailureBlock:^(NSError *error) {
        [weakSelf reload];
    }];
}

#pragma mark //Clicked Events
- (IBAction)dismissCoverAction:(id)sender {
    [self removeFromSuperview];
}

- (void)loadMoreData
{
    currentPage++;
    [self loadCustomerList];
}

- (void)reload{
    self.customerListTableView.isBeginLoad = NO;
    [self.customerListTableView reloadData];
    [self.refreshFooter endRefreshing];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.customerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCPayCashCustomerListCell * cell = [tableView dequeueReusableCellWithIdentifier:customerListCellIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCPayCashCustomerListCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    IPCCustomerMode * customer = self.customerList[indexPath.row];
    cell.customer = customer;
    
    return cell;
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCCustomerMode * customer = self.customerList[indexPath.row];
    
    if (self.Complete) {
        self.Complete(customer);
    }
    [self removeFromSuperview];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    keyword = [textField.text jk_trimmingWhitespace];
    
    [self.customerList removeAllObjects];
    [self loadCustomerList];
    
    [textField resignFirstResponder];
    return YES;
}



@end
