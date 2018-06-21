//
//  IPCPayCashMemberCardView.m
//  IcePointCloud
//
//  Created by gerry on 2018/6/19.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayCashMemberCardView.h"
#import "IPCPayOrderCouponCell.h"

static NSString * const couponCellIdentifier = @"IPCPayOrderCouponCellIdentifier";

@interface IPCPayCashMemberCardView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *canUseButton;
@property (weak, nonatomic) IBOutlet UIButton *allUseButton;
@property (weak, nonatomic) IBOutlet UITableView *memberCardListView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IPCPayCashAllCoupon * coupon;
@property (strong, nonatomic) IPCPayOrderCoupon * currentCoupon;
@property (copy, nonatomic) void(^CompleteBlock)();

@end

@implementation IPCPayCashMemberCardView

- (instancetype)initWithFrame:(CGRect)frame Coupon:(IPCPayCashAllCoupon *)coupon Complete:(void(^)())complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CompleteBlock = complete;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayCashMemberCardView" owner:self];
        view.frame = frame;
        [self addSubview:view];
        
        self.coupon = coupon;
        self.currentCoupon = [IPCPayOrderManager sharedManager].coupon;
        
        [self.cancelButton addBorder:2 Width:1 Color:[UIColor colorWithHexString:@"#D9D9D9"]];
        [self.canUseButton jk_addBottomBorderWithColor:[UIColor colorWithHexString:@"#3DA8F5"] width:2];
        [self.memberCardListView setTableHeaderView:[[UIView alloc]init]];
        [self.memberCardListView setTableFooterView:[[UIView alloc]init]];
    }
    return self;
}


#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)sureAction:(id)sender
{
    [IPCPayOrderManager sharedManager].coupon = self.currentCoupon;
    
    if ([[IPCPayOrderManager sharedManager] remainNoneCouponPayPrice] < self.currentCoupon.denomination) {
        [IPCPayOrderManager sharedManager].couponAmount = [[IPCPayOrderManager sharedManager] remainNoneCouponPayPrice];
    }else{
        [IPCPayOrderManager sharedManager].couponAmount  = self.currentCoupon.denomination;
    }
    [self removeFromSuperview];
    
    if (self.CompleteBlock) {
        self.CompleteBlock();
    }
}


- (IBAction)chooseCanUseAction:(id)sender {
    [self.canUseButton jk_addBottomBorderWithColor:[UIColor colorWithHexString:@"#3DA8F5"] width:2];
    [self.allUseButton jk_addBottomBorderWithColor:nil width:0];
    [self.canUseButton setSelected:YES];
    [self.allUseButton setSelected:NO];
    [self.memberCardListView reloadData];
}

- (IBAction)chooseAllUseAction:(id)sender {
    [self.canUseButton jk_addBottomBorderWithColor:nil width:0];
    [self.allUseButton jk_addBottomBorderWithColor:[UIColor colorWithHexString:@"#3DA8F5"] width:2];
    [self.canUseButton setSelected:NO];
    [self.allUseButton setSelected:YES];
    [self.memberCardListView reloadData];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.coupon) {
        if (self.canUseButton.selected) {
            return  self.coupon.canUseCouponCount;
        }
        return self.coupon.allCouponCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPCPayOrderCouponCell * cell = [tableView dequeueReusableCellWithIdentifier:couponCellIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCPayOrderCouponCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    
    if (self.coupon) {
        IPCPayOrderCoupon * coupon = nil;
        
        if (self.canUseButton.selected) {
            coupon = self.coupon.canUseCouponList[indexPath.row];
        }else{
            coupon = self.coupon.allCouponList[indexPath.row];
        }
        
        cell.coupon = coupon;
        
        if ([self.currentCoupon.couponId isEqualToString:coupon.couponId] && self.currentCoupon && self.canUseButton.selected) {
            [cell refreshStatus:YES];
        }else{
            [cell refreshStatus:NO];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark //UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.coupon && self.canUseButton.selected) {
        IPCPayOrderCoupon * coupon = nil;
        
        if (self.canUseButton.selected) {
            coupon = self.coupon.canUseCouponList[indexPath.row];
        }else{
            coupon = self.coupon.allCouponList[indexPath.row];
        }
        
        if ([self.currentCoupon.couponId isEqualToString:coupon.couponId]) {
            self.currentCoupon = nil;
        }else{
            self.currentCoupon = coupon;
        }
    }
    
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
