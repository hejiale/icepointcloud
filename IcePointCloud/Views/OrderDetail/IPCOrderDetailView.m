//
//  IPCOrderDetailView.m
//  IcePointCloud
//
//  Created by gerry on 2018/3/21.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCOrderDetailView.h"
#import "IPCOrderDetailProductCell.h"
#import "IPCOrderDetailInfoCell.h"
#import "IPCOrderDetailMemoCell.h"
#import "IPCOrderDetailProductPriceCell.h"
#import "IPCOrderDetailTopOptometryCell.h"
#import "IPCOrderDetailOptometryCell.h"
#import "IPCOrderDetailSectionCell.h"
#import "IPCOrderDetailPayRecordCell.h"

static NSString * const memoIdentifier    = @"OrderDetailMemoCellIdentifier";
static NSString * const productIdentifier = @"OrderProductTableViewCellIdentifier";
static NSString * const detailIdetifier      = @"OrderDetailInfoTableViewCellIdentifier";
static NSString * const priceIdentifier     = @"OrderProductPriceCellIdentifier";
static NSString * const topOptometryIdentifier = @"IPCOrderDetailTopOptometryCellIdentifier";
static NSString * const optometryIdentifier = @"IPCOrderDetailOptometryCellIdentifier";
static NSString * const titleIdentifier            = @"IPCOrderDetailSectionCellIdentifier";
static NSString * const payRecordIdentifier  = @"IPCOrderDetailPayRecordCellIdentifier";

@interface IPCOrderDetailView()<UITableViewDelegate,UITableViewDataSource,IPCCustomerOrderDetailDelegate>

@property (strong, nonatomic)   UIView *topView;
@property (strong, nonatomic)   UITableView *orderDetailTableView;
@property (strong, nonatomic)   IPCCustomerOrderDetail * orderDetail;
@property (copy, nonatomic) void(^OrderDetailBlock)(IPCCustomerOrderDetail * orderDetail);

@end

@implementation IPCOrderDetailView

- (instancetype)initWithOrderDetail:(void(^)(IPCCustomerOrderDetail * orderDetail))detail
{
    self = [super init];
    if (self) {
        self.OrderDetailBlock = detail;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.topView];
    [self addSubview:self.orderDetailTableView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(64);
    }];
    
    [self.orderDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
}

- (void)setOrderNum:(NSString *)orderNum
{
    _orderNum = orderNum;
    
    if (_orderNum) {
        self.orderDetailTableView.isBeginLoad = YES;
        [self queryOrderDetailWithOrderNum:_orderNum];
    }
}

#pragma mark //Set UI
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        [_topView addBottomLine];
        [_topView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        [titleLabel setText:@"订单详情"];
        [titleLabel setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
        [_topView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topView.mas_centerX).with.offset(0);
            make.centerY.equalTo(_topView.mas_centerY).with.offset(0);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
        }];
        
    }
    return _topView;
}

- (UITableView *)orderDetailTableView{
    if (!_orderDetailTableView) {
        _orderDetailTableView = [[UITableView alloc]initWithFrame:CGRectZero];
        _orderDetailTableView.dataSource = self;
        _orderDetailTableView.delegate = self;
        [_orderDetailTableView setTableHeaderView:[[UIView alloc]init]];
        [_orderDetailTableView setTableFooterView:[[UIView alloc]init]];
        _orderDetailTableView.estimatedSectionFooterHeight = 0;
        _orderDetailTableView.estimatedSectionHeaderHeight = 0;
        _orderDetailTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _orderDetailTableView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    }
    return _orderDetailTableView;
}

#pragma mark //Request Data
- (void)queryOrderDetailWithOrderNum:(NSString *)currentOrderNum
{
    [IPCCustomerRequestManager queryOrderDetailWithOrderID:currentOrderNum
                                              SuccessBlock:^(id responseValue)
     {
         self.orderDetail = [[IPCCustomerOrderDetail alloc]init];
         [self.orderDetail parseResponseValue:responseValue];
         
         self.orderDetailTableView.isBeginLoad = NO;
         [self.orderDetailTableView reloadData];
         
         if (self.OrderDetailBlock) {
             self.OrderDetailBlock(self.orderDetail);
         }
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:error.domain];
         self.orderDetailTableView.isBeginLoad = NO;
         [self.orderDetailTableView reloadData];
     }];
}


#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ((section == 0 && self.orderDetail.orderInfo.isPackUpOptometry) || section == 3){
        return 2;
    }else if (section == 1){
        return self.orderDetail.products.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            IPCOrderDetailTopOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:topOptometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderDetailTopOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.orderInfo = self.orderDetail.orderInfo;
            cell.delegate = self;
            
            return cell;
        }else{
            IPCOrderDetailOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:optometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderDetailOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.optometry = self.orderDetail.optometryMode;
            return cell;
        }
    }else if (indexPath.section == 1){
        IPCOrderDetailProductCell * cell = [tableView dequeueReusableCellWithIdentifier:productIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailProductCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate  = self;
        }
        
        if (self.orderDetail.products.count) {
            IPCGlasses * product = self.orderDetail.products[indexPath.row];
            cell.glasses = product;
        }
        return cell;
    }else if (indexPath.section == 2){
        IPCOrderDetailProductPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:priceIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailProductPriceCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        cell.orderInfo = self.orderDetail.orderInfo;
        
        return cell;
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            IPCOrderDetailSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderDetailSectionCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.sectionTitleLabel setText:@"收款记录"];
            [cell.sectionValueLabel setText:[NSString stringWithFormat:@"￥%.2f", self.orderDetail.orderInfo.remainAmount]];
            return cell;
        }else{
            IPCOrderDetailPayRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:payRecordIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderDetailPayRecordCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.recordList = self.orderDetail.recordArray;
            return cell;
        }
    }else if(indexPath.section == 4){
        IPCOrderDetailInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:detailIdetifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailInfoCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        cell.orderInfo = self.orderDetail.orderInfo;
        
        return cell;
    }else{
        IPCOrderDetailMemoCell * cell = [tableView dequeueReusableCellWithIdentifier:memoIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailMemoCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        [cell.memoLabel setText:self.orderDetail.orderInfo.remark];
        
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row > 0){
        return 460;
    }else if (indexPath.section == 1){
        if (self.orderDetail.products.count) {
            return 115;
        }
    }else if (indexPath.section == 2){
        return 90;
    }else if (indexPath.section == 3 && indexPath.row > 0){
        return self.orderDetail.recordArray.count * 30;
    }else if (indexPath.section == 4){
        return 120;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark //IPCCustomerOrderDetailDelegate
- (void)reloadOrderDetailTableView{
    [self.orderDetailTableView reloadData];
}


@end
