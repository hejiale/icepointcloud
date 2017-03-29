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

@property (nonatomic, strong) NSMutableArray<IPCGlasses *> * products;
@property (nonatomic, strong) IPCCustomerOrderInfo  *  orderInfo;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCCustomerOrderInfo : NSObject

@property (nonatomic, copy, readonly) NSString *  customerName;
@property (nonatomic, copy, readonly) NSString *  customerMobilePhone;
@property (nonatomic, copy, readonly) NSString *  customerAddress;
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

@end


