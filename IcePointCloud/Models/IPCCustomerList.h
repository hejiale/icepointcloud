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

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCCustomerMode : NSObject

@property (copy, nonatomic, readwrite) NSString * photo_uuid;
@property (copy, nonatomic, readwrite) NSString * photo_url;
@property (copy, nonatomic, readwrite) NSString * customerName;
@property (copy, nonatomic, readwrite) NSString * customerID;
@property (copy, nonatomic, readwrite) NSString * customerAddress;
@property (copy, nonatomic, readwrite) NSString * customerPhone;
@property (copy, nonatomic, readwrite) NSString * email;
@property (copy, nonatomic, readwrite) NSString * birthday;
@property (copy, nonatomic, readwrite) NSString * gender;
@property (copy, nonatomic, readwrite) NSString * age;
@property (copy, nonatomic, readwrite) NSString * remark;
@property (copy, nonatomic, readwrite) NSString * integral;
@property (copy, nonatomic, readwrite) NSString * memberLevel;


@end
