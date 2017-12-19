//
//  CustomOrderDetailObject.h
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCPayRecord.h"

@class IPCCustomerOrderInfo;
@interface IPCCustomerOrderDetail : NSObject

+ (IPCCustomerOrderDetail *)instance;

@property (nonatomic, strong, readwrite) NSMutableArray<IPCGlasses *> *  products;
@property (nonatomic, strong, readwrite) NSMutableArray<IPCPayRecord *> * recordArray;
@property (nonatomic, strong, readwrite) IPCCustomerOrderInfo               *  orderInfo;
@property (nonatomic, strong, readwrite) IPCOptometryMode                    *  optometryMode;

- (void)parseResponseValue:(id)responseValue;

- (void)clearData;

@end

@interface IPCCustomerOrderInfo : NSObject

@property (nonatomic, copy, readonly) NSString *  customerId;
@property (nonatomic, copy, readonly) NSString *  status;
@property (nonatomic, copy, readonly) NSString *  orderCode;
@property (nonatomic, assign, readwrite) double    totalPrice;
@property (nonatomic, copy, readonly) NSString *  orderNumber;
@property (nonatomic, copy, readonly) NSString *  orderTime;
@property (nonatomic, copy, readonly) NSString *  operatorName;
@property (nonatomic, copy, readonly) NSString *  finishTime;
@property (nonatomic, copy, readonly) NSString *  dispatchTime;
@property (nonatomic, copy, readonly) NSString *  remark;
@property (nonatomic, assign, readonly) double   beforeDiscountPrice;
@property (nonatomic, assign, readonly) double   deposit;//Prepaid amount
@property (nonatomic, assign, readonly) double   usebalanceAmount;
@property (nonatomic, assign, readonly) double   totalSuggestPrice;
@property (nonatomic, assign, readonly) double   totalBizPrice;
@property (nonatomic, assign, readonly) double   afterDiscountPrice;
@property (nonatomic, assign, readonly) double   afterIntegralDeductionPrice;
@property (nonatomic, assign, readonly) NSInteger    integralGiven;
@property (nonatomic, assign, readonly) double   integralDeductionAmount;
@property (nonatomic, assign, readonly) double   donationAmount;
@property (nonatomic, assign, readonly) double   exchangeTotalIntegral;
@property (nonatomic, copy, readonly) NSString *  payType;
@property (nonatomic, assign, readonly) double    payTypeAmount;
@property (nonatomic, assign, readwrite) BOOL     isPackUpOptometry;
@property (nonatomic, assign, readwrite) double   totalPayAmount;
@property (nonatomic, assign, readwrite) double    totalPointAmount;
@property (nonatomic, assign, readonly) double    deductionIntegral;
@property (nonatomic, assign, readwrite) double    remainAmount;//订单详情中剩余付款金额
@property (nonatomic, copy, readonly) NSString * auditResult;
@property (nonatomic, copy, readonly) NSString * auditStatus;

- (NSString *)orderStatus;

@end



