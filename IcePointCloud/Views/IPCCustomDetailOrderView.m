//
//  IPCCustomDetailOrderView.m
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomDetailOrderView.h"
#import "OrderDetailTopTableViewCell.h"
#import "IPCOrderDetailContactCell.h"
#import "IPCOrderProductCell.h"
#import "IPCOrderDetailInfoCell.h"
#import "IPCOrderDetailMemoCell.h"
#import "IPCOrderProductPriceCell.h"

static NSString * const topIdentifier        = @"OrderDetailTopTableViewCellIdentifier";
static NSString * const memoIdentifier    = @"OrderDetailMemoCellIdentifier";
static NSString * const contactIdentifier  = @"OrderDetailContactCellIdentifier";
static NSString * const productIdentifier = @"OrderProductTableViewCellIdentifier";
static NSString * const detailIdetifier      = @"OrderDetailInfoTableViewCellIdentifier";
static NSString * const priceIdentifier     = @"OrderProductPriceCellIdentifier";

@interface IPCCustomDetailOrderView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *orderDetailBgView;
@property (weak, nonatomic)  IBOutlet UITableView *orderDetailTableView;

@property (strong, nonatomic)  IPCCustomOrderDetailList * detailOrder;
@property (copy,  nonatomic) void(^ProductDetailBlock)(IPCGlasses *glass);
@property (copy,  nonatomic) void(^DismissBlock)();
@property (nonatomic, copy) NSString * currentOrderNum;

@end

@implementation IPCCustomDetailOrderView

- (instancetype)initWithFrame:(CGRect)frame OrderNum:(NSString *)orderNum ProductDetail:(void(^)(IPCGlasses *glass))product Dismiss:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view  = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomDetailOrderView" owner:self];
        [view setFrame:frame];
        [self addSubview: view];
 
        self.ProductDetailBlock = product;
        self.DismissBlock = dismiss;
        self.currentOrderNum = orderNum;
        
        if ([self.currentOrderNum integerValue] > 0) {
            [self performSelectorOnMainThread:@selector(queryOrderDetail) withObject:nil waitUntilDone:YES];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.orderDetailTableView setTableFooterView:[[UIView alloc]init]];
    self.orderDetailTableView.isHiden = YES;
    self.orderDetailTableView.emptyAlertTitle = @"暂未查询到订单详细信息，请重试！";
    self.orderDetailTableView.emptyAlertImage = [UIImage imageNamed:@"exception_history"];
    
    [self addSubview:self.orderDetailBgView];
    [self.orderDetailBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_right).offset(-self.orderDetailBgView.jk_width);
        make.top.mas_equalTo(self.mas_top).offset(0);
    }];
}

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
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.orderDetailBgView.frame;
        frame.origin.x += self.orderDetailBgView.jk_width;
        self.orderDetailBgView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.DismissBlock) {
                self.DismissBlock();
            }
        }
    }];
}

#pragma mark //Request Data
- (void)queryOrderDetail
{
    [IPCCustomerRequestManager queryOrderDetailWithOrderID:self.currentOrderNum
                                              SuccessBlock:^(id responseValue)
     {
         _detailOrder = [[IPCCustomOrderDetailList alloc]initWithResponseValue:responseValue];
         [self.orderDetailTableView reloadData];
         [IPCCustomUI hiden];
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}


#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3)
        return self.detailOrder.products.count + 1;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OrderDetailTopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"OrderDetailTopTableViewCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        if (self.detailOrder) {
            [cell.statusLabel setText:[IPCAppManager orderStatus:self.detailOrder.orderInfo.status]];
        }
        return cell;
    }else if (indexPath.section == 1) {
        IPCOrderDetailContactCell * cell = [tableView dequeueReusableCellWithIdentifier:contactIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailContactCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        
        if (self.detailOrder)
            [cell inputContactInfo:self.detailOrder.orderInfo];
        
        return cell;
    }else if (indexPath.section == 2){
        IPCOrderDetailMemoCell * cell = [tableView dequeueReusableCellWithIdentifier:memoIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailMemoCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        if (self.detailOrder)
            [cell inputMemoText:self.detailOrder.orderInfo.remark];
        
        return cell;
    }else if (indexPath.section == 3){
        if (indexPath.row < self.detailOrder.products.count) {
            IPCOrderProductCell * cell = [tableView dequeueReusableCellWithIdentifier:productIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderProductCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            
            if (self.detailOrder) {
                IPCGlasses * product = self.detailOrder.products[indexPath.row];
                cell.glasses = product;
            }
            
            return cell;
        }else{
            IPCOrderProductPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:priceIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderProductPriceCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            if (self.detailOrder) {
                [cell inputBeforeDiscountPrice:self.detailOrder.orderInfo.beforeDiscountPrice AfterPrice:self.detailOrder.orderInfo.totalPrice];
            }
            return cell;
        }
    }else{
        IPCOrderDetailInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:detailIdetifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailInfoCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        
        if (self.detailOrder)
            [cell inputOrderInfo:self.detailOrder.orderInfo];
        
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 75;
    }else if (indexPath.section == 2){
        return 60;
    }else if (indexPath.section == 3){
        if (indexPath.row < self.detailOrder.products.count )
            return 110;
        return 55;
    }
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width,  5)];
    [footView setBackgroundColor:[UIColor clearColor]];
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 3) {
        if (self.detailOrder) {
            IPCGlasses * glass = self.detailOrder.products[indexPath.row];
            if (self.ProductDetailBlock)
                self.ProductDetailBlock(glass);
        }
    }
}


@end
