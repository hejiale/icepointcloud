//
//  IPCPayCashAllCoupon.m
//  IcePointCloud
//
//  Created by gerry on 2018/6/20.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCPayCashAllCoupon.h"

@implementation IPCPayCashAllCoupon

- (instancetype)initWithResponseValue:(id)responseValue
{
    self = [super init];
    if (self) {
        [self.allCouponList removeAllObjects];
        [self.canUseCouponList removeAllObjects];
        
        if ([responseValue isKindOfClass:[NSDictionary class]]) {
            self.allCouponCount = [responseValue[@"allCashCouponCount"] integerValue];
            
            if ([responseValue[@"allCashCoupon"] isKindOfClass:[NSArray class]]) {
                [responseValue[@"allCashCoupon"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IPCPayOrderCoupon * coupon = [IPCPayOrderCoupon mj_objectWithKeyValues: obj];
                    [self.allCouponList addObject:coupon];
                }];
            }
            if ([responseValue[@"matchConditionCashCoupon"] isKindOfClass:[NSArray class]]) {
                self.canUseCouponCount = [responseValue[@"matchConditionCashCouponCount"] integerValue];
                
                [responseValue[@"matchConditionCashCoupon"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IPCPayOrderCoupon * coupon = [IPCPayOrderCoupon mj_objectWithKeyValues: obj];
                    [self.canUseCouponList addObject:coupon];
                }];
            }
        }
        
        
        
    }
    return self;
}

- (NSMutableArray<IPCPayOrderCoupon *> *)allCouponList
{
    if (!_allCouponList) {
        _allCouponList = [[NSMutableArray alloc]init];
    }
    return _allCouponList;
}

- (NSMutableArray<IPCPayOrderCoupon *> *)canUseCouponList{
    if (!_canUseCouponList) {
        _canUseCouponList = [[NSMutableArray alloc]init];
    }
    return _canUseCouponList;
}

@end
