//
//  IPCPayOrderManager.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCPayRecord.h"
#import "IPCPayCashIntegralTrade.h"

@interface IPCPayOrderManager : NSObject

+ (IPCPayOrderManager *)sharedManager;

@property (nonatomic, copy, readwrite) NSString * currentCustomerId;//当前客户Id
@property (nonatomic, assign, readwrite) BOOL    isPayOrderStatus;// 设置订单付款状态

@property (nonatomic, assign, readwrite) double   payAmount;//合计金额

@property (nonatomic, assign, readwrite) double   discount;//折扣率
@property (nonatomic, assign, readwrite) double   customDiscount;//客户折扣率
@property (nonatomic, assign, readwrite) double   discountAmount;//优惠金额

@property (nonatomic, strong, readwrite) IPCEmployee * employee;//经办人
@property (nonatomic, copy, readwrite) NSString * remark;//订单备注
@property (nonatomic, strong, readwrite) IPCWareHouse * currentHouse;//当前店铺

@property (nonatomic, strong, readwrite) IPCPayCashIntegralTrade * integralTrade;//积分规则

@property (nonatomic, strong, readwrite) NSMutableArray<IPCPayRecord *> * payTypeRecordArray;//付款记录方式

//剩余付款金额
- (double)remainPayPrice;

//已付款金额总计
- (double)payRecordTotalPrice;

//计算优惠折扣
- (double)calculateDiscount;

//判断订单可否支付
- (BOOL)isCanPayOrder;

//清空收银记录
- (void)clearPayRecord;

//清空支付信息  选择客户信息  清空商品列表
- (void)resetData;


@end
