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

@property (nonatomic, strong) NSMutableArray<IPCCustomerMode *> * list;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCCustomerMode : NSObject

@property (copy, nonatomic) NSString * photo_url;
@property (copy, nonatomic) NSString * customerName;
@property (copy, nonatomic) NSString * customerID;
@property (copy, nonatomic) NSString * customerAddress;
@property (copy, nonatomic) NSString * customerPhone;
@property (copy, nonatomic) NSString * email;
@property (copy, nonatomic) NSString * birthday;
@property (copy, nonatomic) NSString * gender;
@property (copy, nonatomic) NSString * age;
@property (copy, nonatomic) NSString * remark;


@end
