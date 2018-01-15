//
//  IPCCustomDetailOrderView.m
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomDetailOrderView.h"
#import "IPCOrderDetailTopCell.h"
#import "IPCOrderDetailProductCell.h"
#import "IPCOrderDetailInfoCell.h"
#import "IPCOrderDetailMemoCell.h"
#import "IPCOrderDetailProductPriceCell.h"
#import "IPCOrderDetailTopOptometryCell.h"
#import "IPCOrderDetailOptometryCell.h"
#import "IPCOrderDetailSectionCell.h"
#import "IPCOrderDetailPayRecordCell.h"

static NSString * const topIdentifier        = @"OrderDetailTopTableViewCellIdentifier";
static NSString * const memoIdentifier    = @"OrderDetailMemoCellIdentifier";
static NSString * const productIdentifier = @"OrderProductTableViewCellIdentifier";
static NSString * const detailIdetifier      = @"OrderDetailInfoTableViewCellIdentifier";
static NSString * const priceIdentifier     = @"OrderProductPriceCellIdentifier";
static NSString * const topOptometryIdentifier = @"IPCOrderDetailTopOptometryCellIdentifier";
static NSString * const optometryIdentifier = @"IPCOrderDetailOptometryCellIdentifier";
static NSString * const titleIdentifier            = @"IPCOrderDetailSectionCellIdentifier";
static NSString * const payRecordIdentifier  = @"IPCOrderDetailPayRecordCellIdentifier";

@interface IPCCustomDetailOrderView()<UITableViewDelegate,UITableViewDataSource,IPCCustomerOrderDetailDelegate>

@property (strong, nonatomic) IBOutlet UIView *orderDetailBgView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic)  IBOutlet UITableView *orderDetailTableView;
@property (nonatomic, copy) NSString * currentOrderNum;

@end

@implementation IPCCustomDetailOrderView

- (instancetype)initWithFrame:(CGRect)frame
                     OrderNum:(NSString *)orderNum
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view  = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomDetailOrderView" owner:self];
        [view setFrame:frame];
        [self addSubview: view];

        self.currentOrderNum = orderNum;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //Set Top View Bottom Line
    [self.topView addBottomLine];
    //Load TableView
    [self.orderDetailTableView setTableHeaderView:[[UIView alloc]init]];
    [self.orderDetailTableView setTableFooterView:[[UIView alloc]init]];
    self.orderDetailTableView.estimatedSectionFooterHeight = 0;
    self.orderDetailTableView.estimatedSectionHeaderHeight = 0;
    self.orderDetailTableView.isBeginLoad = YES;
    //Load OrderDetail View
    [self addSubview:self.orderDetailBgView];
    
    [self.orderDetailBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_right).offset(-self.orderDetailBgView.jk_width);
        make.top.mas_equalTo(self.mas_top).offset(0);
    }];
    //Load Data
    [self queryOrderDetail];
}


#pragma mark //Clicked Events
- (void)show
{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.orderDetailBgView.frame;
        frame.origin.x -= self.orderDetailBgView.jk_width;
        self.orderDetailBgView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)dismissViewAction:(id)sender {
    [[IPCCustomerOrderDetail instance] clearData];
    [[IPCHttpRequest sharedClient] cancelAllRequest];
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.orderDetailBgView.frame;
        frame.origin.x += self.orderDetailBgView.jk_width;
        self.orderDetailBgView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark //Request Data
- (void)queryOrderDetail
{
    [IPCCustomerRequestManager queryOrderDetailWithOrderID:self.currentOrderNum
                                              SuccessBlock:^(id responseValue)
     {
         [[IPCCustomerOrderDetail instance] parseResponseValue:responseValue];
         self.orderDetailTableView.isBeginLoad = NO;
         [self.orderDetailTableView reloadData];
     } FailureBlock:^(NSError *error) {
         self.orderDetailTableView.isBeginLoad = NO;
         [self.orderDetailTableView reloadData];
     }];
}


#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([IPCCustomerOrderDetail instance].orderInfo)
        return 7;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ((section == 1 && [IPCCustomerOrderDetail instance].orderInfo.isPackUpOptometry) || section == 4){
        return 2;
    }else if (section == 2){
        return [IPCCustomerOrderDetail instance].products.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        IPCOrderDetailTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            IPCOrderDetailTopOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:topOptometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderDetailTopOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.delegate = self;
            return cell;
        }else{
            IPCOrderDetailOptometryCell * cell = [tableView dequeueReusableCellWithIdentifier:optometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderDetailOptometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.optometry = [IPCCustomerOrderDetail instance].optometryMode;
            return cell;
        }
    }else if (indexPath.section == 2){
        IPCOrderDetailProductCell * cell = [tableView dequeueReusableCellWithIdentifier:productIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailProductCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate  = self;
        }
        
        if ([IPCCustomerOrderDetail instance].products.count) {
            IPCGlasses * product = [IPCCustomerOrderDetail instance].products[indexPath.row];
            cell.glasses = product;
        }
        return cell;
    }else if (indexPath.section == 3){
        IPCOrderDetailProductPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:priceIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailProductPriceCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            IPCOrderDetailSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderDetailSectionCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.sectionTitleLabel setText:@"收款记录"];
            [cell.sectionValueLabel setText:[NSString stringWithFormat:@"￥%.2f", [IPCCustomerOrderDetail instance].orderInfo.remainAmount]];
            return cell;
        }else{
            IPCOrderDetailPayRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:payRecordIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderDetailPayRecordCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            cell.recordList = [IPCCustomerOrderDetail instance].recordArray;
            return cell;
        }
    }else if(indexPath.section == 5){
        IPCOrderDetailInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:detailIdetifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailInfoCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }else{
        IPCOrderDetailMemoCell * cell = [tableView dequeueReusableCellWithIdentifier:memoIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailMemoCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 75;
    }else if (indexPath.section == 1 && indexPath.row > 0){
        return 195;
    }else if (indexPath.section == 2){
        if ([IPCCustomerOrderDetail instance].products.count) {
            return 115;
        }
    }else if (indexPath.section == 3){
        return 90;
    }else if (indexPath.section == 4 && indexPath.row > 0){
        return [IPCCustomerOrderDetail instance].recordArray.count * 30;
    }else if (indexPath.section == 5){
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
