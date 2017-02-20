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

@property (nonatomic, copy) NSString *  customerName;
@property (nonatomic, copy) NSString *  customerMobilePhone;
@property (nonatomic, copy) NSString *  customerAddress;
@property (nonatomic, copy) NSString *  status;
@property (nonatomic, copy) NSString *  orderCode;
@property (nonatomic, assign) double    totalPrice;
@property (nonatomic, copy) NSString *  orderNumber;
@property (nonatomic, copy) NSString *  orderTime;
@property (nonatomic, copy) NSString *  operatorName;
@property (nonatomic, copy) NSString *  finishTime;
@property (nonatomic, copy) NSString *  dispatchTime;
@property (nonatomic, copy) NSString *  remark;
@property (nonatomic, assign) double   beforeDiscountPrice;
@property (nonatomic, assign) double   deposit;//Prepaid amount

@end


