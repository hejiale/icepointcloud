//
//  CustomerListObject.h
//  IcePointCloud
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCCustomerMode;
@interface IPCCustomerList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCCustomerMode *> * list;
@property (nonatomic, assign) NSInteger totalCount;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCCustomerMode : NSObject

@property (copy, nonatomic, readwrite) NSString * age;
@property (copy, nonatomic, readwrite) NSString * customerName;
@property (copy, nonatomic, readwrite) NSString * customerID;
@property (copy, nonatomic, readwrite) NSString * currentOptometryId;
@property (copy, nonatomic, readwrite) NSString * customerPhone;
@property (assign, nonatomic, readwrite) double   integral;
@property (copy, nonatomic, readwrite) NSString * memberLevel;
@property (copy, nonatomic, readwrite) NSString * memberCustomerId;
@property (copy, nonatomic, readwrite) NSString * memberPhone;
@property (assign, nonatomic, readwrite) double   balance;
@property (copy, nonatomic, readwrite) NSString * gender;
@property (copy, nonatomic, readwrite) NSString *   membergrowth;
@property (assign, nonatomic, readwrite) double      discount;
@property (nonatomic, assign, readwrite) double   consumptionAmount;
@property (nonatomic, copy, readwrite) NSString * customerType;
@property (nonatomic, copy, readwrite) NSString * customerTypeId;
@property (nonatomic, copy, readwrite) NSString * birthday;
@property (nonatomic, copy, readwrite) NSString * createStoreName;
@property (nonatomic, copy, readwrite) NSString * remark;

- (double)useDiscount;


@end
