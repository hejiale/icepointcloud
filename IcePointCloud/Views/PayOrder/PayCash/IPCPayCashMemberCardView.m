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
//@property (strong, nonatomic) NSMutableArray<IPCPayOrderCoupon *> * currentCoupons;
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

//- (void)matchCoupon:(IPCPayOrderCoupon *)coupon
//{
//    [self.coupon.canUseCouponList enumerateObjectsUsingBlock:^(IPCPayOrderCoupon * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.scopeType == coupon.scopeType) {
//            if ([obj.scopeType isEqualToString:@"PRODUCT"]) {
//                if (coupon.scopeBeans[@"prodId"] == obj.scopeBeans[@"prodId"]) {
//                    obj.isMatch = NO;
//                }
//            }else if ([obj.scopeType isEqualToString:@"BRAND_PROTYPE"]){
//                if ([obj.scopeBeans isKindOfClass:[NSArray class]]) {
//                    [obj.scopeBeans enumerateObjectsUsingBlock:^(id  _Nonnull brandType, NSUInteger idx, BOOL * _Nonnull stop) {
//                        if ([coupon.scopeBeans isKindOfClass:[NSArray class]]) {
//                            [coupon.scopeBeans enumerateObjectsUsingBlock:^(id  _Nonnull sBrandType, NSUInteger idx, BOOL * _Nonnull stop) {
//                                if (brandType[@"brand"] = sBrandType[@"brand"]) {
//                                    if ([brandType[@"prodTypes"] isKindOfClass:[NSArray class]]) {
//                                        [brandType[@"prodTypes"] enumerateObjectsUsingBlock:^(id  _Nonnull proType, NSUInteger idx, BOOL * _Nonnull stop) {
//                                            if ([sBrandType[@"prodTypes"] isKindOfClass:[NSArray class]]) {
//                                                [sBrandType[@"prodTypes"] enumerateObjectsUsingBlock:^(id  _Nonnull sProType, NSUInteger idx, BOOL * _Nonnull stop) {
//                                                    if ([proType isEqualToString:sProType]) {
//                                                        if (!obj.isSelected) {
//                                                            obj.isMatch = NO;
//                                                        }
//                                                    }
//                                                }];
//                                            }
//                                        }];
//                                    }
//                                }
//                            }];
//                        }
//                    }];
//                }
//            }else if ([obj.scopeType isEqualToString:@"PROTYPE"]){
//                if ([obj.scopeBeans isKindOfClass:[NSArray class]]) {
//                    [obj.scopeBeans enumerateObjectsUsingBlock:^(id  _Nonnull proType, NSUInteger idx, BOOL * _Nonnull stop) {
//                        if ([coupon.scopeBeans isKindOfClass:[NSArray class]]) {
//                            [coupon.scopeBeans enumerateObjectsUsingBlock:^(id  _Nonnull sProType, NSUInteger idx, BOOL * _Nonnull stop) {
//                                if ([sProType[@"productType"] isEqualToString:proType[@"productType"]]) {
//                                    obj.isMatch = NO;
//                                }
//                            }];
//                        }
//                    }];
//                }
//            }else if ([obj.scopeType isEqualToString:@""]){
//
//            }
//        }
//    }];
//    coupon.isMatch = YES;
//    [self.memberCardListView reloadData];
//}

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
