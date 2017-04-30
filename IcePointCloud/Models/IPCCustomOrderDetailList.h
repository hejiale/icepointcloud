//
//  CustomOrderDetailObject.h
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCCustomerOrderInfo;
@interface IPCCustomOrderDetailList : NSObject

+ (IPCCustomOrderDetailList *)instance;

@property (nonatomic, strong, readwrite) NSMutableArray<IPCGlasses *> * products;
@property (nonatomic, strong, readwrite) IPCCustomerOrderInfo  *  orderInfo;

- (void)parseResponseValue:(id)responseValue;

@end

@interface IPCCustomerOrderInfo : NSObject

@property (nonatomic, copy, readonly) NSString *  contactorName;
@property (nonatomic, copy, readonly) NSString *  contactorPhone;
@property (nonatomic, copy, readonly) NSString *  contactorAddress;
@property (nonatomic, copy, readonly) NSString *  contactorGender;
@property (nonatomic, copy, readonly) NSString *  status;
@property (nonatomic, copy, readonly) NSString *  orderCode;
@property (nonatomic, assign, readonly) double    totalPrice;
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
@property (nonatomic, copy, readonly) NSString *  addLeft;
@property (nonatomic, copy, readonly) NSString *  addRight;
@property (nonatomic, copy, readonly) NSString *  axisLeft;
@property (nonatomic, copy, readonly) NSString *  axisRight;
@property (nonatomic, copy, readonly) NSString *  sphLeft;
@property (nonatomic, copy, readonly) NSString *  sphRight;
@property (nonatomic, copy, readonly) NSString *  cylLeft;
@property (nonatomic, copy, readonly) NSString *  cylRight;
@property (nonatomic, copy, readonly) NSString *  correctedVisionLeft;
@property (nonatomic, copy, readonly) NSString *  correctedVisionRight;
@property (nonatomic, copy, readonly) NSString *  distanceLeft;
@property (nonatomic, copy, readonly) NSString *  distanceRight;
@property (nonatomic, copy, readonly) NSString *  optometryEmployee;
@property (nonatomic, copy, readonly) NSString *  optometryInsertDate;
@property (nonatomic, copy, readonly) NSString *  purpose;
@property (nonatomic, assign, readonly) double   exchangeTotalIntegral;
@property (nonatomic, copy, readonly) NSString *  payType;
@property (nonatomic, assign, readonly) double    payTypeAmount;
@property (nonatomic, assign, readwrite) BOOL     isPackUpOptometry;


@end


