//
//  CustomOrderDetailObject.h
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCCustomerOrderInfo;
@interface IPCCustomerOrderDetail : NSObject

+ (IPCCustomerOrderDetail *)instance;

@property (nonatomic, strong, readwrite) NSMutableArray<IPCGlasses *> *  products;
@property (nonatomic, strong, readwrite) IPCCustomerOrderInfo               *  orderInfo;
@property (nonatomic, strong, readwrite) IPCCustomerAddressMode         *  addressMode;
@property (nonatomic, strong, readwrite) IPCOptometryMode                    *  optometryMode;

- (void)parseResponseValue:(id)responseValue;

@end

@interface IPCCustomerOrderInfo : NSObject

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
@property (nonatomic, assign, readonly) NSInteger    integral;
@property (nonatomic, assign, readonly) double   integralDeductionAmount;
@property (nonatomic, assign, readonly) double   donationAmount;
@property (nonatomic, assign, readonly) double   exchangeTotalIntegral;
@property (nonatomic, copy, readonly) NSString *  payType;
@property (nonatomic, assign, readonly) double    payTypeAmount;
@property (nonatomic, assign, readwrite) BOOL     isPackUpOptometry;
@property (nonatomic, assign, readwrite) BOOL     isPackUpCustomized;
@property (nonatomic, assign, readwrite) double   totalPayAmount;
@property (nonatomic, assign, readwrite) double    totalPointAmount;
@property (nonatomic, assign, readonly) double    deductionIntegral;
@property (nonatomic, assign, readwrite) BOOL     isCustomized;
@property (nonatomic, assign, readwrite) BOOL     isCustomizedLens;
@property (nonatomic, copy, readonly) NSString *  retainagePayType;//尾款支付方式
@property (nonatomic, assign, readwrite) double   retainagePayTypeAmount;//尾款支付金额

@end



