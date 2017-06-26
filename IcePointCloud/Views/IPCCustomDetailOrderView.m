//
//  IPCCustomDetailOrderView.m
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomDetailOrderView.h"
#import "IPCOrderDetailTopCell.h"
#import "IPCCustomerAddressCell.h"
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
static NSString * const contactIdentifier  = @"IPCCustomerAddressCellIdentifier";
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
@property (weak, nonatomic) IBOutlet UIView *payBottomView;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;

@property (copy,  nonatomic) void(^ProductDetailBlock)(IPCGlasses *glass);
@property (copy,  nonatomic) void(^PayBlock)();
@property (copy,  nonatomic) void(^DismissBlock)();
@property (nonatomic, copy) NSString * currentOrderNum;

@end

@implementation IPCCustomDetailOrderView

- (instancetype)initWithFrame:(CGRect)frame OrderNum:(NSString *)orderNum ProductDetail:(void(^)(IPCGlasses *glass))product Pay:(void (^)())pay Dismiss:(void (^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view  = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomDetailOrderView" owner:self];
        [view setFrame:frame];
        [self addSubview: view];
        
        self.ProductDetailBlock = product;
        self.PayBlock = pay;
        self.DismissBlock = dismiss;
        self.currentOrderNum = orderNum;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if ([self.currentOrderNum integerValue] > 0) {
        [self queryOrderDetail];
    }
    
    [self.topView addBottomLine];
    [self.payBottomView addTopLine];
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
    [IPCCustomOrderDetailList instance].orderInfo = nil;
    [[IPCCustomOrderDetailList instance].products removeAllObjects];
    
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


- (IBAction)payAction:(id)sender {
    if (self.PayBlock) {
        self.PayBlock();
    }
}

#pragma mark //Request Data
- (void)queryOrderDetail
{
    [IPCCustomUI show];
    [IPCCustomerRequestManager queryOrderDetailWithOrderID:self.currentOrderNum
                                              SuccessBlock:^(id responseValue)
     {
         [[IPCCustomOrderDetailList instance] parseResponseValue:responseValue];
         [self.orderDetailTableView reloadData];
         if ([IPCPayOrderMode sharedManager].remainAmount > 0) {
             [self.payBottomView setHidden:NO];
             self.tableViewBottom.constant = 56;
             NSString * payPrice = [NSString stringWithFormat:@"支付尾款:￥%.2f", [IPCPayOrderMode sharedManager].remainAmount];
             [self.payPriceLabel setAttributedText:[IPCCustomUI subStringWithText:payPrice BeginRang:5 Rang:payPrice.length - 5 Font:self.payPriceLabel.font Color:COLOR_RGB_RED]];
         }
         [IPCCustomUI hiden];
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}


#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2){
        if ([IPCCustomOrderDetailList instance].orderInfo.isPackUpOptometry)
            return 2;
    }
    else if (section == 3){
        return [IPCCustomOrderDetailList instance].products.count;
    }else if (section == 6){
        return 2;
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
    }else if (indexPath.section == 1) {
        IPCCustomerAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:contactIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCCustomerAddressCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        cell.addressMode = [IPCCustomOrderDetailList instance].addressMode;
        return cell;
    }else if (indexPath.section == 2){
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
            return cell;
        }
    }else if (indexPath.section == 3){
        IPCOrderDetailProductCell * cell = [tableView dequeueReusableCellWithIdentifier:productIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailProductCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate  = self;
        }
        
        if ([IPCCustomOrderDetailList instance].products.count) {
            IPCGlasses * product = [IPCCustomOrderDetailList instance].products[indexPath.row];
            cell.glasses = product;
        }
        return cell;
    }else if (indexPath.section == 4){
        IPCOrderDetailProductPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:priceIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailProductPriceCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }else if (indexPath.section == 5){
        IPCOrderDetailMemoCell * cell = [tableView dequeueReusableCellWithIdentifier:memoIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailMemoCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }else if (indexPath.section == 6){
        if (indexPath.row == 0) {
            IPCOrderDetailSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderDetailSectionCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.sectionTitleLabel setText:@"收款记录"];
            NSString * remainAmountText = [NSString stringWithFormat:@"剩余应收  ￥%.2f", [IPCPayOrderMode sharedManager].remainAmount];
            NSAttributedString * str = [IPCCustomUI subStringWithText:remainAmountText BeginRang:6 Rang:remainAmountText.length - 6 Font:[UIFont systemFontOfSize:14 weight:UIFontWeightThin] Color:COLOR_RGB_RED];
            [cell.sectionValueLabel setAttributedText:str];
            
            return cell;
        }else{
            IPCOrderDetailPayRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:payRecordIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCOrderDetailPayRecordCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            return cell;
        }
    }else{
        IPCOrderDetailInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:detailIdetifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCOrderDetailInfoCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 75;
    }else if (indexPath.section == 1 && ![[IPCCustomOrderDetailList instance].addressMode isEmptyAddress]){
        return 70;
    }else if (indexPath.section == 2 && indexPath.row > 0){
        return 185;
    }else if (indexPath.section == 3){
        if ([IPCCustomOrderDetailList instance].products.count) {
            IPCGlasses * product = [IPCCustomOrderDetailList instance].products[indexPath.row];
            if ([product filterType] == IPCTopFilterTypeCustomsizedContactLens || [product filterType] == IPCTopFilterTypeCustomsizedLens) {
                if ([IPCCustomOrderDetailList instance].orderInfo.isPackUpCustomized) {
                    id customizedRight = [product.customizedRight objectFromJSONString] ;
                    id customizedLeft   = [product.customizedLeft objectFromJSONString];
                    if (product.isUnifiedCustomizd) {
                        return 240 + ([customizedRight allKeys].count) * 20;
                    }
                    return 325 + ([customizedRight allKeys].count + [customizedLeft allKeys].count) * 20;
                }
                return 160;
            }
            return 115;
        }
    }else if (indexPath.section == 4){
        return 125;
    }else if (indexPath.section == 5){
        return 50;
    }else if (indexPath.section == 6 && indexPath.row > 0){
        return [IPCPayOrderMode sharedManager].payTypeRecordArray.count * 40;
    }else if (indexPath.section == 7){
        return 120;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 0;
    }
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width,  (section == 3 ? 0 : 5))];
    [footView setBackgroundColor:[UIColor clearColor]];
    return footView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark //IPCCustomerOrderDetailDelegate
- (void)reloadOrderDetailTableView{
    [self.orderDetailTableView reloadData];
}


@end
