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
#import "IPCPayOrderPayType.h"

@interface IPCPayOrderManager : NSObject

+ (IPCPayOrderManager *)sharedManager;
//当前客户Id
@property (nonatomic, copy, readwrite) NSString * currentCustomerId;
//当前客户验光单Id
@property (nonatomic, copy, readwrite) NSString * currentOptometryId;
//合计金额
@property (nonatomic, assign, readwrite) double   payAmount;
//折扣率
@property (nonatomic, assign, readwrite) double   discount;
//客户折扣率
@property (nonatomic, assign, readwrite) double   customDiscount;
//优惠金额
@property (nonatomic, assign, readwrite) double   discountAmount;
//经办人
@property (nonatomic, strong, readwrite) IPCEmployee * employee;
//订单备注
@property (nonatomic, copy, readwrite) NSString * remark;
//当前店铺
@property (nonatomic, strong, readwrite) IPCWareHouse * currentHouse;
//积分规则
@property (nonatomic, strong, readwrite) IPCPayCashIntegralTrade * integralTrade;
//付款记录方式
@property (nonatomic, strong, readwrite) NSMutableArray<IPCPayRecord *> * payTypeRecordArray;
//支付方式
@property (nonatomic, strong) NSMutableArray<IPCPayOrderPayType *> * payTypeArray;
//是否正在添加付款记录
@property (nonatomic, assign, readwrite) BOOL  isInsertRecord;
//是否会员验证通过
@property (nonatomic, assign, readwrite) BOOL  isValiateMember;
//重新计算应收合计
- (void)calculatePayAmount;
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
//获取支付方式
- (void)queryPayType;
//初始化经办人
- (void)resetEmployee;


@end
