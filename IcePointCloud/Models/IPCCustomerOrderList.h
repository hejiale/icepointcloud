//
//  CustomerOrderListObject.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCCustomerOrderMode;
@interface IPCCustomerOrderList : NSObject

@property (nonatomic, strong) NSMutableArray<IPCCustomerOrderMode *> * list;
@property (nonatomic, assign) NSInteger  totalCount;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCCustomerOrderMode : NSObject

@property (nonatomic, copy) NSString * orderID;
@property (nonatomic, copy) NSString * orderCode;
@property (nonatomic, copy) NSString * orderDate;
@property (nonatomic, copy) NSString * orderStatus;
@property (nonatomic, assign) double   orderPrice;
@property (nonatomic, copy) NSString * type;

@end

