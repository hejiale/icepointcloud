//
//  DetailCustomerObject.h
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCDetailCustomer : NSObject

@property (nonatomic, copy, readwrite) NSString * customerID;
@property (nonatomic, copy, readwrite) NSString * birthday;
@property (nonatomic, copy, readwrite) NSString * remark;
@property (nonatomic, copy, readwrite) NSString * age;
@property (nonatomic, copy, readwrite) NSString * customerPhone;
@property (nonatomic, copy, readwrite) NSString * gender;
@property (nonatomic, copy, readwrite) NSString * customerName;
@property (nonatomic, copy, readwrite) NSString * memberLevel;
@property (nonatomic, copy, readwrite) NSString * membergrowth;
@property (nonatomic, copy, readwrite) NSString * memberPhone;
@property (nonatomic, assign, readwrite) double   consumptionAmount;
@property (nonatomic, assign, readwrite) double   balance;
@property (nonatomic, copy, readwrite) NSString * customerType;
@property (nonatomic, copy, readwrite) NSString * customerTypeId;
@property (nonatomic, assign, readwrite) NSInteger   integral;
@property (nonatomic, copy, readwrite) NSString * photo_url;
@property (nonatomic, assign, readwrite) double  discount;
@property (nonatomic, copy, readwrite) NSArray<IPCOptometryMode *>  * optometrys;

@end
