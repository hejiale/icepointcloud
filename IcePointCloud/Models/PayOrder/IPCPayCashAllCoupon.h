//
//  IPCPayCashAllCoupon.h
//  IcePointCloud
//
//  Created by gerry on 2018/6/20.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCPayOrderCoupon.h"

@interface IPCPayCashAllCoupon : NSObject

@property (nonatomic, strong) NSMutableArray<IPCPayOrderCoupon *> * allCouponList;
@property (nonatomic, strong) NSMutableArray<IPCPayOrderCoupon *> * canUseCouponList;
@property (nonatomic, assign) NSInteger   allCouponCount;
@property (nonatomic, assign) NSInteger   canUseCouponCount;

- (instancetype)initWithResponseValue:(id)responseValue;


@end
